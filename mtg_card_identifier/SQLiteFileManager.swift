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
    static var current: URLSessionDownloader?
    
    static func loadDatabaseFiles(progressHandler: @escaping (Double) -> Void, completion: @escaping (Bool) -> Void) -> Bool {
        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }
        self.current?.defaultExpectedFileSize = 380000000 // MTGJson doesn't provide the `Content-Length` header that allows us to get back the `totalBytesExpectedToWrite` value here (it will always be -1), so we're estimating the expeted download size of these files based on historical experience.

        return (URLSessionDownloader.start(sessionIdentifier: "SQLiteFileManager", url: databaseURL, progressReceived: { progress in
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
        } != nil)
    }
    
    static func checkDatabaseStatus() -> Bool {
        return FileManager.default.fileExists(atPath: localDatabaseURL.path)
    }
}
