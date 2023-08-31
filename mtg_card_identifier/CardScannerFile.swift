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
    
    
    var scanedText: Binding<[String]>
    var overlay: UIView? = nil
    
    // Will probably need more than just a string when we are doing the api call.
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanedTextBinding: scanedText)
    }
    
    
//    enum ScannerOverlay {
//        case card(cardDemenions: CGSize)
//        case .none
//
//        var view: UIView? {
//            switch self {
//            case .card(let cardDemenions):
//
//                let partialTransparentView = PartialTransparentView(cutout: cardShape)
//                partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
//                partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            }
//        }
//    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        var cardShape = CGRect(x: 31, y: 75, width: 350, height: 470)
        
        let vc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true
            //            isGuidanceEnabled: true,
            //            Don't know if we want that to work but it's basically done
            //            isHighlightingEnabled: true
        )
        
        
        let partialTransparentView = PartialTransparentView(cutout: cardShape)
        partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
        partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        partialTransparentView.frame = vc.overlayContainerView.bounds
        
        vc.view.addSubview(partialTransparentView)
        vc.regionOfInterest = cardShape
        vc.delegate = context.coordinator
        
        do {
            try vc.startScanning()
            
        } catch {
            
            print("Error: \(error.localizedDescription)")
        }
        
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        //        this function is needed for the "UIViewControllerRepresentable"
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

//extension UIView {
//    static let cardOverlay: UIView = CGSize()
//
//
//    let partialTransparentView = PartialTransparentView(cutout: cardOverlay)
//    partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
//    partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    partialTransparentView.frame = vc.overlayContainerView.bounds
//
//}
