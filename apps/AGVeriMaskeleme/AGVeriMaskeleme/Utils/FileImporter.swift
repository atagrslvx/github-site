//
//  FileImporter.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

/// Dosya import yöneticisi
class FileImporter {
    
    /// Dosya seçici göster ve import et
    static func importFile(completion: @escaping (Result<ImportedDataset, Error>) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.title = "Veri Dosyası Seç"
        openPanel.message = "Maskelemek istediğiniz CSV veya JSON dosyasını seçin"
        openPanel.allowedContentTypes = [.commaSeparatedText, .json, .plainText]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            guard response == .OK, let url = openPanel.url else {
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let dataset = try parseFile(url: url)
                    DispatchQueue.main.async {
                        completion(.success(dataset))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    /// Dosyayı URL'den parse et
    static func parseFile(url: URL) throws -> ImportedDataset {
        // Detect format from extension
        let pathExtension = url.pathExtension.lowercased()
        
        switch pathExtension {
        case "csv", "txt":
            return try CSVParser.parse(from: url)
        case "json":
            return try JSONParser.parse(from: url)
        default:
            // Try to detect by content
            let content = try String(contentsOf: url, encoding: .utf8)
            if content.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("[") ||
               content.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("{") {
                let data = try Data(contentsOf: url)
                return try JSONParser.parse(data: data, fileName: url.lastPathComponent)
            } else {
                return try CSVParser.parse(from: url)
            }
        }
    }
    
    /// Dosyayı drop ile import et
    static func importFromDrop(providers: [NSItemProvider], completion: @escaping (Result<ImportedDataset, Error>) -> Void) {
        guard let provider = providers.first else {
            completion(.failure(ImportError.noFileProvided))
            return
        }
        
        // Try to load file URL
        if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let urlData = urlData as? Data,
                   let path = String(data: urlData, encoding: .utf8),
                   let url = URL(string: path) {
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            let dataset = try parseFile(url: url)
                            DispatchQueue.main.async {
                                completion(.success(dataset))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        } else {
            completion(.failure(ImportError.unsupportedFileType))
        }
    }
}

/// Import hataları
enum ImportError: LocalizedError {
    case noFileProvided
    case unsupportedFileType
    case readError
    
    var errorDescription: String? {
        switch self {
        case .noFileProvided:
            return "Dosya bulunamadı"
        case .unsupportedFileType:
            return "Desteklenmeyen dosya formatı. Lütfen CSV veya JSON dosyası seçin."
        case .readError:
            return "Dosya okunamadı"
        }
    }
}
