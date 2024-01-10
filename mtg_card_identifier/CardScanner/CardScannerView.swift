//
//  CardScannerView.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
struct CardScannerView: View {
    @State var scannedText: [String] = []
    var body: some View {

        NavigationView {
            LiveTextScannerView(scannedText: $scannedText, overlay: , regionOfInterest: <#T##CGRect?#>)
        }
    }
}
struct CardScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerView()
    }
}






