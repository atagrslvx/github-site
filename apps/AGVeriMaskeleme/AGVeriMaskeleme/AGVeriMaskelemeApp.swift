//
//  AGVeriMaskelemeApp.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//  Copyright © 2025 Ata Gürsel. Tüm hakları saklıdır.
//

import SwiftUI

@main
struct AGVeriMaskelemeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 650)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
