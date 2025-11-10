//
//  MaskingEngine.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation
import CryptoKit

/// Veri maskeleme motoru
class MaskingEngine {
    
    /// Veriyi maskele
    static func mask(
        dataset: ImportedDataset,
        columns: [String],
        strategy: MaskingStrategy,
        salt: String = ""
    ) -> MaskingResult {
        let startTime = Date()
        var maskedRows: [DataRow] = []
        var maskedCount = 0
        let totalCells = dataset.rows.count * columns.count
        
        for row in dataset.rows {
            var maskedValues = row.values
            
            for column in columns {
                if let value = row.values[column], !value.isEmpty {
                    maskedValues[column] = maskValue(value, strategy: strategy, salt: salt)
                    maskedCount += 1
                }
            }
            
            maskedRows.append(DataRow(values: maskedValues))
        }
        
        let duration = Date().timeIntervalSince(startTime)
        let maskedDataset = ImportedDataset(
            format: dataset.format,
            columns: dataset.columns,
            rows: maskedRows,
            fileName: dataset.fileName
        )
        
        return MaskingResult(
            dataset: maskedDataset,
            maskedCount: maskedCount,
            totalCells: totalCells,
            duration: duration
        )
    }
    
    /// Tek bir değeri maskele
    private static func maskValue(_ value: String, strategy: MaskingStrategy, salt: String) -> String {
        switch strategy {
        case .mask:
            return partialMask(value)
        case .hash:
            return hashValue(value, salt: salt)
        case .random:
            return randomize(value)
        case .redact:
            return "[GIZLI]"
        }
    }
    
    /// Kısmi maskeleme: "ahmet@example.com" -> "ah***@ex***le.com"
    private static func partialMask(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 4 else {
            return String(repeating: "*", count: trimmed.count)
        }
        
        // Email detection
        if trimmed.contains("@") {
            return maskEmail(trimmed)
        }
        
        // IBAN detection
        if trimmed.hasPrefix("TR") && trimmed.count == 26 {
            return maskIBAN(trimmed)
        }
        
        // Phone detection
        if trimmed.hasPrefix("0") && trimmed.count == 11 {
            return maskPhone(trimmed)
        }
        
        // Default masking
        let firstTwo = trimmed.prefix(2)
        let lastTwo = trimmed.suffix(2)
        let middleCount = max(1, trimmed.count - 4)
        return "\(firstTwo)\(String(repeating: "*", count: middleCount))\(lastTwo)"
    }
    
    /// Email maskeleme
    private static func maskEmail(_ email: String) -> String {
        let components = email.split(separator: "@")
        guard components.count == 2 else { return email }
        
        let username = String(components[0])
        let domain = String(components[1])
        
        let maskedUsername = username.count > 2
            ? "\(username.prefix(2))\(String(repeating: "*", count: max(1, username.count - 2)))"
            : String(repeating: "*", count: username.count)
        
        let domainParts = domain.split(separator: ".")
        guard domainParts.count >= 2 else {
            return "\(maskedUsername)@\(domain)"
        }
        
        let domainName = String(domainParts[0])
        let maskedDomain = domainName.count > 2
            ? "\(domainName.prefix(2))\(String(repeating: "*", count: max(1, domainName.count - 2)))"
            : domainName
        
        let extension_ = domainParts.dropFirst().joined(separator: ".")
        return "\(maskedUsername)@\(maskedDomain).\(extension_)"
    }
    
    /// IBAN maskeleme: "TR180006200119000006672315" -> "TR18***************2315"
    private static func maskIBAN(_ iban: String) -> String {
        let first4 = iban.prefix(4)
        let last4 = iban.suffix(4)
        let middleCount = iban.count - 8
        return "\(first4)\(String(repeating: "*", count: middleCount))\(last4)"
    }
    
    /// Telefon maskeleme: "05321234567" -> "0532***4567"
    private static func maskPhone(_ phone: String) -> String {
        let first4 = phone.prefix(4)
        let last4 = phone.suffix(4)
        return "\(first4)\(String(repeating: "*", count: 3))\(last4)"
    }
    
    /// SHA-256 hash
    private static func hashValue(_ value: String, salt: String) -> String {
        let input = value + salt
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    /// Rastgele değer üretimi (karakter tipini koruyarak)
    private static func randomize(_ value: String) -> String {
        let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
        let digits = "0123456789"
        
        return String(value.map { char in
            if uppercaseLetters.contains(char) {
                return uppercaseLetters.randomElement() ?? char
            } else if lowercaseLetters.contains(char) {
                return lowercaseLetters.randomElement() ?? char
            } else if digits.contains(char) {
                return digits.randomElement() ?? char
            } else {
                return char
            }
        })
    }
    
    /// Maskeleme önizlemesi (ilk 3 satır)
    static func previewMasking(
        dataset: ImportedDataset,
        columns: [String],
        strategy: MaskingStrategy,
        salt: String = ""
    ) -> [DataRow] {
        let previewRows = Array(dataset.rows.prefix(3))
        var maskedRows: [DataRow] = []
        
        for row in previewRows {
            var maskedValues = row.values
            
            for column in columns {
                if let value = row.values[column], !value.isEmpty {
                    maskedValues[column] = maskValue(value, strategy: strategy, salt: salt)
                }
            }
            
            maskedRows.append(DataRow(values: maskedValues))
        }
        
        return maskedRows
    }
}
