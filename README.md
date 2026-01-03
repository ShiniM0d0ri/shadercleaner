# Universal Shader Cache Cleaner

A lightweight, automated Windows batch script to clear GPU shader caches (NVIDIA, AMD, Intel) and the Steam shader cache to fix stuttering, graphical glitches, and free up disk space.

## Features
- **Auto-Detects Steam:** Automatically finds your Steam library location (no manual editing required).
- **Universal Support:** Clears caches for NVIDIA, AMD, and Intel GPUs.
- **DirectX Cleaning:** Clears the Windows DirectX shader cache (D3DSCache).
- **Safe:** Checks if Steam is running and closes it gracefully before cleaning.

## How to Use
1. Download the `ShaderCleaner.bat` file from the [Releases](link-to-releases) page.
2. Right-click the file and select **Run as Administrator** (Required to access system folders).
3. Choose an option from the menu:
   - `[1] Clear ALL` (Recommended for troubleshooting)
   - `[2] Clear GPU Only`
   - `[3] Clear Steam Only`

## Why use this?
When graphics drivers update or game files change, old shader caches can become corrupt or outdated. This often leads to:
- Micro-stutters in games.
- Slow loading times.
- Graphical artifacts.

*Note: After running this, games will take slightly longer to load the first time as they rebuild a fresh cache.*
