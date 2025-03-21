//
//  AppDelegate.swift
//  ReddiKit
//
//  Created by Ілля on 06/03/2025.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.styleMask.remove(.resizable)
            
            window.collectionBehavior = [.fullScreenNone]
            
            if let closeButton = window.standardWindowButton(.closeButton) {
                closeButton.isHidden = false
            }
            if let minimizeButton = window.standardWindowButton(.miniaturizeButton) {
                minimizeButton.isHidden = false
            }
            if let zoomButton = window.standardWindowButton(.zoomButton) {
                zoomButton.isHidden = true
            }
        }
    }
}
