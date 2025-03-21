# ReddiKit

ReddiKit is a macOS SwiftUI application tthat lets users easily search for and download drum kits from Reddit community r/Drumkits. It allows users to search for specific drum kits and download them directly from Google Drive.

## Release

[Download the latest version 1.0.0](https://zero45.pro/reddikit/ReddiKit_1.0.0.dmg)

## Features
- Fetches the latest drum kits from r/Drumkits.
- Allows users to search for specific drum kits.
- Provides direct download links for drum kits hosted on Google Drive.
- Supports user preferences such as setting a save folder and enabling/disabling automatic unzipping.
- Simple and modern SwiftUI interface.

## Installation
1. Clone this repository:
   ```sh
   git clone https://github.com/dlxarl/ReddiKit.git
   ```
2. Open the project in Xcode:
   ```sh
   cd ReddiKit
   open ReddiKit.xcodeproj
   ```
3. Build and run the project on macOS.

## Usage
1. Launch ReddiKit.
2. Browse the latest drum kits or use the search bar to find a specific kit.
3. Click on a drum kit to initiate the download from Google Drive.
4. Configure settings such as the save folder and auto-unzipping in the preferences window.

## Requirements
- macOS 12.0+
- Xcode 14+
- Swift 5+

## Configuration
User preferences are stored in a `preferences.json` file in the user's home directory. Settings include:
- `savesFolder`: The folder where downloaded drum kits are stored.
- `unzip`: A boolean flag to enable or disable automatic extraction of downloaded kits.

## Contributing
1. Fork the repository.
2. Create a new branch (`feature-branch`).
3. Commit your changes.
4. Push to your branch and create a Pull Request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Links
- [ReddiKit on GitHub](https://github.com/dlxarl/ReddiKit)
- [Author on Reddit](https://www.reddit.com/u/mandab0bra)

## Contact
For support or questions, reach out via GitHub Issues or [Reddit](https://www.reddit.com/user/mandab0bra/).

