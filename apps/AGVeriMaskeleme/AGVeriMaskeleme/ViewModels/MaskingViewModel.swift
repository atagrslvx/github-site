//
//  MaskingViewModel.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation
import SwiftUI

/// Ana ViewModel
@MainActor
class MaskingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var appState: AppState = .idle
    @Published var selectedStrategy: MaskingStrategy = .mask
    @Published var selectedColumns: Set<String> = []
    @Published var salt: String = ""
    @Published var isProcessing: Bool = false
    @Published var showColumnSelector: Bool = false
    @Published var previewRows: [DataRow] = []
    
    // MARK: - Computed Properties
    var dataset: ImportedDataset? {
        switch appState {
        case .fileSelected(let dataset), .columnsSelected(let dataset, _):
            return dataset
        case .masked(let result):
            return result.dataset
        default:
            return nil
        }
    }
    
    var canMask: Bool {
        dataset != nil && !selectedColumns.isEmpty && !isProcessing
    }
    
    var canExport: Bool {
        appState.canExport && !isProcessing
    }
    
    // MARK: - File Import
    func importFile() {
        FileImporter.importFile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataset):
                self.handleFileImport(dataset)
            case .failure(let error):
                self.appState = .error(error.localizedDescription)
            }
        }
    }
    
    func loadDemoData(format: FileFormat = .csv) {
        let dataset: ImportedDataset?
        
        switch format {
        case .csv:
            dataset = DemoData.loadDemoCSV()
        case .json:
            dataset = DemoData.loadDemoJSON()
        }
        
        guard let dataset = dataset else {
            appState = .error("Demo veri yüklenemedi")
            return
        }
        
        handleFileImport(dataset)
    }
    
    private func handleFileImport(_ dataset: ImportedDataset) {
        self.appState = .fileSelected(dataset)
        self.selectedColumns.removeAll()
        self.showColumnSelector = true
        
        // Auto-select sensitive columns
        autoSelectSensitiveColumns(dataset.columns)
    }
    
    // MARK: - Column Selection
    func toggleColumn(_ column: String) {
        if selectedColumns.contains(column) {
            selectedColumns.remove(column)
        } else {
            selectedColumns.insert(column)
        }
        updatePreview()
    }
    
    func selectAllColumns() {
        guard let dataset = dataset else { return }
        selectedColumns = Set(dataset.columns)
        updatePreview()
    }
    
    func deselectAllColumns() {
        selectedColumns.removeAll()
        previewRows.removeAll()
    }
    
    private func autoSelectSensitiveColumns(_ columns: [String]) {
        let sensitiveKeywords = [
            "tc", "kimlik", "tckn",
            "email", "eposta", "mail",
            "telefon", "phone", "tel", "gsm",
            "iban", "hesap",
            "password", "şifre", "parola",
            "kredi", "kart", "card",
            "adres", "address"
        ]
        
        for column in columns {
            let lowercased = column.lowercased()
            if sensitiveKeywords.contains(where: { lowercased.contains($0) }) {
                selectedColumns.insert(column)
            }
        }
        
        updatePreview()
    }
    
    // MARK: - Masking
    func performMasking() {
        guard let dataset = dataset, !selectedColumns.isEmpty else {
            return
        }
        
        isProcessing = true
        
        Task {
            // Simulate async work
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            
            let result = MaskingEngine.mask(
                dataset: dataset,
                columns: Array(selectedColumns),
                strategy: selectedStrategy,
                salt: salt
            )
            
            self.appState = .masked(result)
            self.isProcessing = false
            self.showColumnSelector = false
        }
    }
    
    func updatePreview() {
        guard let dataset = dataset, !selectedColumns.isEmpty else {
            previewRows.removeAll()
            return
        }
        
        previewRows = MaskingEngine.previewMasking(
            dataset: dataset,
            columns: Array(selectedColumns),
            strategy: selectedStrategy,
            salt: salt
        )
    }
    
    // MARK: - Export
    func exportData(format: FileFormat? = nil) {
        guard case .masked(let result) = appState else {
            return
        }
        
        ExportManager.export(result: result, format: format)
    }
    
    // MARK: - Reset
    func reset() {
        appState = .idle
        selectedColumns.removeAll()
        salt = ""
        previewRows.removeAll()
        showColumnSelector = false
    }
    
    func startOver() {
        reset()
    }
}
