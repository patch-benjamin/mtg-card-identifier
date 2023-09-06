//
//  CardScannerFile.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
import UIKit
import VisionKit

struct LiveTextScanner: UIViewControllerRepresentable {
    
    // Will need more than just a string when we are doing the api call.
    var scanedText: Binding<[String]>
    var style: Style
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanedTextBinding: scanedText)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
//        The x and y needs the math part, going from the window to access the screen which will let you work with the bounds.
        
        
        let vc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true
            //            isGuidanceEnabled: true,
            //            Don't know if we want that to work but it's basically done
            //            isHighlightingEnabled: true
        )
        
        
        let partialTransparentView = PartialTransparentView(cutout: style.overlay)
        partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
        partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        partialTransparentView.frame = vc.overlayContainerView.bounds
        
        vc.view.addSubview(partialTransparentView)
        vc.regionOfInterest = style.regionOfInterest
        vc.delegate = context.coordinator
        
        do {
            try vc.startScanning()
            
        } catch {
            
            print("Error: \(error.localizedDescription)")
        }
        
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
    }
    
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
                switch item {
                case .text(let text):
                    print("Scanned words: \(text.transcript)")
                default: break
                }
            }
        }
    }
}


class PartialTransparentView: UIView {
    var cutout: CGRect?
    
    init(cutout: CGRect?) {
        super.init(frame: .zero)
        self.cutout = cutout
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)
        guard let cutout = cutout else { return }
        
        
        let path = UIBezierPath(roundedRect: cutout, cornerRadius: 10)
        let intersection = rect.intersection(cutout)
        UIRectFill(intersection)
        
        UIColor.clear.setFill()
        UIGraphicsGetCurrentContext()?.setBlendMode(.copy)
        path.fill()
    }
}

// MARK: Extension
//            find the window and make the region of interest, init as well, and then return the style of it.
struct Style {
    let overlay: CGRect
    let regionOfInterest: CGRect
  
    static var cardShape: Style {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        let centerX = screenWidth / 2
        let centerY = screenHeight / 3
        
        let overlaySize = CGSize(width: screenWidth * 0.8, height: screenHeight * 0.5)
        let overlayView = CGRect(x: centerX - overlaySize.width / 2, y: centerY - overlaySize.height / 2, width: overlaySize.width, height: overlaySize.height)
        let region = CGRect(x: centerX - overlaySize.width / 2, y: centerY - overlaySize.height / 2, width: overlaySize.width, height: overlaySize.height)
        
       
        
        return Style(overlay: overlayView, regionOfInterest: region)
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
