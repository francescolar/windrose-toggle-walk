# ToggleWalk script

Disclaimer: I'm not a modder, I'm just a developer and I never shared anything, I just do little things for myself like this little mod here. I wanted the feature of walking by pressing a button and not having to keep that button pressed at all times. Also, I kinda really hope this thing isn't in the game already so I didn't work for nothing!

![Example Gif](https://i.imgur.com/fGRiZfh.gif)

## Description

This mod it's just a little lua script (so you will need [UE4SS](https://www.nexusmods.com/windrose/mods/43) for it to work) that modifies the player's run speed values to match the in-game walking speed, until the hotkey is pressed again. The hotkey is configurable in the **config.txt** file, it uses the [Microsoft Virtual Key-Codes](http://). Default is "C" (67). You can unbind the caps lock in the game and change the config to 20 to replace the caps lock to the mod.

Also, I hope this is a temporary workaround until the game dev add this funcionality to the game.

## Requirements

As I said, the only hard-requirement is [UE4SS](https://www.nexusmods.com/windrose/mods/43).

## Installation

After installing UE4SS, you need to:

1. unzip **ToggleWalk.zip** to the "Mods" folder
2. ~~add "**ToggleWalk : 1**" on top of the "mods.txt" file in the Mods folder.~~ **v2.1 - added file "enabled.txt" so it's automatically active**
3. (optional) change the key in ToggleWalk/Scripts/config.txt

After that, you should be good to go.

Recap of the folder structures that you should have: 
- **\*Game root\*/R5/Binaries/Win64/Mods/ToggleWalk/Scripts/main.lua**
- **\*Game root\*/R5/Binaries/Win64/Mods/ToggleWalk/Scripts/config.txt**
- **\*Game root\*/R5/Binaries/Win64/Mods/ToggleWalk/enabled.txt**


- ~~\*Game root\*/R5/Binaries/Win64/Mods/mods.txt (with ToggleWalk : 1)~~ v2.1 - added file "enabled.txt" so it's automatically active

## Known Bug

- ~~After the toggle, when you stop and start moving again, for a second the player will play running animation even if the speed is the walk speed. This is probably because the game "thinks" the state of the player is still 2 (running), but the actual speed is lower than the minimum for that animation to play. At least, this is what I think. I don't really know how to fix that~~ __v2.1 - fixed in this version. Now works fine__
- Not really a bug, but I didn't implement or test the online compatibility of the mod. I don't know if it works online

Feel free to suggest, edit and improve the mod and I hope that it works for you