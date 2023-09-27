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

class DatabaseDownloadDelegate: NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    var totalBytesExpectedToDownload: Int64 = 0
    var totalBytesDownloaded: Int64 = 0
    var progressHandler: ((Double) -> Void)?

    private func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) {
            totalBytesExpectedToDownload = response.expectedContentLength
        } else {
            progressHandler?(0.0)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        totalBytesDownloaded += Int64(data.count)
        let progress = Double(totalBytesDownloaded) / Double(totalBytesExpectedToDownload)
        progressHandler?(progress)
    }
}

struct SQLiteFileManager {
    static func loadDatabaseFiles(progressHandler: @escaping (Double) -> Void) async -> Bool {
        let databaseURLString = "https://mtgjson.com/api/v5/AllPrintings.json"

        guard let databaseURL = URL(string: databaseURLString) else {
            print("Invalid database URL")
            return false
        }

        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")

        do {
            let delegate = DatabaseDownloadDelegate()
            delegate.progressHandler = progressHandler

            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)

            let (data, _) = try await session.data(from: databaseURL)
            
            try data.write(to: localURL)
            print("Database downloaded and saved locally at \(localURL)")
            return true
        } catch {
            print("Error downloading or saving database file: \(error.localizedDescription)")
            return false
        }
    }
    static func deleteDatabaseFile() -> Bool {
        let databaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")
        
        do {
            try FileManager.default.removeItem(at: databaseURL)
            print("Database file deleted successfully")
            return true
        } catch {
            print("Error deleting database file: \(error.localizedDescription)")
            return false
        }
    }
    static func checkDatabaseStatus() -> Bool {
        let databaseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AllPrintings.sqlite")
        print(databaseURL)
        return FileManager.default.fileExists(atPath: databaseURL.path)
    }
}
