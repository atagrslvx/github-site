//
//  ColumnSelectorView.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import SwiftUI

struct ColumnSelectorView: View {
    @ObservedObject var viewModel: MaskingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kolon Seçimi")
                            .font(.system(size: 20, weight: .bold))
                        
                        if let dataset = viewModel.dataset {
                            Text("\(dataset.columnCount) kolon • \(viewModel.selectedColumns.count) seçili")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                // Quick Actions
                HStack(spacing: 12) {
                    Button(action: { viewModel.selectAllColumns() }) {
                        Label("Tümünü Seç", systemImage: "checkmark.circle")
                            .font(.system(size: 12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { viewModel.deselectAllColumns() }) {
                        Label("Seçimi Kaldır", systemImage: "xmark.circle")
                            .font(.system(size: 12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("💡 Hassas kolonlar otomatik seçildi")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Column List
            ScrollView {
                LazyVStack(spacing: 8) {
                    if let columns = viewModel.dataset?.columns {
                        ForEach(columns, id: \.self) { column in
                            ColumnRow(
                                column: column,
                                isSelected: viewModel.selectedColumns.contains(column),
                                sampleValue: getSampleValue(for: column)
                            ) {
                                viewModel.toggleColumn(column)
                            }
                        }
                    }
                }
                .padding(20)
            }
            
            Divider()
            
            // Footer
            HStack {
                Text("\(viewModel.selectedColumns.count) kolon maskelenecek")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Tamam") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.selectedColumns.isEmpty)
            }
            .padding(20)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 600, height: 500)
    }
    
    private func getSampleValue(for column: String) -> String {
        guard let dataset = viewModel.dataset,
              let firstRow = dataset.rows.first,
              let value = firstRow.values[column] else {
            return ""
        }
        return value
    }
}

struct ColumnRow: View {
    let column: String
    let isSelected: Bool
    let sampleValue: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                
                // Column Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(column)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        
                        if isSensitiveColumn(column) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                                .help("Hassas veri olabilir")
                        }
                    }
                    
                    if !sampleValue.isEmpty {
                        Text("Örnek: \(sampleValue)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Column Type Icon
                Image(systemName: getColumnIcon(column))
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(isSelected ? Color.blue.opacity(0.05) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func isSensitiveColumn(_ column: String) -> Bool {
        let sensitive = [
            "tc", "kimlik", "tckn",
            "email", "eposta", "mail",
            "telefon", "phone", "tel",
            "iban", "hesap",
            "password", "şifre",
            "kredi", "kart"
        ]
        let lowercased = column.lowercased()
        return sensitive.contains(where: { lowercased.contains($0) })
    }
    
    private func getColumnIcon(_ column: String) -> String {
        let lowercased = column.lowercased()
        
        if lowercased.contains("email") || lowercased.contains("eposta") {
            return "envelope.fill"
        } else if lowercased.contains("telefon") || lowercased.contains("phone") {
            return "phone.fill"
        } else if lowercased.contains("tc") || lowercased.contains("kimlik") {
            return "person.text.rectangle.fill"
        } else if lowercased.contains("iban") || lowercased.contains("hesap") {
            return "creditcard.fill"
        } else if lowercased.contains("adres") || lowercased.contains("address") {
            return "mappin.circle.fill"
        } else if lowercased.contains("id") {
            return "number.circle.fill"
        } else {
            return "text.alignleft"
        }
    }
}

#Preview {
    ColumnSelectorView(viewModel: MaskingViewModel())
}
