//
//  LiveTextScannerViewHelpers.swift
//  mtg_card_identifier
//
//  Created by mac on 9/15/23.
//

import UIKit
import SwiftUI

struct NoCameraAccessView: View {
    var body: some View {
        VStack {
            Spacer()
            
            
            
            Text("No permissions enabled.                                                  You must enable camera access in order to scan cards")
                .multilineTextAlignment(.center)
            
            Button(action: UIApplication.shared.openAppSettings) {
                Text("Open Settings")
                
                
            }
            
            Spacer()
            Spacer()
        }
    }
 }

extension UIApplication {
    func openAppSettings() {
         if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
             
             UIApplication.shared.open(settingsURL)
         } else {
             print("Unable to open app settings")
         }
     }
}
