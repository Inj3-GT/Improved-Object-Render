------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
util.AddNetworkString("Ipr_ObjectRender_Data")
util.AddNetworkString("Ipr_ObjectRender_P")

local Ipr_Save, Ipr_Cmd = "improvedobjectrender/sauvegarde", "/objectrender"
local function Ipr_Render_FileExist(ext)
     local Ipr_Ext = Ipr_Save
     if ext then
          Ipr_Ext = Ipr_Save ..ext
     end
     if file.Exists(Ipr_Ext, "DATA") then
          return true
     end

     return false
end

local function Ipr_BroadFunc(tbl, bool, player)
     local Ipr_Compress = util.Compress(tbl)

     net.Start("Ipr_ObjectRender_Data")
     net.WriteUInt(#tbl, 8)
     net.WriteData(Ipr_Compress, #Ipr_Compress)
     if bool then
          net.Broadcast()
     else
          net.Send(player)
     end
end

local function Ipr_SaveData(tbl, bool, player)
     local Ipr_Util = util.TableToJSON(tbl)
     file.Write(Ipr_Save.. "/sv[2].txt", Ipr_Util)

     if bool then
          Ipr_BroadFunc(Ipr_Util, true)
          player:SendLua([[chat.AddText( Color(255,0,0),"Improved Object Render : ", Color(255,255,255), "Data has been perfectly saving and is being sent to all player !" )]])
     else
          MsgC(color_white, "[Improved Object Render] Success ! Data Loaded !\n" )
     end
end

if not Ipr_Render_FileExist() then
     file.CreateDir(Ipr_Save)
end
MsgC(color_white, "[Improved Object Render] Loading Data, please wait..\n" )

if not Ipr_Render_FileExist("/sv[2].txt") then
     MsgC( color_white, "[Improved Object Render] Creating Data, please wait..\n" )

     local Ipr_Render_DefaultTbl = {
          worldspawn = {
               ["enable"] = true, --- If Enabled/Disabled.(Enabled = 1, Disabled = 0)
               ["distance"] = 500, --- Maximum distance before no longer rendering objects.
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
     if ply:IsSuperAdmin() then
          net.Start("Ipr_ObjectRender_P")
          net.Send(ply)
     end
end

local function Ipr_Rcv_Data(len, ply)
     if ply:IsSuperAdmin() then
          Ipr_SaveData(net.ReadTable(), true, ply)
     else
          ply:SendLua([[chat.AddText( Color(255,0,0),"Improved Object Render : ", Color(255,255,255), "You're not superadmin, where you try to send values when you're not allowed to !" )]])
     end
end

hook.Add("PlayerSay", "Ipr_ObjectRender_Say", function(ply, text)
if ply:IsSuperAdmin() and string.sub(string.lower(text), 1,  string.len(Ipr_Cmd)) == Ipr_Cmd then
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

local Ipr_ReadTable = file.Read(Ipr_Save.. "/sv[2].txt", "DATA")
Ipr_BroadFunc(Ipr_ReadTable, false, player)
end)
end)

concommand.Add( "objectrender", Ipr_Render_Cmd)
net.Receive("Ipr_ObjectRender_Data", Ipr_Rcv_Data)