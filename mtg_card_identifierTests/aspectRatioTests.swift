//
//  mtg_card_identifierTests.swift
//  mtg_card_identifierTests
//
//  Created by Benjamin Patch on 6/2/23.
//

import XCTest
@testable import mtg_card_identifier

final class aspectRatioTests: XCTestCase {
    func testWideRectangleAndTallAspectRatioWithZeroPadding() throws {
        var cgRect = CGRect(x: 0, y: 0, width: 500, height: 300)
        
        XCTAssertEqual(cgRect.largestCenteredRect(with: 0.5, padding: 0), CGRect(x: 175, y: 0, width: 150, height: 300))
    }
    
// MARK: Smallest iPhone tests.
    func testMagicCardAspectRatioIphone8WithZeroPadding() throws {
        var iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        XCTAssertEqual(iPhone8.largestCenteredRect(with: 0.714, padding: 0), CGRect(x: 175, y: 0, width: 150, height: 300))
    }
    
    func testMagicCardAspectRatioInIphone8WithPadding() throws {
        var iPhone8 = CGRect(x: 0, y: 0, width: 750, height: 1334)
        
    }
    
    // MARK: Biggest iPhone tests.
    func testMagicCardAspectRatioIphone15ProWithZeroPadding() throws {
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
      
    }
    func testMagicCardAspectRatioIphone15ProWithPadding() throws {
        var iphone15Plus = CGRect(x: 0, y: 0, width: 1290, height: 2796)
    }
    
    // MARK: Smallest iPads tests.
    func testMagicCardAspectRatioIpadMiniLandscapeWithZeroPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
    }
    
    func testMagicCardAspectRatioIpadMiniLandscapeWithPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
    }
    
    func testMagicCardAspectRatioIpadMiniPortraitWithPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
    }
    
    func testMagicCardAspectRatioIpadMiniPortraitWithZeroPadding() throws {
        var iPadMiniProtrait = CGRect(x: 0, y: 0, width: 1488, height: 2266)
        var iPadMiniLandscape = CGRect(x: 0, y: 0, width: 2266, height: 1488)
    }
    
    // MARK: Biggest iPads tests.
    func testMagicCardAspectRatioInIpadProLandscapeWithZeroPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
    }
    
    func testMagicCardAspectRatioIpadProLandscapeWithPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
    }
    
    func testMagicCardAspectRatioIpadProPortraitWithPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
    }
    
    func testMagicCardAspectRatioIpadProPortraitWithZeroPadding() throws {
        var iPadProPortrait = CGRect(x: 0, y: 0, width: 2048, height: 2732)
        var iPadProLandscape = CGRect(x: 0, y: 0, width: 2732, height: 2048)
    }
    
    
    
    
}
