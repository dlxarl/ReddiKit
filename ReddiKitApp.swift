//
//  ReddiKitApp.swift
//  ReddiKit
//
//  Created by Ілля on 06/03/2025.
//

import SwiftUI

@main
struct ReddiKitApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.white)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        .commands {
            CommandGroup(replacing: .windowSize) {
                EmptyView()
            }
        }
    }
}
