//
//  NetworkController.swift
//  mtg_card_identifier
//
//  Created by Dylan Martin on 8/4/23.
//

import Foundation
import SQLite

struct SQLiteFileManager {
    private static let databaseURLString = "https://mtgjson.com/api/v5/AllPrintings.json"
    private static let localDatabaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")
    
    static func loadDatabaseFiles(progressHandler: @escaping (Double) -> Void) async -> Bool {
        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: databaseURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error downloading database: Invalid response")
                return false
            }
            try data.write(to: localDatabaseURL, options: .atomic)
            print("Database downloaded and saved locally at \(localDatabaseURL)")
            return true
        } catch {
            print("Error downloading or saving database file: \(error.localizedDescription)")
            return false
        }
    }
    
    static func checkDatabaseStatus() -> Bool {
        return FileManager.default.fileExists(atPath: localDatabaseURL.path)
    }
}
