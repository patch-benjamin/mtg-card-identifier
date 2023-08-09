//
//  mtg_card_identifierApp.swift
//  mtg_card_identifier
//
//  Created by Benjamin Patch on 6/2/23.
//

import SwiftUI

@main
struct mtg_card_identifierApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadDatabaseFilesView(store: DownloadDatabaseFilesView_Previews.store)
        }
    }
}
