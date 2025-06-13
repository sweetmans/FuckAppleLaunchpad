# FuckAppleLaunchpad
A tool to bypass and customize Apple's Launchpad functionality on macOS. Tired of Apple's restrictive Launchpad? This project gives you control back.

## Features
- Removes Launchpad restrictions for custom app organization
- Supports macOS versions 10.15 Catalina and above
- Lightweight and easy to install

## Latest Release
- **Version**: v1.0.0
- **Release Date**: June 13, 2025
- **Download**: [https://github.com/sweetmans/FuckAppleLaunchpad/releases/download/v1.0.0/FuckAppleLaunchpad.zip](https://github.com/sweetmans/FuckAppleLaunchpad/releases/download/v1.0.0/FuckAppleLaunchpad.zip)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/sweetmans/FuckAppleLaunchpad.git
   ```
2. Navigate to the project directory:
   ```bash
   cd FuckAppleLaunchpad
   ```
3. Run the installation script:
   ```bash
   ./install.sh
   ```
4. Build and run the tool:
   ```bash
   swift build
   swift run
   ```

For a visual guide, watch the installation video below.

## Usage
Run the tool with:
```bash
./fuckapplelaunchpad --customize
```

Additional options:
- `--reset`: Restores default Launchpad settings
- `--help`: Displays available commands

## Requirements
- macOS 10.15 Catalina or later
- Swift 5.7 or later
- SwiftUI 4.0 or later

### Version Compatibility
| App Release Version | Required OS Version | Swift Version  |
|--------------------|--------------------|---------------|
| v1.0.0(latest)     | macOS 26.0 Beta Tahoe  | 6.2.0.9.909|

## App Snapshot
![App Snapshot](https://github.com/sweetmans/FuckAppleLaunchpad/raw/develop/screenshot.png)
*Caption*: FuckAppleLaunchpad in action, showing customized app organization.

## Installation Video
Watch the installation process in action:
<video controls>
  <source src="https://github.com/sweetmans/FuckAppleLaunchpad/raw/develop/install-video.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

## Contributing
We welcome contributions! Please follow these rules:
- Fork the repository.
- Create a new branch (`git checkout -b feature/your-feature`).
- Commit your changes with clear messages (`git commit -m 'Add your feature'`).
- Ensure code follows Swift style guidelines.
- Test your changes thoroughly.
- Push to the branch (`git push origin feature/your-feature`).
- Open a Pull Request with a detailed description of your changes.

## License
MIT License - See LICENSE for details.

## Disclaimer
This tool modifies system behavior and may void warranties or violate Apple's terms of service. Use at your own risk.

## Contact
For issues or questions, open an issue on GitHub or contact sweetmans@example.com.
