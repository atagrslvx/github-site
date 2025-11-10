//
//  CSVParser.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation

/// CSV dosya parser'ı
class CSVParser {
    
    /// CSV dosyasını parse et
    static func parse(from url: URL) throws -> ImportedDataset {
        let content = try String(contentsOf: url, encoding: .utf8)
        return try parse(content: content, fileName: url.lastPathComponent)
    }
    
    /// CSV içeriğini parse et
    static func parse(content: String, fileName: String = "data.csv") throws -> ImportedDataset {
        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else {
            throw ParsingError.emptyFile
        }
        
        // Parse header
        let columns = parseCSVLine(lines[0])
        guard !columns.isEmpty else {
            throw ParsingError.invalidHeader
        }
        
        // Parse rows
        var rows: [DataRow] = []
        for (index, line) in lines.dropFirst().enumerated() {
            let values = parseCSVLine(line)
            
            guard values.count == columns.count else {
                print("⚠️  Satır \(index + 2) kolon sayısı eşleşmiyor. Beklenen: \(columns.count), Bulunan: \(values.count)")
                continue
            }
            
            var rowDict: [String: String] = [:]
            for (columnIndex, column) in columns.enumerated() {
                rowDict[column] = values[columnIndex]
            }
            
            rows.append(DataRow(values: rowDict))
        }
        
        guard !rows.isEmpty else {
            throw ParsingError.noDataRows
        }
        
        return ImportedDataset(
            format: .csv,
            columns: columns,
            rows: rows,
            fileName: fileName
        )
    }
    
    /// CSV satırını parse et (virgül ve tırnak işaretlerini doğru handle eder)
    private static func parseCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var inQuotes = false
        
        var i = line.startIndex
        while i < line.endIndex {
            let char = line[i]
            
            if char == "\"" {
                // Check if it's an escaped quote
                let nextIndex = line.index(after: i)
                if inQuotes && nextIndex < line.endIndex && line[nextIndex] == "\"" {
                    currentField.append("\"")
                    i = nextIndex
                } else {
                    inQuotes.toggle()
                }
            } else if char == "," && !inQuotes {
                result.append(currentField.trimmingCharacters(in: .whitespaces))
                currentField = ""
            } else {
                currentField.append(char)
            }
            
            i = line.index(after: i)
        }
        
        result.append(currentField.trimmingCharacters(in: .whitespaces))
        return result
    }
    
    /// Dataset'i CSV formatında export et
    static func export(dataset: ImportedDataset, to url: URL) throws {
        var csvContent = ""
        
        // Header
        csvContent += dataset.columns.map { escapeCSVField($0) }.joined(separator: ",")
        csvContent += "\n"
        
        // Rows
        for row in dataset.rows {
            let rowValues = dataset.columns.map { column -> String in
                let value = row.values[column] ?? ""
                return escapeCSVField(value)
            }
            csvContent += rowValues.joined(separator: ",")
            csvContent += "\n"
        }
        
        try csvContent.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// CSV field'ı escape et (virgül ve tırnak işaretleri için)
    private static func escapeCSVField(_ field: String) -> String {
        let needsQuotes = field.contains(",") || field.contains("\"") || field.contains("\n")
        
        if needsQuotes {
            let escapedField = field.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escapedField)\""
        }
        
        return field
    }
}

/// CSV parsing hataları
enum ParsingError: LocalizedError {
    case emptyFile
    case invalidHeader
    case noDataRows
    case invalidJSON
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "Dosya boş veya okunamadı"
        case .invalidHeader:
            return "Geçersiz başlık satırı"
        case .noDataRows:
            return "Dosyada veri satırı bulunamadı"
        case .invalidJSON:
            return "Geçersiz JSON formatı"
        case .invalidFormat:
            return "Desteklenmeyen dosya formatı"
        }
    }
}
