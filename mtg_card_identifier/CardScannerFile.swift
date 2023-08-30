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

    
    
    //    @Binding var startScanning: Bool
    @Binding var scanedText: [String]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        
        let vc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true
            //            isGuidanceEnabled: true,
            //            Don't know if we want that to work but it's basically done
            //            isHighlightingEnabled: true
        )
        let partialTransparentView = PartialTransparentView(cutout: CGRect(x: 31, y: 75, width: 350, height: 470))
        partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
        partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        partialTransparentView.frame = vc.overlayContainerView.bounds
        
        vc.view.addSubview(partialTransparentView)
        vc.regionOfInterest = CGRect(x: 31, y: 75, width: 350, height: 430)
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
        var parent: LiveTextScanner
        
        init(_ parent: LiveTextScanner) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handleItems(allItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handleItems(allItems)
        }
        
        func handleItems(_ items: [RecognizedItem]) {
            print("Items count : \(items.count)")
            parent.scanedText = items.compactMap { $0.text }
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

//This works to make a cutout for the view but am not sure how or why haha.
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
        
        
        let path = UIBezierPath(roundedRect: cutout, cornerRadius: 20)
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
