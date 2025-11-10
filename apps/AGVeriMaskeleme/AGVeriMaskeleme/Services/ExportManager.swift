//
//  ExportManager.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation
import AppKit

/// Dosya export yöneticisi
class ExportManager {
    
    /// Maskelenmiş veriyi export et
    static func export(result: MaskingResult, format: FileFormat? = nil) {
        let savePanel = NSSavePanel()
        savePanel.title = "Maskelenmiş Veriyi Kaydet"
        savePanel.message = "Maskelenmiş veriyi kaydetmek için bir konum seçin"
        savePanel.nameFieldStringValue = generateFileName(from: result.dataset.fileName, format: format ?? result.dataset.format)
        
        let exportFormat = format ?? result.dataset.format
        switch exportFormat {
        case .csv:
            savePanel.allowedContentTypes = [.commaSeparatedText]
        case .json:
            savePanel.allowedContentTypes = [.json]
        }
        
        savePanel.begin { response in
            guard response == .OK, let url = savePanel.url else { return }
            
            do {
                try exportData(result.dataset, to: url, format: exportFormat)
                showSuccessAlert(url: url, result: result)
            } catch {
                showErrorAlert(error: error)
            }
        }
    }
    
    /// Veriyi dosyaya yaz
    private static func exportData(_ dataset: ImportedDataset, to url: URL, format: FileFormat) throws {
        switch format {
        case .csv:
            try CSVParser.export(dataset: dataset, to: url)
        case .json:
            try JSONParser.export(dataset: dataset, to: url, prettyPrinted: true)
        }
    }
    
    /// Dosya adı oluştur
    private static func generateFileName(from original: String, format: FileFormat) -> String {
        let baseName = (original as NSString).deletingPathExtension
        let timestamp = DateFormatter.fileNameFormatter.string(from: Date())
        
        switch format {
        case .csv:
            return "\(baseName)_masked_\(timestamp).csv"
        case .json:
            return "\(baseName)_masked_\(timestamp).json"
        }
    }
    
    /// Başarı bildirimi göster
    private static func showSuccessAlert(url: URL, result: MaskingResult) {
        let alert = NSAlert()
        alert.messageText = "Export Başarılı! ✅"
        alert.informativeText = """
        Maskelenmiş veri başarıyla kaydedildi.
        
        📊 İstatistikler:
        • Toplam satır: \(result.dataset.rowCount)
        • Maskelenen hücre: \(result.maskedCount)
        • Oran: \(String(format: "%.1f", result.percentage))%
        • Süre: \(String(format: "%.3f", result.duration))s
        
        📁 Konum: \(url.path)
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Dosyayı Aç")
        alert.addButton(withTitle: "Tamam")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            NSWorkspace.shared.open(url)
        }
    }
    
    /// Hata bildirimi göster
    private static func showErrorAlert(error: Error) {
        let alert = NSAlert()
        alert.messageText = "Export Hatası"
        alert.informativeText = "Dosya kaydedilirken bir hata oluştu:\n\n\(error.localizedDescription)"
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Tamam")
        alert.runModal()
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let fileNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter
    }()
}
