//
//  mtg_card_identifierTests.swift
//  mtg_card_identifierTests
//
//  Created by Benjamin Patch on 6/2/23.
//

import XCTest
@testable import mtg_card_identifier

final class aspectRatioTests: XCTestCase {
    //    func testWideRectangleAndTallAspectRatioWithZeroPadding() throws {
    //        var cgRect = CGRect(x: 0, y: 0, width: 500, height: 300)
    //
    //        XCTAssertEqual(cgRect.largestCenteredRect(with: 0.5, padding: 0), CGRect(x: 175, y: 0, width: 150, height: 300))
    //    }
    
    // MARK: Smallest iPhone tests.
    func testMagicCardAspectRatioIphone8WithZeroPadding() throws {
        var iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        //        might be mulitplying width by card asepct ratio
        // X isthe horizental and Y is veritcal
        XCTAssertEqual(iPhone8.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 107, y: 0, width: 535, height: 952))
    }
    
    func testMagicCardAspectRatioInIphone8WithPadding() throws {
        var iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        XCTAssertEqual(iPhone8.largestCenteredRect(with: 0.714, padding: 20), CGRect(x: 107, y: 0, width: 535, height: 952))
    }
    
    // MARK: Biggest iPhone tests.
    func testMagicCardAspectRatioIphone15ProWithZeroPadding() throws {
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
        XCTAssertEqual(iphone15Plus.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 184, y: 0, width: 921, height: 1996))
    }
    
    func testMagicCardAspectRatioIphone15ProWithPadding() throws {
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
        
        XCTAssertEqual(iphone15Plus.largestCenteredRect(with: 0.714, padding: 50), CGRect(x: 184, y: 0, width: 921, height: 1996))
    }
    
    // MARK: Smallest iPads tests.
    func testMagicCardAspectRatioIpadMiniLandscapeWithZeroPadding() throws {
        
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
        XCTAssertEqual(iPadMiniLandscape.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 324, y: 0, width: 1617, height: 1062))
    }
    
    func testMagicCardAspectRatioIpadMiniLandscapeWithPadding() throws {
        
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
        
        XCTAssertEqual(iPadMiniLandscape.largestCenteredRect(with: 0.714, padding: 60), CGRect(x: 324, y: 0, width: 1617, height: 1062))
    }
    
    func testMagicCardAspectRatioIpadMiniPortraitWithPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        XCTAssertEqual(iPadMiniProtrait.largestCenteredRect(with: 0.714, padding: 100), CGRect(x: 213, y: 0, width: 1062, height: 1617))
    }
    
    func testMagicCardAspectRatioIpadMiniPortraitWithZeroPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        
        XCTAssertEqual(iPadMiniProtrait.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 213, y: 0, width: 1062, height: 1617))
    }
    
    // MARK: Biggest iPads tests.
    func testMagicCardAspectRatioInIpadProLandscapeWithZeroPadding() throws {
        
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
        XCTAssertEqual(iPadProLandscape.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 391, y: 0, width: 1950, height: 1462))
    }
    
    func testMagicCardAspectRatioIpadProLandscapeWithPadding() throws {
        
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
        XCTAssertEqual(iPadProLandscape.largestCenteredRect(with: 0.714, padding: 400), CGRect(x: 391, y: 0, width: 1950, height: 1462))
    }
    
    func testMagicCardAspectRatioIpadProPortraitWithPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        XCTAssertEqual(iPadProPortrait.largestCenteredRect(with: 0.714, padding: 500), CGRect(x: 293, y: 0, width: 1462, height: 1950))
        
    }
    
    func testMagicCardAspectRatioIpadProPortraitWithZeroPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        XCTAssertEqual(iPadProPortrait.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 293, y: 0, width: 1462, height: 1950))
        
    }
    
    
    
    
}
