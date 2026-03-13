
<img width="1890" height="1417" alt="BuckoMapping" src="https://github.com/user-attachments/assets/6a343c5c-339f-4733-be76-a41c925a6b83" />

join the discord today for mapping help  https://discord.gg/N2YWYM4u82

====================================================

Advanced Standalone Spawn Menu
A lightweight, beautifully designed, completely standalone spawn menu for FiveM roleplay servers. Designed to integrate perfectly into a modern, "fully stacked" UI/HUD environment without relying on heavy frameworks like ESX or QBCore.

✨ Features
Completely Standalone: No framework dependencies. Runs purely on FiveM natives and NUI.

Modern Sidebar UI: A sleek, dark glassmorphism design that leaves the screen open for cinematic views.

Cinematic Sky Camera: Players are greeted with a slowly rotating, top-down view of the city while they make their selection.

Dynamic JSON Database: No more restarting the script or manually editing Lua tables. New spawn points sync to all players in real-time.

In-Game Developer Tools: Walk to a spot and type /addspawn [Name] to instantly save and sync a new location.

In-Game Deletion: UI includes a delete button (×) to easily remove unwanted spawn points.

Failsafe System: Lock specific locations (like Legion Square) in the JSON file so they can never be accidentally deleted.

Persistent Last Location: Uses FiveM's native Client-Side Key-Value Pairs (KVP) to remember where a player logged off, without requiring an SQL database.

Invisible Ped Fix: Automatically assigns a base multiplayer ped (mp_m_freemode_01) and default components so players don't spawn invisible.

📥 Installation
Download or clone this repository.

Ensure the folder is named spawnmenu (or adjust the fxmanifest and NUI fetch requests accordingly).

Drag the spawnmenu folder into your FiveM resources directory.

Add ensure spawnmenu to your server.cfg.

Start your server.

💻 Commands
/testspawn - Opens the menu manually for testing purposes.

/addspawn [Location Name] - Grabs your current X, Y, Z, and Heading, saves it to locations.json, and instantly updates the menu for all players. (Example: /addspawn Paleto Police Station)
