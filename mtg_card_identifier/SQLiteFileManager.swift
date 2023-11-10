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
    
    static func loadDatabaseFiles(progressHandler: @escaping (Double) -> Void, completion: @escaping (Bool) -> Void) -> Bool {
        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }
        return URLSessionDownloader.start(sessionIdentifier: "SQLiteFileManager", url: databaseURL, progressRecieved: { progress in
            progressHandler(progress)
        }) { temporaryURL in
            do {
                try FileManager.default.moveItem(at: temporaryURL!, to: localDatabaseURL)
                print("Database downloaded and saved locally at \(localDatabaseURL)")
                completion(true)
            } catch {
                print("Error moving downloaded file: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    static func checkDatabaseStatus() -> Bool {
        return FileManager.default.fileExists(atPath: localDatabaseURL.path)
    }
}
