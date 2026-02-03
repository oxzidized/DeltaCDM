# DeltaCDM

**DeltaCDM** is a lightweight World of Warcraft addon designed to give you control over the visibility of the **Cooldown Manager** (introduced in The War Within).

Tired of seeing your cooldown bars while you're just flying around or hanging out in Valdrakken? This addon lets you automatically hide them based on your current state.

## Features
* **Auto-Hide on Mount:** Keep your UI clean while mounted.
* **Auto-Hide out of Combat:** If you prefer a minimal UI outside combat.
* **Persistent Settings:** Remembers your toggles across characters and sessions.

## Installation
1.  Download the latest `DeltaCDM.zip` from the [Releases](https://github.com/oxzidized/DeltaCDM/releases) page.
2.  Extract the folder into your World of Warcraft directory:
    `_retail_/Interface/AddOns/`
3.  Restart or Reload WoW.

## Commands
Use the following slash commands to configure the addon in-game:

* `/dcdm` — Displays the current status and help menu.
* `/dcdm mounted` — Toggles whether the UI is hidden while you are mounted.
* `/dcdm combat` — Toggles whether the UI is hidden while you are out of combat.

## Current Supported Frames
This addon manages the following Blizzard UI elements:
* EssentialCooldownViewer
* UtilityCooldownViewer
* BuffIconCooldownViewer
* BuffBarCooldownViewer

## Roadmap
* Add settings UI for toggling options

## License
GPLv3
