//
//  NetworkController.swift
//  mtg_card_identifier
//
//  Created by Benjamin Patch on 8/1/23.
//

import Foundation

struct NetworkController {
    
    static func loadDatabaseFiles() async -> Bool {
        try! await Task.sleep(nanoseconds: 1200000000)
        return true
    }
    
    
}
