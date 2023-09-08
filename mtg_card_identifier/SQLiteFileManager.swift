//
//  NetworkController.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/4/23.
//

import Foundation
import SQLite
//3
//download sqlite file from server
//save file to file system
//load file from file system
//get file url so we can create a Connection

struct SQLiteFileManager {
    static func loadDatabaseFiles(progressHandler: @escaping (Double) -> Void) async -> Bool {
        let databaseURLString = "https://mtgjson.com/api/v5/AllPrintings.json"

        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }

        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")

        do {
            let (data, response) = try await URLSession.shared.data(from: databaseURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error downloading database: Invalid response")
                return false
            }
            
            try data.write(to: localURL, options: .atomic)
            print("Database downloaded and saved locally at \(localURL)")
            return true
        } catch {
            print("Error downloading or saving database file: \(error.localizedDescription)")
            return false
        }
    }
    static func checkDatabaseStatus() -> Bool {
        let databaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")
        print(databaseURL)
        return FileManager.default.fileExists(atPath: databaseURL.path)
    }
}
