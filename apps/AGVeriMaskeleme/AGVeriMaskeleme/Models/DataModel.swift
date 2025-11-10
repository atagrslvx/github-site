//
//  DataModel.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation

/// Maskeleme stratejisi
enum MaskingStrategy: String, CaseIterable, Identifiable {
    case mask = "Kısmi Maskeleme"
    case hash = "SHA-256 Hash"
    case random = "Rastgele"
    case redact = "Tamamen Gizle"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .mask:
            return "İlk ve son karakterleri gösterir, ortası yıldızlanır"
        case .hash:
            return "SHA-256 hash ile deterministik şifreleme"
        case .random:
            return "Karakter tipini koruyarak rastgele değer üretir"
        case .redact:
            return "Tüm değeri [GIZLI] ile değiştirir"
        }
    }
    
    var icon: String {
        switch self {
        case .mask:
            return "eye.slash.fill"
        case .hash:
            return "number.circle.fill"
        case .random:
            return "shuffle.circle.fill"
        case .redact:
            return "xmark.circle.fill"
        }
    }
}

/// Dosya formatı
enum FileFormat: String, CaseIterable {
    case csv = "CSV"
    case json = "JSON"
}

/// Veri satırı modeli
struct DataRow: Identifiable, Equatable {
    let id: UUID
    var values: [String: String]
    
    init(values: [String: String]) {
        self.id = UUID()
        self.values = values
    }
    
    static func == (lhs: DataRow, rhs: DataRow) -> Bool {
        lhs.id == rhs.id
    }
}

/// İçe aktarılan veri seti
struct ImportedDataset: Identifiable, Equatable {
    let id = UUID()
    let format: FileFormat
    let columns: [String]
    var rows: [DataRow]
    let fileName: String
    
    var isEmpty: Bool {
        rows.isEmpty || columns.isEmpty
    }
    
    var rowCount: Int {
        rows.count
    }
    
    var columnCount: Int {
        columns.count
    }
    
    static func == (lhs: ImportedDataset, rhs: ImportedDataset) -> Bool {
        lhs.id == rhs.id
    }
}

/// Maskeleme profili
struct MaskingProfile: Codable {
    var selectedColumns: [String]
    var strategy: String
    var salt: String
    var format: String
    
    init(selectedColumns: [String] = [], strategy: MaskingStrategy = .mask, salt: String = "", format: FileFormat = .csv) {
        self.selectedColumns = selectedColumns
        self.strategy = strategy.rawValue
        self.salt = salt
        self.format = format.rawValue
    }
}

/// Maskeleme sonucu
struct MaskingResult: Equatable {
    let dataset: ImportedDataset
    let maskedCount: Int
    let totalCells: Int
    let duration: TimeInterval
    
    var percentage: Double {
        guard totalCells > 0 else { return 0 }
        return Double(maskedCount) / Double(totalCells) * 100
    }
    
    static func == (lhs: MaskingResult, rhs: MaskingResult) -> Bool {
        lhs.dataset == rhs.dataset && lhs.maskedCount == rhs.maskedCount
    }
}

/// Uygulama durumu
enum AppState: Equatable {
    case idle
    case fileSelected(ImportedDataset)
    case columnsSelected(ImportedDataset, [String])
    case masked(MaskingResult)
    case exporting
    case error(String)
    
    var canExport: Bool {
        if case .masked = self {
            return true
        }
        return false
    }
    
    var hasData: Bool {
        switch self {
        case .idle, .error:
            return false
        default:
            return true
        }
    }
}
