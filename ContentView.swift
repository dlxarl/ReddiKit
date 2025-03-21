    import SwiftUI
    import Foundation
    import AppKit

    // Struct to map Reddit post data
    struct DrumKitPost: Decodable {
        let title: String
        let author: String
        let url: String
    }

    struct RedditData: Decodable {
        let data: RedditDataContent
    }

    struct RedditDataContent: Decodable {
        let children: [RedditPost]
    }

    struct RedditPost: Decodable {
        let data: DrumKitPost
    }

    struct Preferences: Codable {
        var savesFolder: String
        var unzip: Bool
    }

    struct ContentView: View {
        @State private var text: String = ""
        @State private var drumKits: [String] = []
        @State private var authors: [String] = []
        @State private var urls: [String] = []
        @State private var isHovering = false
        @State private var drumKitsTitle = "Latest drum kits"
        @State private var drumKitsIcon = "clock.arrow.circlepath"
        @State private var currentVersion = "1.0.0-beta"
        
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    // Logo and Settings
                    HStack(spacing: 0) {
                        Text("Reddi")
                            .foregroundColor(Color(red: 1.0, green: 0.27, blue: 0.0))
                            .padding(.leading, 40)
                        Text("Kit")
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            doSettingsWindow()
                        }) {
                            Image(systemName: "gear")
                                .padding(.trailing, 40)
                                .foregroundColor(isHovering ? Color(red: 0.41, green: 0.41, blue: 0.41) : .gray)
                                .font(.system(size: 20, weight: .medium))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { isHovering in
                            self.isHovering = isHovering
                            if isHovering {
                                NSCursor.pointingHand.set()
                            } else {
                                NSCursor.arrow.set()
                            }
                        }
                    }
                    .font(.custom("SF Pro Expanded Black", size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 45)

                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)

                        ZStack(alignment: .leading) {
                            if text.isEmpty {
                                Text("Metro Boomin Drum Kit")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 0)
                            }

                            TextField("", text: $text)
                                .foregroundColor(.black)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                        performSearch()
                                    }
                        }
                        
                    }
                    .padding(10)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
                    .padding(.top, 40)
                    
                    Spacer()

                    // Latest Drum Kits Section
                    HStack(spacing: 0) {
                        Text(drumKitsTitle)
                            .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                        Image(systemName: drumKitsIcon)
                            .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                            .padding(.leading, 5)
                    }
                    .font(.custom("SF Pro Medium", size: 12))
                    .padding(.leading, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 40)
                    .padding(.bottom, 20)
                    .background(Color.white)
                    .zIndex(99)

                    // Drum Kits List
                    let drumKitData = Array(zip(drumKits, zip(authors, urls)))

                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(drumKitData, id: \.0) { drumKit, authorUrl in
                                let author = authorUrl.0
                                let url = authorUrl.1
                                
                                Button(action: {
//                                    print("URL: \(url)")
                                    if let id = extractFileID(from: url) {
                                        //print("ID: \(id)")
                                        runGDriveScript(withID: id)
                                    } else {
                                        print("Failed to extract file ID")
                                    }
                                }) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Text(drumKit)
                                                .foregroundColor(.black)
                                                .padding(.leading, 10)

                                            Spacer()

                                            Text("r/drumkits")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }

                                        Text("by \(author)")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                            .padding(.leading, 10)
                                    }
                                    .padding()
                                    .frame(height: 70)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 40)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onHover { isHovering in
                                    if isHovering {
                                        NSCursor.pointingHand.set()
                                    } else {
                                        NSCursor.arrow.set()
                                    }
                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                    .onAppear { fetchPosts() }
                    
                    Spacer()
                    
                    // Links
                    HStack{
                        Link("donate", destination: URL(string: "https://www.paypal.com/paypalme/hxntaitape")!)
                            .foregroundColor(.black)
                            .font(.custom("SF Pro", size: 12))
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.set()
                            } else {
                                NSCursor.arrow.set()
                            }
                        }
                        
                        Text("|")
                            .foregroundColor(.black)
                            .font(.custom("SF Pro", size: 12))
                        
                        Link("github", destination: URL(string: "https://github.com/dlxarl/ReddiKit")!)
                            .foregroundColor(.black)
                            .font(.custom("SF Pro", size: 12))
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.set()
                            } else {
                                NSCursor.arrow.set()
                            }
                        }
                        
                        Text("|")
                            .foregroundColor(.black)
                            .font(.custom("SF Pro", size: 12))
                        
                        Link("reddit", destination: URL(string: "https://www.reddit.com/user/mandab0bra/")!)
                            .foregroundColor(.black)
                            .font(.custom("SF Pro", size: 12))
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.set()
                            } else {
                                NSCursor.arrow.set()
                            }
                        }
                    }

                    Spacer()
                    
                    // Version
                    Text("version: \(currentVersion)")
                        .foregroundColor(.gray)
                        .font(.custom("SF Pro", size: 12))
                        .padding(.top, 10)
                        .padding(.bottom, 10)

                    Spacer()
                }
            }
            .frame(width: 720, height: 575)
            .background(Color.white)
        }
        
        
        // Get last 4 posts from r/Drumkits
        func fetchPosts() {
            let url = URL(string: "https://www.reddit.com/r/drumkits/new.json?limit=4")!

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let redditData = try decoder.decode(RedditData.self, from: data)

                    let filteredPosts = redditData.data.children.filter { post in
                        post.data.url.contains("drive.google.com")
                    }

                    let newDrumKits = filteredPosts.map { $0.data.title }
                    let newAuthors = filteredPosts.map { $0.data.author }
                    let newUrls = filteredPosts.map { $0.data.url }

                    DispatchQueue.main.async {
                        self.drumKits = newDrumKits
                        self.authors = newAuthors
                        self.urls = newUrls
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }

            task.resume()
        }
        
        // Search
        func performSearch() {
            let url = URL(string: "https://www.reddit.com/r/Drumkits/search.json?q=\(text)&restrict_sr=true")!
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let redditData = try decoder.decode(RedditData.self, from: data)
                    
                    let filteredPosts = redditData.data.children.filter { post in
                        post.data.url.contains("drive.google.com")
                    }
                    
                    let newDrumKits = filteredPosts.map { $0.data.title }
                    let newAuthors = filteredPosts.map { $0.data.author }
                    let newUrls = filteredPosts.map { $0.data.url }
                    
                    DispatchQueue.main.async {
                        self.drumKits = newDrumKits
                        self.authors = newAuthors
                        self.urls = newUrls
                        
                        if newDrumKits.isEmpty {
                            self.drumKitsTitle = "No drum kits found"
                            self.drumKitsIcon = "xmark"
                        } else {
                            self.drumKitsTitle = "Search results for '\(text)'"
                            self.drumKitsIcon = "magnifyingglass"
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            
            task.resume()
        }
            
        // Extract Google Drive file id from URL
        func extractFileID(from url: String) -> String? {
            let pattern = #"(?:\/d\/|id=)([a-zA-Z0-9_-]+)|folders\/([a-zA-Z0-9_-]+)"#
                    
            guard let regex = try? NSRegularExpression(pattern: pattern) else {
                print("Invalid regular expression")
                return nil
            }
                    
            let range = NSRange(location: 0, length: url.utf16.count)
            guard let match = regex.firstMatch(in: url, options: [], range: range) else {
                print("No match found")
                return nil
            }
                    
            if let fileIDRange = Range(match.range(at: 1), in: url), !fileIDRange.isEmpty {
                return String(url[fileIDRange])
            }
            
            if let folderIDRange = Range(match.range(at: 2), in: url), !folderIDRange.isEmpty {
                return String(url[folderIDRange])
            }
            
            return nil
        }
        
        // Call error alert
        func showErrorDialog(message: String) {
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = message
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")

                if let window = NSApplication.shared.windows.first {
                    alert.beginSheetModal(for: window) { _ in }
                } else {
                    alert.runModal()
                }
            }
        }
        
        // Download from Google Drive
        func runGDriveScript(withID id: String) {
            let scriptName = "gdrive.py"
            let scriptPath = (#file as NSString).deletingLastPathComponent + "/Modules/" + scriptName
            
            if !FileManager.default.fileExists(atPath: scriptPath) {
                showErrorDialog(message: "Error: Script not found at \(scriptPath)")
                return
            }
            
            let pythonPath = "/opt/homebrew/bin/python3"
            if !FileManager.default.fileExists(atPath: pythonPath) {
                showErrorDialog(message: "Error: Python not found at \(pythonPath)")
                return
            }
            
            let process = Process()
            let pipe = Pipe()
            process.launchPath = pythonPath
            process.arguments = [scriptPath, id]
            process.standardError = pipe

            let fileHandle = pipe.fileHandleForReading
            process.launch()
            process.waitUntilExit()
            
            let errorData = fileHandle.readDataToEndOfFile()
                if let errorMessage = String(data: errorData, encoding: .utf8), !errorMessage.isEmpty {
                    showErrorDialog(message: errorMessage)
                }
        }

        }

        // Open settings window
        func doSettingsWindow() {
            let newWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: [.titled, .closable, .fullSizeContentView],
                backing: .buffered, defer: false
            )
            
            newWindow.center()
            newWindow.setFrameAutosaveName("Settings")
            
            newWindow.titleVisibility = .hidden
            newWindow.titlebarAppearsTransparent = true
            newWindow.standardWindowButton(.zoomButton)?.isHidden = true
            newWindow.standardWindowButton(.closeButton)?.isHidden = false
            newWindow.standardWindowButton(.miniaturizeButton)?.isHidden = false
            
            newWindow.backgroundColor = .white
            
            let hostingView = NSHostingView(rootView: SettingsView())
            hostingView.wantsLayer = true
            hostingView.layer?.backgroundColor = NSColor.white.cgColor
            
            newWindow.contentView = hostingView
            newWindow.isReleasedWhenClosed = false
            newWindow.makeKeyAndOrderFront(nil)
        }


    // Settings window
    struct SettingsView: View {
        @State private var preferences: Preferences
            @State private var savesFolder: String
            @State private var unzip: Bool
            @State private var isHovering = false
            @Environment(\.dismiss) var dismiss

            init() {
                let preferences = SettingsView.loadPreferences()
                _preferences = State(initialValue: preferences)
                _savesFolder = State(initialValue: preferences.savesFolder)
                _unzip = State(initialValue: preferences.unzip)
            }

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                        Text("Settings")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                            .padding(.leading, 20)

                        HStack {
                            Text("Saves folder")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                chooseFolder()
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(999)
                                .onHover { isHovering in
                                    if isHovering {
                                        NSCursor.pointingHand.set()
                                    } else {
                                        NSCursor.arrow.set()
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 5)
                        .padding(.leading, 20)
                        
                        Text(savesFolder)
                            .foregroundColor(.gray)
                        .padding(.leading, 20)
                        
                        HStack {
                            Text("Unzip")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                                    
                            Toggle(isOn: $unzip) {
                                Text("")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .toggleStyle(SwitchToggleStyle())
                            .padding(0)
                            .frame(width: 40)
                            .onHover { isHovering in
                                if isHovering {
                                    NSCursor.pointingHand.set()
                                } else {
                                    NSCursor.arrow.set()
                                }
                            }
                        }
                        .padding(.leading, 20)
                        
                        HStack {
                            Button(action: {
                                savePreferences()
                                dismiss()
                            }) {
                                Text("Save")
                                    .foregroundColor(.white)
                            }
                            .keyboardShortcut(.defaultAction)
                            .onHover { isHovering in
                                if isHovering {
                                    NSCursor.pointingHand.set()
                                } else {
                                    NSCursor.arrow.set()
                                }
                            }
                            
                            Button(action: {
                                discardChanges()
                                dismiss()
                            }) {
                                Text("Discard")
                                    .foregroundColor(.black)
                            }
                            .buttonStyle(.bordered)
                            .tint(.gray)
                            .onHover { isHovering in
                                if isHovering {
                                    NSCursor.pointingHand.set()
                                } else {
                                    NSCursor.arrow.set()
                                }
                            }
                        }
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, alignment: .center)

                        Spacer()
                    }
                    .frame(width: 320, height: 200, alignment: .topLeading)
                    .background(Color.white)
                }
        
        // Open folder selection window
        func chooseFolder() {
                let dialog = NSOpenPanel()
                dialog.title = "Choose a folder"
                dialog.showsResizeIndicator = true
                dialog.showsHiddenFiles = false
                dialog.canChooseFiles = false
                dialog.canChooseDirectories = true
                dialog.allowsMultipleSelection = false

                if dialog.runModal() == .OK {
                    if let result = dialog.url {
                        savesFolder = result.path
                    }
                }
            }

        // Load preferences from the file
        static func loadPreferences() -> Preferences {
            let fileManager = FileManager.default
            let userHomeDirectory = fileManager.homeDirectoryForCurrentUser
            let preferencesFileURL = userHomeDirectory.appendingPathComponent("preferences.json")

            if fileManager.fileExists(atPath: preferencesFileURL.path) {
                do {
                    let data = try Data(contentsOf: preferencesFileURL)
                    let decoder = JSONDecoder()
                    let preferences = try decoder.decode(Preferences.self, from: data)
                    return preferences
                } catch {
                    print("Error loading preferences: \(error)")
                }
            }
            
            return Preferences(savesFolder: userHomeDirectory.appendingPathComponent("Downloads").path, unzip: true)
        }

        // Save current preferences to the file
        func savePreferences() {
            preferences.savesFolder = savesFolder
            preferences.unzip = unzip

            let fileManager = FileManager.default
            let userHomeDirectory = fileManager.homeDirectoryForCurrentUser
            let preferencesFileURL = userHomeDirectory.appendingPathComponent("preferences.json")

            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(preferences)
                try data.write(to: preferencesFileURL)
                print("Preferences saved successfully.")
            } catch {
                print("Error saving preferences: \(error)")
            }
        }

        // Discard changes
        func discardChanges() {
            let savedPreferences = SettingsView.loadPreferences()
            savesFolder = savedPreferences.savesFolder
            unzip = savedPreferences.unzip
        }
    }


    #Preview {
        ContentView()
    }
