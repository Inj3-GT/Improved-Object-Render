--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
util.AddNetworkString("Ipr_ObjectRender_Data")
util.AddNetworkString("Ipr_ObjectRender_P")

local Ipr_Svg = "improved_object_render/save" --- Save path

local function Ipr_BroadFunc(t, b, p)
     net.Start("Ipr_ObjectRender_Data")
     net.WriteTable(t)
 
     if (b) then
         net.Broadcast()
         return
     end
     net.Send(p)
end

local function Ipr_SaveData(t, b, p)
     local Ipr_Util = util.TableToJSON(t)
     file.Write(Ipr_Svg.. "/sv.json", Ipr_Util)
 
     if (b) then
         Ipr_BroadFunc(t, true)
         p:SendLua([[chat.AddText(color_red, "Improved Object Render : ", color_white, "Data has been perfectly saving and is being sent to all player !" )]])
         return
     end

     MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
end

do
    if not file.Exists(Ipr_Svg, "DATA") then
        file.CreateDir(Ipr_Svg)
    end
    if not file.Exists(Ipr_Svg .."/sv.json", "DATA") then
        local ipr_t = {worldspawn = {["enable"] = true,["distance"] = 500},vehicle = {["enable"] = true,["distance"] = 700},player = {["enable"] = true,["distance"] = 700},object = {["enable"] = true,["distance"] = 500}}
        Ipr_SaveData(ipr_t, false)

        MsgC(color_white, "[Improved Object Render] Creating Data, please wait..\n" )
    else
        MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
    end
end
 
local function Ipr_RenderCmd(p)
     if not p:IsSuperAdmin() then
         return
     end

     net.Start("Ipr_ObjectRender_P")
     net.Send(p)
end

local function Ipr_RcvData(l, p)
     if not p:IsSuperAdmin() then
         return
     end

     Ipr_SaveData(net.ReadTable(), true, p)
end 

hook.Add("PlayerSay", "Ipr_ObjectRender_Say", function(p, t)
    if not p:IsSuperAdmin() then
        return
    end
    if (string.lower(t) == "/objectrender") then
        net.Start("Ipr_ObjectRender_P")
        net.Send(p)

        return ""
    end
end)

hook.Add( "PlayerInitialSpawn", "Ipr_ObjectRender_Init",  function(p)
    timer.Simple(5, function()
        if not IsValid(p) then
            return
        end

        local Ipr_ReadTable = util.JSONToTable(file.Read(Ipr_Svg.. "/sv.json", "DATA"))
        Ipr_BroadFunc(Ipr_ReadTable, false, p)
    end)
end)

concommand.Add("objectrender", Ipr_RenderCmd) 
net.Receive("Ipr_ObjectRender_Data", Ipr_RcvData)
