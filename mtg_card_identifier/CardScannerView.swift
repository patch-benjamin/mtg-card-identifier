//
//  CardScannerView.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
import VisionKit

struct CardScannerView: View {
//    @State private var startScanning = false
    @State private var scanedCard = [""]
    //    Do the alert on this but make it so all I need to do is call the single func for the camera to scan the code.
    var body: some View {
//        Some navigation view so it'll pull it up once you do the api call. At least that's what I assume
        NavigationStack {
            VStack {
                LiveTextScanner(scanedText: $scanedCard)
                
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
//        I dont' think this is needed
//        .task {
//            if DataScannerViewController.isAvailable && DataScannerViewController.isSupported {
//
//            }
//        }
        
    }
}
struct CardScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerView()
    }
}
