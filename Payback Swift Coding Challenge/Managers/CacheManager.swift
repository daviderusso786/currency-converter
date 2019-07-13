//
//  CacheManager.swift
//  Payback Swift Coding Challenge
//
//  Created by Davide Russo on 13/07/2019.
//  Copyright © 2019 Davide Russo. All rights reserved.
//

import Foundation

class CacheManager {
    static let shared: CacheManager = CacheManager()
    
    private init() {}
    
    func save(obj: CurrencyRateResponse, withName name: String) {
        // Build file url
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let fileURL = documentsURL.appendingPathComponent("\(name).json", isDirectory: false)
        
        // Write
        if let encodedData = try? JSONEncoder().encode(obj) {
            do {
                try encodedData.write(to: fileURL)
            }
            catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func loadFile(withName name: String) -> CurrencyRateResponse? {
        // Build file url
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let fileURL = documentsURL.appendingPathComponent("\(name).json", isDirectory: false)
        
        // Read
        do {
            let data = try Data(contentsOf: fileURL)
            let jsonData = try JSONDecoder().decode(CurrencyRateResponse.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
            return nil
        }
    }
}
