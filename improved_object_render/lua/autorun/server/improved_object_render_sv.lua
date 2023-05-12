--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
local Ipr_Save, Ipr_Cmd = "improvedobjectrender/sauvegarde", "/objectrender"

util.AddNetworkString("Ipr_ObjectRender_Data")
util.AddNetworkString("Ipr_ObjectRender_P")

local function Ipr_Render_FileExist(ext)
     local Ipr_Ext = Ipr_Save
     if (ext) then
          Ipr_Ext = Ipr_Save ..ext
     end
     if file.Exists(Ipr_Ext, "DATA") then
          return true
     end

     return false
end

local function Ipr_BroadFunc(tbl, bool, player)
     net.Start("Ipr_ObjectRender_Data")
     net.WriteTable(tbl)

     if (bool) then
          net.Broadcast()
     else
          net.Send(player)
     end
end

local function Ipr_SaveData(tbl, bool, player)
     local Ipr_Util = util.TableToJSON(tbl)
     file.Write(Ipr_Save.. "/sv.json", Ipr_Util)

     if (bool) then
          Ipr_BroadFunc(tbl, true)
          player:SendLua([[chat.AddText(color_red, "Improved Object Render : ", color_white, "Data has been perfectly saving and is being sent to all player !" )]])
     else
          MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
     end
end

if not Ipr_Render_FileExist() then
     file.CreateDir(Ipr_Save)
end
MsgC(color_white, "[Improved Object Render] Loading Data, please wait..\n" )

if not Ipr_Render_FileExist("/sv.json") then
     MsgC( color_white, "[Improved Object Render] Creating Data, please wait..\n" )

     local Ipr_Render_DefaultTbl = {
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
               ["distance"] = 1100,
          },
          object = {
               ["enable"] = true,
               ["distance"] = 800,
          }
     }

     Ipr_SaveData(Ipr_Render_DefaultTbl, false)
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
concommand.Add("objectrender", Ipr_Render_Cmd) 

local function Ipr_Rcv_Data(len, ply)
     if ply:IsSuperAdmin() then
          Ipr_SaveData(net.ReadTable(), true, ply)
     else
          ply:SendLua([[chat.AddText(color_red, "Improved Object Render : ",color_white , "You're not superadmin, where you try to send values when you're not allowed to !" )]])
     end
end

hook.Add("PlayerSay", "Ipr_ObjectRender_Say", function(ply, text)
     if (ply:IsSuperAdmin() and string.sub(string.lower(text), 1,  string.len(Ipr_Cmd)) == Ipr_Cmd) then
         net.Start("Ipr_ObjectRender_P")
         net.Send(ply)
 
         return ""
     end
end) 

hook.Add( "PlayerInitialSpawn", "Ipr_ObjectRender_Init",  function(player, transition)
     timer.Simple(5, function()
         if not IsValid(player) then
             return
         end
 
         local Ipr_ReadTable = util.JSONToTable(file.Read(Ipr_Save.. "/sv.json", "DATA"))
         Ipr_BroadFunc(Ipr_ReadTable, false, player)
     end)
end) 

net.Receive("Ipr_ObjectRender_Data", Ipr_Rcv_Data)
