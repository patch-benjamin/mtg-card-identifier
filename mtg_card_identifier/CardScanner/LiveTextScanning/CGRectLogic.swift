//
//  CGRectLogic.swift
//  mtg_card_identifier
//
//  Created by mac on 9/15/23.
//

import UIKit
import SwiftUI


extension CGRect {
    func largestCenteredRect(with aspectRatio: Double, padding: CGFloat) -> CGRect {
        guard aspectRatio > 0 else {
            return CGRect.zero
        }
///                width / height
///                magic cards AspectRatio 2.5 / 3.5 = .714
        ///                
        let selfAspectRatio = self.width / self.height // aspect ratio of the phone
        
        if selfAspectRatio > aspectRatio {
            // self is wider than aspectRatio. That means the rect we return should be full height of self - you'll have padding on the right and left.
            //  ___X_______
            //  | padding |
            //  Y   ___   |
            //  |   |X|   |
            //  |   |X|   |
            //  |   |X|   |
            //  |   |X|   |
            //  |   ---   |
            //  | padding |
            //  -----------
            let paddedHeight = self.height - padding * 2
            
            let returnWidth = paddedHeight * aspectRatio
            let returnHeight = paddedHeight
            let returnY = padding
            let returnX = (self.width - returnWidth) / 2
            return CGRect(x: returnX, y: returnY, width: returnWidth, height: returnHeight)
            
        } else if selfAspectRatio < aspectRatio {
            // self is taller than aspectRatio. That means the rect we return should be full width of self.
            //  _X_____
            //  |     |
            //  Y ___ |
            //  |P|X|P|
            //  | --- |
            //  |     |
            //  -------
            let paddedWidth = self.width - padding * 2
            
            let returnWidth = paddedWidth
            let returnHeight = paddedWidth / aspectRatio
            let returnY = (self.height - returnHeight) / 2
            let returnX = padding
            return CGRect(x: returnX, y: returnY, width: returnWidth, height: returnHeight)
            
        } else {
            // aspect ratios are the same
            // shape will be the same, but padding*2 smaller
            let returnX = padding
            let returnY = padding
            let returnWidth = self.width - padding * 2
            let returnHeight = self.height - padding * 2
            return CGRect(x: returnX, y: returnY, width: returnWidth, height: returnHeight)
        }
    }
}

// TODO: Try and make this a SwiftUI View
//Pull partialTransparentView into this.
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

struct LiveTextScanningViewWrapper: View {
    var body: some View {
        GeometryReader { geometry in
            
            let screenSize = geometry.frame(in: .global)
            let cardRect = screenSize.largestCenteredRect(with: 0.714, padding: 15)
            
            let originX = (screenSize.width - cardRect.width) / 2
            let originY = (screenSize.height - cardRect.height) / 2
            let regionOfInterest = CGRect(x: originX, y: originY, width: cardRect.width, height: cardRect.height)

           let overlay = Rectangle()
                .fill(Color.black.opacity(0.3))
                .blendMode(.destinationOut)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .mask(Rectangle()
                    .frame(width: regionOfInterest.width, height: regionOfInterest.height)
                    .offset(x: regionOfInterest.origin.x, y: regionOfInterest.origin.y)
                )
    
            LiveTextScannerView(scannedText: .constant([]), overlay: overlay, regionOfInterest: regionOfInterest)
        }
    }
}

// MARK: TEST
//            find the window and make the region of interest, init as well, and then return the style of it.
// Add a landScape one to the iPad.
//Get the aspect ratio for the card.
//
//func rect() -> CGRect {
//    let screenHeight = UIScreen.main.bounds.height
//    let screenWidth = UIScreen.main.bounds.width
//
//    let centerX = screenWidth / 2
//    let centerY = screenHeight / 3
//
//    let overlaySize = CGSize(width: screenWidth * 0.8, height: screenHeight * 0.5)
////        let overlayView = CGRect(x: centerX - overlaySize.width / 2, y: centerY - overlaySize.height / 2, width: overlaySize.width, height: overlaySize.height)
//    let region = CGRect(x: centerX - overlaySize.width / 2, y: centerY - overlaySize.height / 2, width: overlaySize.width, height: overlaySize.height)
//    overlay.frame(forAlignmentRect: region)
//
//    let partialTransparentView = PartialTransparentView(cutout: region)
//    partialTransparentView.translatesAutoresizingMaskIntoConstraints = true
//    partialTransparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        partialTransparentView.frame = vc.overlayContainerView.bounds
//
//    return Style(overlay: overlay, regionOfInterest: region, partialTransparentView: partialTransparentView)
//}
