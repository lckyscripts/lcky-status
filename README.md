# 🏷️ lcky-status

**lcky-status** is a lightweight, high-performance, and modern player status system designed for FiveM servers using the **Qbox/QBCore** framework. It allows players to set custom text statuses that others can view through physical interaction or proximity notifications.

[![Version](https://img.shields.io/badge/version-0.2.0-green.svg)](https://github.com/lcky-scripts/lcky-status)
[![Framework](https://img.shields.io/badge/framework-Qbox-blue.svg)](https://github.com/Qbox-Project/qbx_core)

---

## ✨ Features

- 💾 **Metadata Based Storage**: Utilizes `qbx_core` metadata system. No extra SQL tables or database bloat.
- 👁️ **Targeting System**: Integrated with `ox_target` to allow players to inspect others' statuses by looking at them.
- 🔊 **Proximity Notifications**: Automatically notifies nearby players (within 10m) when someone updates their status.
- ⚡ **Optimized**: High performance with minimal client/server overhead.
- 🛠️ **Developer Friendly**: Easy-to-use exports for integration with other scripts.

---

## 📦 Dependencies

To ensure this script works correctly, you must have the following resources installed:

- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)

---

## 🚀 Installation

1. **Clone or Download** this repository into your server's `resources` directory.
2. Ensure the folder is named `lcky-status`.
3. Add the following to your `server.cfg`:
   ```cfg
   ensure lcky-status
   ```
4. Restart your server or `ensure` the resource.

---

## 🎮 Usage

### For Players
- **Command**: `/status` - Opens the status management menu.
  - **Set Status**: Enter a custom message (e.g., "Working at the Forge", "AFK - Brb").
  - **Clear Status**: Removes your current status.
- **Interaction**: Press your interaction key (default `Alt`) while looking at another player to see their status.

### Proximity Alerts
When you update your status, players within a **10-meter radius** will receive a notification informing them of the change.

---

## 💻 Developer API

You can use the following exports in your other scripts:

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

## 📄 To do

Make the system compatible with other frameworks.

---

## 👨‍💻 Credits

Developed by **Lucky Scripts**.
Special thanks to the **Qbox Project** and **Overextended** team for their amazing libraries.
