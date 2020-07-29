------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
Central_Table_IOR = {}

if (SERVER) then 
--- This table will be added in case there is no data file.(You can change it if you want to delete your data folder and retrieve your setting.)
--- Change only if you understand what you're doing.
Central_Table_IOR.CentralDistanceGeneralDefaultT = {
general = {
["enable"] = 1, --- If Enabled/Disabled.(Enabled = 1, Disabled = 0)
["general"] = 1000, --- Maximum distance before no longer rendering objects.
},
vehicle = {
["enable"] = 1,
["vehicle"] = 1100,
},
player = {
["enable"] = 1,
["player"] = 1400,
},
object = {
["enable"] = 1,
["object"] = 800,
}
}

Central_Table_IOR.Language_Server = {
["phrase1"] = "[Improved Object Render] Success ! Data Loaded !\n",
["phrase2"] = "[Improved Object Render] Creating Data, please wait..\n",
["phrase3"] = "[Improved Object Render] Loading Data..\n",
}
end

if (CLIENT) then
--- I will be coding an better language system soon, for the moment change all sentences below.
Central_Table_IOR.Language = {
["phrase1"] = "Settings panel for Improved Object Render",
["phrase2"] = "All data are automatically synchronized \n with players connected !",
["phrase3"] = "Enable/Disable Module :",
["phrase4"] = "General Distance :",
["phrase5"] = "Vehicle Distance :",
["phrase6"] = "Player Distance :",
["phrase7"] = "Object Distance :",
["phrase8"] = "Save IOR & synchronized",
["phrase9"] = "General",
["phrase10"] = "Vehicle",
["phrase11"] = "Player",
["phrase12"] = "Object",
["phrase13"] = "Close IOR",
["phrase14"] = "Weapons on ground, doors, ragdolls, lamps, permanent objects and more..",
["phrase15"] = "Disable all module",
["phrase16"] = "Enable all module",
}
end

function widgets.RenderMe() end
hook.Remove("PostDrawEffects", "RenderWidgets")