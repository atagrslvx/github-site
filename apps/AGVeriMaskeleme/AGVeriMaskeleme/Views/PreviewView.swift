//
//  PreviewView.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import SwiftUI

struct PreviewView: View {
    let columns: [String]
    let rows: [DataRow]
    let selectedColumns: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "eye.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                
                Text("Önizleme (İlk 3 Satır)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(rows.count) satır gösteriliyor")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Table
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 0) {
                    // Header Row
                    HStack(spacing: 1) {
                        ForEach(columns, id: \.self) { column in
                            HeaderCell(
                                column: column,
                                isMasked: selectedColumns.contains(column)
                            )
                        }
                    }
                    
                    // Data Rows
                    ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                        HStack(spacing: 1) {
                            ForEach(columns, id: \.self) { column in
                                DataCell(
                                    value: row.values[column] ?? "",
                                    isMasked: selectedColumns.contains(column),
                                    isEven: index % 2 == 0
                                )
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct HeaderCell: View {
    let column: String
    let isMasked: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Text(column)
                .font(.system(size: 11, weight: .semibold))
                .lineLimit(1)
            
            if isMasked {
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.orange)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(minWidth: 120, maxWidth: 200, alignment: .leading)
        .background(Color.blue.opacity(0.3))
    }
}

struct DataCell: View {
    let value: String
    let isMasked: Bool
    let isEven: Bool
    
    var body: some View {
        Text(value.isEmpty ? "-" : value)
            .font(.system(size: 10, design: .monospaced))
            .lineLimit(1)
            .foregroundColor(isMasked ? .orange : .white.opacity(0.9))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(minWidth: 120, maxWidth: 200, alignment: .leading)
            .background(
                isMasked
                    ? Color.orange.opacity(0.1)
                    : (isEven ? Color.white.opacity(0.02) : Color.white.opacity(0.05))
            )
    }
}

#Preview {
    PreviewView(
        columns: ["id", "ad", "email", "telefon"],
        rows: [
            DataRow(values: ["id": "1", "ad": "Ahmet", "email": "ah***@ex***.com", "telefon": "0532***4567"]),
            DataRow(values: ["id": "2", "ad": "Ayşe", "email": "ay***@ex***.com", "telefon": "0542***7890"])
        ],
        selectedColumns: ["email", "telefon"]
    )
    .frame(width: 700)
    .background(Color.black)
}
