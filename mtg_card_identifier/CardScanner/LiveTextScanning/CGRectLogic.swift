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
        
        let height = Int(self.height * aspectRatio)
        let width = Int(self.width * aspectRatio)
        //    compare the aspectratio passed in agaist self for rect
        
        if self.height > self.width {
            //            its protrait
            return CGRect(x: (Int(self.width) - width) / 2, y: 0, width: width, height: height)
        } else if self.width > self.height {
            //            its landscape
            return CGRect(x: (Int(self.width) - width) / 2, y: 0, width: width, height: height)
        } else   {
            //            its sqaure
            return CGRect(x: (Int(self.width) - width) / 2, y: 0, width: width, height: height)
        }
        
        
        //        Use TDD
        //        width / height
        //        magic cards AspectRatio 2.5 / 3.5 = .714
        
        
        
        // TODO: create Unit tests for this function that test it on different sizes/orientations.
        //        return CGRect(x: (Int(self.width) - width) / 2, y: 0, width: width, height: Int(self.height))
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
            // TODO: actually fill this out, the below code is an example of the concept.
            let screenSize = geometry.frame(in: .global)
            let cardRect = screenSize.largestCenteredRect(with: 2, padding: 15)
            
            let originX = (screenSize.width - cardRect.width) / 2
            let originY = (screenSize.height - cardRect.height) / 2
            let regionOfInterest = CGRect(x: originX, y: originY, width: cardRect.width, height: cardRect.height)
            
            // calculate the biggest dimensions of a card that you could fit in the frame.size
            // create an overlay view that fills in the extra space around the sides of that size
            // create a region of interest with that size, figuring out what the `origin` of it needs to be so it's "centered"
            LiveTextScannerView(scannedText: .constant([]), overlay: Color.blue.padding(.all, 50), regionOfInterest: screenSize)
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
