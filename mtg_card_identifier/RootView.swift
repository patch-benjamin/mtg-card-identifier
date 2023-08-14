//
//  RootView.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/11/23.
//

import SwiftUI
import Combine

//class AppSettings: ObservableObject {
//    private let isDatabaseDownloadedKey = "isDatabaseDownloaded"
//
//    @Published var isDatabaseDownloaded: Bool {
//        didSet {
//            UserDefaults.standard.set(isDatabaseDownloaded, forKey: isDatabaseDownloadedKey)
//        }
//    }
//
//    init() {
//        self.isDatabaseDownloaded = UserDefaults.standard.bool(forKey: isDatabaseDownloadedKey)
//    }
//}

struct RootView: View {
    @State private var isDatabaseDownloaded = false
    
    var body: some View {
        if isDatabaseDownloaded {
            ContentView()
        } else {
            DownloadDatabaseFilesView(store: DownloadDatabaseFilesView_Previews.store)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
