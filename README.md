# 🏷️ lcky-status

**lcky-status** is a lightweight, high-performance, and modern player status system designed for FiveM servers. It features an advanced **Bridge** system that ensures full compatibility with multiple frameworks and targeting systems.

[![Version](https://img.shields.io/badge/version-0.3.0-green.svg)](https://github.com/lcky-scripts/lcky-status)
[![Framework](https://img.shields.io/badge/framework-Qbox%20%7C%20QBCore%20%7C%20ESX-blue.svg)](https://github.com/lcky-scripts/lcky-status)
[![Target](https://img.shields.io/badge/target-ox__target%20%7C%20qb--target-orange.svg)](https://github.com/lcky-scripts/lcky-status)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

---

## ✨ Features

- 🌉 **Advanced Bridge System**: Automatically detects and adapts to your server's framework and target system.
- 💾 **Metadata Based Storage**: Utilizes native metadata systems (Qbox, QBCore, ESX Meta). No extra SQL tables required.
- 🎨 **Modern UI**: Clean and responsive context menus and input dialogs powered by `ox_lib`.
- 👁️ **Multi-Targeting Support**: Works out-of-the-box with `ox_target` and `qb-target`.
- 🔊 **Proximity Notifications**: Automatically notifies nearby players (within 10m) when someone updates their status.
- ⚡ **Optimized**: High performance with minimal client/server overhead (0.00ms idle).
- 🛠️ **Developer Friendly**: Comprehensive exports for easy integration.

---

## 📦 Compatibility & Dependencies

### Required
- [ox_lib](https://github.com/overextended/ox_lib)

### Supported Frameworks (Auto-detected)
- **Qbox** (`qbx_core`)
- **QBCore** (`qb-core`)
- **ESX** (`es_extended`)

### Supported Target Systems (Auto-detected)
- **ox_target**
- **qb-target**

---

## 🚀 Installation

1. **Clone or Download** this repository into your server's `resources` directory.
2. Ensure the folder is named `lcky-status`.
3. Add the following to your `server.cfg`:
   ```cfg
   ensure lcky-status
   ```
4. Restart your server.

---

## 🎮 Usage

### For Players
- **Command**: `/status` - Opens the status management menu.
  - **Set Status**: Enter a custom message (e.g., "Working at the Forge", "AFK - Brb").
  - **Clear Status**: Removes your current status.
- **Interaction**: Use your interaction key (Alt / G) while looking at another player to see their status.

### Proximity Alerts
When you update your status, players within a **10-meter radius** will receive a notification informing them of the change.

---

## 💻 Developer API

### Server-side
```lua
-- Get a player's status
local status = exports['lcky-status']:GetPlayerStatus(source)

-- Set a player's status
exports['lcky-status']:SetPlayerStatus(source, "Working")
```

### Client-side
```lua
-- Get your current status from the server
local status = exports['lcky-status']:GetPlayerStatusFromServer()
```


---

## 👨‍💻 Credits

Developed by **Lucky Scripts**.
Special thanks to the **Qbox Project**, **Overextended** teams.
