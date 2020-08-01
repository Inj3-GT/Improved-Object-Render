# Improved-Object-Render
![alt tag](http://centralcityrp.mtxserv.fr/CentralOptimisationClient0.1a.gif)

Load/Unload objects for the client.
You can save an average of 10 to 70 fps when a lot of entities are spawned in the map.

This will be available on the clientside only and will not touch or affect your server's CPU. Objects will always be networked.
If you're in cloak (FAdmin) or in spectator while targeting someone, Every objects will be rendered regardless of distance.

Works for (almost all object in Garry's Mod) : 
- Vehicles
- Players
- Permanent objects
- Bots
- Npcs, Nexbot
- Doors
- Weapons on ground
- Ragdolls 
- Lamps 
- Scripted Entities
(and more...)

To open the settings panel : (to avoid issue with players setting values too low to see through objects or to exploit and break it, [i]it work only for superadmin)
- Console Command : objectrender
- Chat : /objectrender
*You don't need to reboot your server if you change any settings, all is updated and sent to your players in real time.
- You can disable a module directly on the panel if you have any rendering problems.

![alt tag](https://steamuserimages-a.akamaihd.net/ugc/1465311304205084497/F7BA00D156A5D2742750B3B1E7D2FB2FB30A7895/?imw=637&imh=358&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=true)

The language can be changed in the shared file "centralentdrawopt_sh.lua".

Some object classes which can enter in conflicts are excluded to avoid any problems of render.
Use the comment section to report any bug.

Developed by Inj3
Source Code on GitHub : https://github.com/Inj3-GT/Improved-Object-Render

Check Changelog and bug section for more informations.

