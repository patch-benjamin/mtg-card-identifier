//
//  NetworkController.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/4/23.
//

import Foundation

struct NetworkController {
    static func loadDatabaseFiles() async -> Bool {
        let databaseURLString = "https://mtgjson.com/downloads/all-files/AllPrintings.sqlite"
        
        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }
        
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")
        
        if FileManager.default.fileExists(atPath: localURL.path) {
            print("Database file already exists locally.")
            return true
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: databaseURL)
            try data.write(to: localURL)
            print("Database downloaded and saved locally at \(localURL)")
            return true
        } catch {
            print("Error downloading or saving database file: \(error.localizedDescription)")
            return false
        }
    }
}
