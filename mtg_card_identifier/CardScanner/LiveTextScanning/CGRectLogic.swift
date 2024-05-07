//
//  CGRectLogic.swift
//  mtg_card_identifier
//
//  Created by mac on 9/15/23.
//
///                width / height
///                magic cards AspectRatio 2.5 / 3.5 = .714
import UIKit
import SwiftUI


extension CGRect {
    func largestCenteredRect(with aspectRatio: Double, padding: CGFloat) -> CGRect {
        guard aspectRatio > 0 else {
            return CGRect.zero
        }

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
