//
//  ContentView.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MaskingViewModel()
    @State private var showAbout = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.02, green: 0.02, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Title Bar
                customTitleBar
                
                // Main Content
                mainContent
                    .padding()
            }
        }
        .sheet(isPresented: $viewModel.showColumnSelector) {
            ColumnSelectorView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
    
    // MARK: - Custom Title Bar
    private var customTitleBar: some View {
        HStack {
            // Logo & Title
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AG Veri Maskeleme")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("v1.0.0")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button(action: { showAbout = true }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
                .help("Hakkında")
                
                if viewModel.appState.hasData {
                    Button(action: { viewModel.startOver() }) {
                        Label("Yeni", systemImage: "arrow.clockwise")
                            .font(.system(size: 12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.3))
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.appState {
        case .idle:
            idleView
        case .fileSelected, .columnsSelected:
            columnSelectionView
        case .masked(let result):
            resultView(result)
        case .error(let message):
            errorView(message)
        case .exporting:
            exportingView
        }
    }
    
    // MARK: - Idle View
    private var idleView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "doc.text.fill.badge.ellipsis")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Title & Description
            VStack(spacing: 12) {
                Text("Veri Dosyanızı Yükleyin")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("CSV veya JSON formatındaki dosyanızı seçin ve hassas verileri maskeleyin")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 400)
            }
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: { viewModel.importFile() }) {
                    HStack(spacing: 12) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 18))
                        Text("Dosya Seç")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .frame(maxWidth: 300)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                
                HStack(spacing: 12) {
                    Button(action: { viewModel.loadDemoData(format: .csv) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text")
                            Text("Demo CSV")
                        }
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { viewModel.loadDemoData(format: .json) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "curlybraces")
                            Text("Demo JSON")
                        }
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: 300)
            }
            
            Spacer()
            
            // Info Cards
            HStack(spacing: 16) {
                InfoCard(icon: "lock.shield", title: "KVKK Uyumlu", color: .blue)
                InfoCard(icon: "bolt.fill", title: "Hızlı İşlem", color: .purple)
                InfoCard(icon: "checkmark.seal.fill", title: "Güvenli", color: .green)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    // MARK: - Column Selection View
    private var columnSelectionView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Kolon Seçimi ve Önizleme")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                if let dataset = viewModel.dataset {
                    Text("\(dataset.rowCount) satır • \(dataset.columnCount) kolon")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.top, 20)
            
            Button(action: { viewModel.showColumnSelector = true }) {
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Kolonları Seç (\(viewModel.selectedColumns.count) seçili)")
                        .font(.system(size: 14, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            
            // Preview
            if !viewModel.previewRows.isEmpty {
                PreviewView(
                    columns: viewModel.dataset?.columns ?? [],
                    rows: viewModel.previewRows,
                    selectedColumns: viewModel.selectedColumns
                )
            }
            
            Spacer()
            
            // Strategy Selection
            strategySelector
            
            // Action Button
            Button(action: { viewModel.performMasking() }) {
                HStack(spacing: 12) {
                    if viewModel.isProcessing {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 18))
                    }
                    Text(viewModel.isProcessing ? "Maskeleniyor..." : "Maskele")
                        .font(.system(size: 15, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.canMask ? Color.green : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canMask)
        }
        .padding()
    }
    
    // MARK: - Strategy Selector
    private var strategySelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Maskeleme Stratejisi")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(MaskingStrategy.allCases) { strategy in
                    StrategyCard(
                        strategy: strategy,
                        isSelected: viewModel.selectedStrategy == strategy
                    ) {
                        viewModel.selectedStrategy = strategy
                        viewModel.updatePreview()
                    }
                }
            }
            
            if viewModel.selectedStrategy == .hash {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Salt (Opsiyonel)")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Ek güvenlik için salt değeri", text: $viewModel.salt)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.salt, perform: { _ in
                            viewModel.updatePreview()
                        })
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    // MARK: - Result View
    private func resultView(_ result: MaskingResult) -> some View {
        VStack(spacing: 24) {
            // Success Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
            }
            .padding(.top, 40)
            
            // Stats
            VStack(spacing: 8) {
                Text("Maskeleme Tamamlandı!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Verileriniz başarıyla maskelendi")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Statistics Cards
            HStack(spacing: 16) {
                StatCard(
                    value: "\(result.dataset.rowCount)",
                    label: "Satır",
                    icon: "list.bullet",
                    color: .blue
                )
                StatCard(
                    value: "\(result.maskedCount)",
                    label: "Maskelenen",
                    icon: "eye.slash.fill",
                    color: .purple
                )
                StatCard(
                    value: String(format: "%.1f%%", result.percentage),
                    label: "Oran",
                    icon: "chart.pie.fill",
                    color: .green
                )
                StatCard(
                    value: String(format: "%.2fs", result.duration),
                    label: "Süre",
                    icon: "clock.fill",
                    color: .orange
                )
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            // Export Buttons
            VStack(spacing: 12) {
                Text("Maskelenmiş veriyi kaydedin")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 12) {
                    Button(action: { viewModel.exportData(format: .csv) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text")
                            Text("CSV olarak kaydet")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { viewModel.exportData(format: .json) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "curlybraces")
                            Text("JSON olarak kaydet")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: 500)
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            VStack(spacing: 8) {
                Text("Hata")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { viewModel.reset() }) {
                Text("Tekrar Dene")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Exporting View
    private var exportingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Dosya kaydediliyor...")
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Supporting Views
struct InfoCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct StrategyCard: View {
    let strategy: MaskingStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: strategy.icon)
                        .font(.system(size: 18))
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(strategy.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                
                Text(strategy.description)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .foregroundColor(.white)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("AG Veri Maskeleme")
                    .font(.system(size: 24, weight: .bold))
                
                Text("v1.0.0")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Text("KVKK/GDPR uyumlu veri maskeleme aracı")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Label("CSV ve JSON formatı desteği", systemImage: "doc.text")
                Label("4 farklı maskeleme stratejisi", systemImage: "shield.checkered")
                Label("Offline çalışır, veri güvenliği", systemImage: "lock.shield")
                Label("macOS 13.0+ Apple Silicon", systemImage: "cpu")
            }
            .font(.system(size: 12))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("© 2025 Ata Gürsel")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("Tüm hakları saklıdır.")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 20)
            
            Button("Kapat") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .padding(.bottom, 20)
        }
        .frame(width: 400, height: 500)
    }
}

#Preview {
    ContentView()
}
