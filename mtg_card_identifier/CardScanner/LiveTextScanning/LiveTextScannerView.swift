//
//  CardScannerFile.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
import UIKit
import VisionKit
import AVFoundation

struct LiveTextScannerView<Overlay: View>: View {
    var scanedText: Binding<[String]>
    let overlay: Overlay?
    let regionOfInterest: CGRect?
    
    @State private var authorizationStatus: AVAuthorizationStatus
    
    init(scannedText: Binding<[String]>, overlay: Overlay?, regionOfInterest: CGRect?, authorizationStatus: AVAuthorizationStatus? = nil) {
        self.scanedText = scannedText
        self.overlay = overlay
        self.regionOfInterest = regionOfInterest
        self._authorizationStatus = .init(initialValue: authorizationStatus ?? AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    var body: some View {
        switch authorizationStatus {
        case .notDetermined:
            VStack {
                HStack {
                    Spacer()
                    Text("Waiting for authorization...")
                        .onAppear {
                            requestAccess()
                        }
                    Spacer()
                }
            }
        case .restricted, .denied:
            NoCameraAccessView()
        case .authorized:
            ZStack {
                
                
                LiveTextScanner(scanedText: scanedText, regionOfInterest: regionOfInterest)
//                Putting the overlay here worked, idk if its how it should be but it does work quite well haha.
                overlay
            }
            .toolbar {
                ToolbarItem {
                    Button() {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        @unknown default:
            fatalError() // FIXME:
        }
    }
    
    func requestAccess() {
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { accessGranted in
                self.authorizationStatus = accessGranted ? .authorized : .denied
            }
        default:
            break
        }
    }
    
}

//class GlobalOverlayView: UIView {
//    let screenSize: CGSize
//    let regionOfInterest: CGRect
//    
//    init(screenSize: CGSize, regionOfInterest: CGRect) {
//        self.screenSize = screenSize
//        self.regionOfInterest = regionOfInterest
//        super.init(frame: .zero)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setup() {
//        let background = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
//        background.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        addSubview(background)
//        
//        let cardCutout = UIView(frame: CGRect(x: regionOfInterest.origin.x, y: regionOfInterest.origin.y, width: regionOfInterest.width, height: regionOfInterest.height))
//        cardCutout.layer.cornerRadius = regionOfInterest.height / 10
//        cardCutout.backgroundColor = .clear
//        addSubview(cardCutout)
//    }
//}
//Gives the black cutout but nothing on the back so its basically useless maybe....

private struct LiveTextScanner: UIViewControllerRepresentable {
    var scanedText: Binding<[String]>
    let regionOfInterest: CGRect?
    var showTextBoundingRect = false
    func makeCoordinator() -> Coordinator {
        Coordinator(scanedTextBinding: scanedText)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: showTextBoundingRect
        )
//        let overlayView = GlobalOverlayView(screenSize: UIScreen.main.bounds.size, regionOfInterest: regionOfInterest!)
//            vc.view.addSubview(overlayView)
//            I'm thinking if I can add a subview here of the overlay in cardscanner because it needs to be over this vc not under, which it looks like it is in cardScannerView since the overlay doesnt show up but it looks like its under the LiveTextScannerView I call.
        vc.regionOfInterest = regionOfInterest
        vc.delegate = context.coordinator
        try? vc.startScanning()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    
    @MainActor
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var scanedTextBinding: Binding<[String]>
        
        init(scanedTextBinding: Binding<[String]>) {
            self.scanedTextBinding = scanedTextBinding
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handleItems(allItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handleItems(allItems)
        }
        
        func handleItems(_ items: [RecognizedItem]) {
            print("Items count : \(items.count)")
            scanedTextBinding.wrappedValue = items.compactMap { $0.text }
            items.forEach { item in
                print("Scanned words: \(item.text ?? "")")
            }
        }
    }
}

extension RecognizedItem {
    var text: String? {
        switch self {
        case .text(let text):
            return text.transcript
        default:
            return nil
        }
    }
}
