//
//  CardScannerView.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
//VisionKit only in live text scanner.
struct CardScannerView: View {
//    @State var scannedText: [String] = []
    var body: some View {

        NavigationView {
            LiveTextScanningViewWrapper()
        }
    }
}
struct CardScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerView()
    }
}






