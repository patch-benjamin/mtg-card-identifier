//
//  mtg_card_identifierTests.swift
//  mtg_card_identifierTests
//
//  Created by Benjamin Patch on 6/2/23.
//

import XCTest
@testable import mtg_card_identifier

final class aspectRatioTests: XCTestCase {
    /// width / height
    /// magic cards AspectRatio 2.5 / 3.5 = .714
    let cardAspectRatio = 0.714285714285714
    //    func testWideRectangleAndTallAspectRatioWithZeroPadding() throws {
    //        var cgRect = CGRect(x: 0, y: 0, width: 500, height: 300)
    //
    //        XCTAssertEqual(cgRect.largestCenteredRect(with: 0.5, padding: 0), CGRect(x: 175, y: 0, width: 150, height: 300))
    //    }
    
    // MARK: Smallest iPhone tests.
    func testMagicCardAspectRatioIphone8WithZeroPadding() throws {
        let iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        // phone aspectratio = 0.562218891
        // phone is taller than card
        // card should be x=0
        // card should be full width
        // card should be height 750 / cardAspectRatio
        
        
        //        might be mulitplying width by card asepct ratio
        // X isthe horizental and Y is veritcal
        let width: CGFloat = 750
        let height = width / cardAspectRatio
        let y = (1334 - height) / 2
        
        XCTAssertEqual(iPhone8.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: 0, y: y, width: width, height: height))
        //        y would be (1334 - 952) / 2 for equal space on top and bottom.

    }
    
    func testMagicCardAspectRatioInIphone8WithPadding() throws {
//        750 - 20* 2 = what the width should be. for padding on both sides. x shoud be the padding so 20.
        
        let iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        
        let width: CGFloat = 750
        let paddedWidth = width - 20 * 2
        let height = paddedWidth / cardAspectRatio
        let y = (1334 - height) / 2
        
        let padding: CGFloat = 20
        
        XCTAssertEqual(iPhone8.largestCenteredRect(with: cardAspectRatio, padding: 20), CGRect(x: padding, y: y, width: paddedWidth, height: height))
        
        //        y would be (1334 - 952) / 2 = 858 for equal space on top and bottom.
//        try drawing a small version out. for the box within a box

    }
    
    // MARK: Biggest iPhone tests.
    func testMagicCardAspectRatioIphone15ProWithZeroPadding() throws {
        
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
        
//        iphone 15 plus aspectRatio is .46137339
        let width: CGFloat = 1290
        let height = width / cardAspectRatio
        let y = (2796 - height) / 2
        
        
        XCTAssertEqual(iphone15Plus.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: 0, y: y, width: width, height: height))
    }
    
    func testMagicCardAspectRatioIphone15ProWithPadding() throws {
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
        
        let padding: CGFloat = 20
        let width: CGFloat = 1290
        let paddedWidth = width - padding * 2
        let height = paddedWidth / cardAspectRatio
        let y = (2796 - height) / 2
        
        
        XCTAssertEqual(iphone15Plus.largestCenteredRect(with: cardAspectRatio, padding: 20), CGRect(x: padding, y: y, width: paddedWidth, height: height))
    }
    
    // MARK: Smallest iPads tests.
    func testMagicCardAspectRatioIpadMiniPortraitWithZeroPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)

        
        let width: CGFloat = 1488
        let height = width / cardAspectRatio
        let y = (2266 - height) / 2
        
        XCTAssertEqual(iPadMiniProtrait.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: 0, y: y, width: width, height: height))
    }
    
    func testMagicCardAspectRatioIpadMiniPortraitWithPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        
        let padding: CGFloat = 100
        let width: CGFloat = 1488
        let paddedWidth = width - padding * 2
        let height = paddedWidth / cardAspectRatio
        let y = (2266 - height) / 2
        
        
        XCTAssertEqual(iPadMiniProtrait.largestCenteredRect(with: cardAspectRatio, padding: 100), CGRect(x: padding, y: y, width: paddedWidth, height: height))
    }
    
    func testMagicCardAspectRatioIpadMiniLandscapeWithZeroPadding() throws {
        
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
        
        let height: CGFloat = 1488
        let width = height * cardAspectRatio
        let x = (2266 - width) / 2
        
        XCTAssertEqual(iPadMiniLandscape.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: x, y: 0, width: width, height: height))
    }
    
    func testMagicCardAspectRatioIpadMiniLandscapeWithPadding() throws {
        
        let iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
        
        let padding: CGFloat = 100
        let height: CGFloat = 1488
        let paddedHeight = height - padding * 2
        let width = paddedHeight * cardAspectRatio
        
        let x = (2266 - width) / 2
        
        XCTAssertEqual(iPadMiniLandscape.largestCenteredRect(with: cardAspectRatio, padding: 100), CGRect(x: x, y: padding, width: width, height: paddedHeight))
    }
    
    // MARK: Biggest iPads tests.
    func testMagicCardAspectRatioIpadProPortraitWithZeroPadding() throws {
        let iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
//        aspect ratio is .7496
        
        let height: CGFloat = 2732
        let width = height * cardAspectRatio
        let x = (2048 - width) / 2
        
        
        XCTAssertEqual(iPadProPortrait.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: x, y: 0, width: width, height: height))
        
    }
    
    func testMagicCardAspectRatioIpadProPortraitWithPadding() throws {
        let iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        
        let padding: CGFloat = 100
        
        let height: CGFloat = 2732
        let paddedHeight = height - padding * 2
        let width = paddedHeight * cardAspectRatio
        let x = (2048 - width) / 2
        
        XCTAssertEqual(iPadProPortrait.largestCenteredRect(with: cardAspectRatio, padding: 100), CGRect(x: x, y: padding, width: width, height: paddedHeight))
        
    }
    
    func testMagicCardAspectRatioInIpadProLandscapeWithZeroPadding() throws {
        
        let iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
//        aspect ratio is 1.3
        
        let height: CGFloat = 2048
        let width = height * cardAspectRatio
        let x = (2732 - width) / 2
        
        XCTAssertEqual(iPadProLandscape.largestCenteredRect(with: cardAspectRatio, padding: 0), CGRect(x: x, y: 0, width: width, height: height))
    }
    
    func testMagicCardAspectRatioIpadProLandscapeWithPadding() throws {
        
        let iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
        let padding: CGFloat = 400
        let height: CGFloat = 2048
        let paddedHeight = height - padding * 2
        let width = paddedHeight * cardAspectRatio
        let x = (2732 - width) / 2
        
        XCTAssertEqual(iPadProLandscape.largestCenteredRect(with: cardAspectRatio, padding: padding), CGRect(x: x, y: padding, width: width, height: paddedHeight))
    }
    
    
    func testSameAspectRatio() {
        let sameAspectRatio = CGRect(x: 0, y: 0, width: 2.5, height: 3.5)
        let padding: CGFloat = 1
        let width: CGFloat = 2.5
        let height: CGFloat = 3.5
        
        let returnWidth = width - padding * 2
        let returnHeight = height - padding * 2
        
        XCTAssertEqual(sameAspectRatio.largestCenteredRect(with: cardAspectRatio, padding: padding), CGRect(x: padding, y: padding, width: returnWidth, height: returnHeight))
    }
    
    
}
