--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
local Ipr_Save, Ipr_Cmd = "improvedobjectrender/sauvegarde", "/objectrender"

util.AddNetworkString("Ipr_ObjectRender_Data")
util.AddNetworkString("Ipr_ObjectRender_P")

local function Ipr_RenderExists(ext)
     local Ipr_Ext = Ipr_Save
     if (ext) then
         Ipr_Ext = Ipr_Save ..ext
     end
     if (file.Exists(Ipr_Ext, "DATA")) then
         return true
     end
 
     return false
end

local function Ipr_BroadFunc(tbl, bool, player)
     net.Start("Ipr_ObjectRender_Data")
     net.WriteTable(tbl)
 
     if (bool) then
         net.Broadcast()
         return
     end
     net.Send(player)
end

local function Ipr_SaveData(tbl, bool, player)
     local Ipr_Util = util.TableToJSON(tbl)
     file.Write(Ipr_Save.. "/sv.json", Ipr_Util)
 
     if (bool) then
         Ipr_BroadFunc(tbl, true)
         player:SendLua([[chat.AddText(color_red, "Improved Object Render : ", color_white, "Data has been perfectly saving and is being sent to all player !" )]])
         return
     end
     MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
end 

if not Ipr_RenderExists() then
     file.CreateDir(Ipr_Save)
end
if not Ipr_RenderExists("/sv.json") then
     MsgC(color_white, "[Improved Object Render] Creating Data, please wait..\n" )
 
     local Ipr_R = {
         worldspawn = {
             ["enable"] = true,
             ["distance"] = 500,
         },
         vehicle = {
             ["enable"] = true,
             ["distance"] = 1000,
         },
         player = {
             ["enable"] = true,
             ["distance"] = 1000,
         },
         object = {
             ["enable"] = true,
             ["distance"] = 800,
         }
     }
 
     Ipr_SaveData(Ipr_R, false)
else
     MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
end
 
local function Ipr_Render_Cmd(ply, cmd, args)
     if not ply:IsSuperAdmin() then
         return
     end

     net.Start("Ipr_ObjectRender_P")
     net.Send(ply)
end

local function Ipr_Rcv_Data(len, ply)
     if not ply:IsSuperAdmin() then
         return
     end

     Ipr_SaveData(net.ReadTable(), true, ply)
end
 
hook.Add("PlayerSay", "Ipr_ObjectRender_Say", function(ply, text)
     if not ply:IsSuperAdmin() then
         return
     end
     if (string.sub(string.lower(text), 1, string.len(Ipr_Cmd)) == Ipr_Cmd) then
         net.Start("Ipr_ObjectRender_P")
         net.Send(ply)
 
         return ""
     end
end)

hook.Add( "PlayerInitialSpawn", "Ipr_ObjectRender_Init",  function(player)
     timer.Simple(5, function()
         if not IsValid(player) then
             return
         end
 
         local Ipr_ReadTable = util.JSONToTable(file.Read(Ipr_Save.. "/sv.json", "DATA"))
         Ipr_BroadFunc(Ipr_ReadTable, false, player)
     end)
end) 

concommand.Add("objectrender", Ipr_Render_Cmd) 
net.Receive("Ipr_ObjectRender_Data", Ipr_Rcv_Data)
