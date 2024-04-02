//
//  CardScannerView.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
struct CardScannerView: View {
    static let magicCardAspectRatio = 0.714
    @State var scannedText: [String] = []
    var body: some View {

        NavigationView {
            GeometryReader { geometry in
                
                let screenSize = geometry.frame(in: .global)
                let cardRect = screenSize.largestCenteredRect(with: Self.magicCardAspectRatio, padding: 10)
                let regionOfInterest = cardRect
    //            let originX = (screenSize.width - cardRect.width) / 2
    //            let originY = (screenSize.height - cardRect.height) / 2m
               

                let background =  Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: screenSize.width, height: screenSize.height)
                let cardCutout = RoundedRectangle(cornerRadius: regionOfInterest.size.height / 10)
                    .fill(.black)
                    .frame(width: regionOfInterest.width, height: regionOfInterest.height)
                let overlay = ZStack {
                    background
                    cardCutout
                        .blendMode(.destinationOut)
                }
                    .compositingGroup()
                 
                ZStack {
                    LiveTextScannerView(scannedText: $scannedText, overlay: overlay, regionOfInterest: regionOfInterest)
                        .navigationTitle("Scan card")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
struct CardScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerView()
    }
}






