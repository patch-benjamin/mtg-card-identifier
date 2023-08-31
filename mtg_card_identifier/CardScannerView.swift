//
//  CardScannerView.swift
//  mtg_card_identifier
//
//  Created by mac on 8/16/23.
//

import SwiftUI
import VisionKit
import AVFoundation

struct CardScannerView: View {
    @State private var cameraAccessAuthorized = false // Assume authorized initially

    var body: some View {
        NavigationView {
            if cameraAccessAuthorized {
                CardScanner()
            } else {
                NoCameraAccessView()
            }
        }
        .onAppear {
            requestCameraAccess()
            checkCameraAuthorizationStatus()
        }
    }

    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Camera access granted")
                cameraAccessAuthorized = true
            } else {
                print("Camera access denied")
                cameraAccessAuthorized = false
            }
        }
    }
    
    func checkCameraAuthorizationStatus() {
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch authorizationStatus {
            case .authorized:
                cameraAccessAuthorized = true
            case .notDetermined, .denied, .restricted:
                cameraAccessAuthorized = false
            @unknown default:
                cameraAccessAuthorized = false
            }
        }
    }

struct CardScannerView_Previews: PreviewProvider {
    static var previews: some View {
        CardScannerView()
    }
}


struct CardScanner: View {
    @State private var scanedCard = [""]
    
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
    }
}

struct NoCameraAccessView: View {
    var body: some View {
        VStack {
            Text("No permissions enabled.                                                  You must enable camera access in order to scan cards")
                .multilineTextAlignment(.center)
            
            Button(action: openAppSettings) {
                Text("Open Settings")
            }
        }
    }
    
    func openAppSettings() {
         if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
             
             UIApplication.shared.open(settingsURL)
         } else {
             print("Unable to open app settings")
         }
     }
 }

