//
//  Extension+String.swift
//  odola-app
//
//  Created by Александр on 16.09.2024.
//

import Foundation
import CryptoKit

extension String {
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random = SystemRandomNumberGenerator()
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int(random.next(upperBound: len))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
    
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func isWeakPasscode() -> Bool {
        guard self.count == 6, let firstDigit = self.first?.wholeNumberValue else {
            return false
        }
        
        let digits = self.compactMap { $0.wholeNumberValue }
        
        var isAscending = true
        var isDescending = true
        
        for i in 1..<digits.count {
            if digits[i] != digits[i - 1] + 1 {
                isAscending = false
            }
            if digits[i] != digits[i - 1] - 1 {
                isDescending = false
            }
        }
        
        return isAscending || isDescending
    }
    
    func toQueryDictionary() -> [String: Any]? {
        
        let queries = self.components(separatedBy: "&")
        var dictionary = [String: Any]()
        queries.forEach { query in
            let param = query.components(separatedBy: "=")
            if param.count > 1, let key = param.first, let value = param.last {
                dictionary[key] = value
            }
        }
        
        if dictionary.isEmpty == false {
            return dictionary
        }
        
        return nil
    }
    
    func remove(symbols: String) -> String {
        var string = self
        symbols.forEach { symbol in
            string = string.replacingOccurrences(of: String(symbol), with: "")
        }
        return string
    }
    
}
