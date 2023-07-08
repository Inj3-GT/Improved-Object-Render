--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
if (SERVER) then
    return
end
Ipr_RenderObject = Ipr_RenderObject or {}
Ipr_RenderObject.Render = Ipr_RenderObject.Render or {}
Ipr_RenderObject.Version = "v3.9.3"
    
Ipr_RenderObject.Language = {
    settings = "Settings panel for Improved Object Render",
    datasend = "All data are automatically synchronized \n with players connected !",
    enable = "Enable/Disable Module :",
    world_dist = "World Distance :",
    veh_dist = "Vehicle Distance :",
    player_dist = "Player Distance :",
    object_dist = "Prop Distance :",
    save_settings = "Save settings IOR",
    world = "World",
    veh = "Vehicle",
    ply = "Player",
    obj = "Prop",
    close_ = "Close IOR",
    weapandmore = "Weapons on ground, doors, ragdolls, lamps, permanent objects and more..",
}

Ipr_RenderObject.EntRend = {
    ["class C_ClientRagdoll"] = "ipr_world", 
    ["class C_BaseEntity"] = "ipr_world", 
    ["npc_"] = "ipr_world", 
    ["beam"] = "ipr_world", 
    ["gmod_"] = "ipr_world", 
    ["func_"] = "ipr_world",
    ["prop_vehicle_"] = "ipr_vehicle", 
    ["prop_p"] = "ipr_prop", 
    ["prop_d"] = "ipr_prop", 
    ["prop_r"] = "ipr_prop", 
}
