//
//  JSONParser.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation

/// JSON dosya parser'ı
class JSONParser {
    
    /// JSON dosyasını parse et
    static func parse(from url: URL) throws -> ImportedDataset {
        let data = try Data(contentsOf: url)
        return try parse(data: data, fileName: url.lastPathComponent)
    }
    
    /// JSON verisini parse et
    static func parse(data: Data, fileName: String = "data.json") throws -> ImportedDataset {
        guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw ParsingError.invalidJSON
        }
        
        guard !jsonArray.isEmpty else {
            throw ParsingError.noDataRows
        }
        
        // Extract all unique columns from all objects
        var allColumns = Set<String>()
        for obj in jsonArray {
            allColumns.formUnion(obj.keys)
        }
        
        let columns = Array(allColumns).sorted()
        
        // Convert to DataRows
        let rows = jsonArray.map { obj -> DataRow in
            var values: [String: String] = [:]
            for column in columns {
                if let value = obj[column] {
                    values[column] = convertToString(value)
                } else {
                    values[column] = ""
                }
            }
            return DataRow(values: values)
        }
        
        return ImportedDataset(
            format: .json,
            columns: columns,
            rows: rows,
            fileName: fileName
        )
    }
    
    /// Değeri string'e çevir
    private static func convertToString(_ value: Any) -> String {
        if let string = value as? String {
            return string
        } else if let number = value as? NSNumber {
            return number.stringValue
        } else if let bool = value as? Bool {
            return bool ? "true" : "false"
        } else if value is NSNull {
            return ""
        } else {
            return "\(value)"
        }
    }
    
    /// Dataset'i JSON formatında export et
    static func export(dataset: ImportedDataset, to url: URL, prettyPrinted: Bool = true) throws {
        var jsonArray: [[String: Any]] = []
        
        for row in dataset.rows {
            var jsonObject: [String: Any] = [:]
            for column in dataset.columns {
                if let value = row.values[column], !value.isEmpty {
                    jsonObject[column] = value
                } else {
                    jsonObject[column] = NSNull()
                }
            }
            jsonArray.append(jsonObject)
        }
        
        let options: JSONSerialization.WritingOptions = prettyPrinted ? [.prettyPrinted, .sortedKeys] : []
        let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: options)
        try jsonData.write(to: url)
    }
}
