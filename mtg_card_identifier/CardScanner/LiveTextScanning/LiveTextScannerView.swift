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

struct LiveTextScannerView: View {
    var scanedText: Binding<[String]>
    let overlay: (any View)?
    let regionOfInterest: CGRect?
    
    @State private var authorizationStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    init(scannedText: Binding<[String]>, overlay: (any View)?, regionOfInterest: CGRect?) {
        self.scanedText = scannedText
        self.overlay = overlay
        self.regionOfInterest = regionOfInterest
        
    }
    
    var body: some View {
        switch authorizationStatus {
        case .notDetermined:
            Color.black
                .onAppear {
                    requestAccess()
                }
        case .restricted, .denied:
            NoCameraAccessView()
        case .authorized:
            NavigationStack {
                ZStack {
                    LiveTextScanner(scanedText: scanedText, regionOfInterest: regionOfInterest)
//                    if let overlay {
//                        overlay
//                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button() {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
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
