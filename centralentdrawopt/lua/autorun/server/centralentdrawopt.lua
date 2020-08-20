------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
util.AddNetworkString("central_ior_rdvdata")
util.AddNetworkString("central_ior_sndata")
util.AddNetworkString("central_ior_cmd")
util.AddNetworkString("central_ior_frm")
local Central_Ior_Sauvegarde, Central_Ior_CMD, Central_Table_Update, Central_IOR =  "improvedobjectrender/sauvegarde", "/objectrender", nil, false
local Central_Ior_CacheColor, Central_Ior_CacheColor2 = Color(255,0,0), Color( 0, 175, 0 )

hook.Add("PlayerSay", "Central_IOR_CmdOpenSv", function(ply, text)
if ( string.sub( string.lower(text), 1,  string.len(Central_Ior_CMD) ) == Central_Ior_CMD ) and (ply:IsSuperAdmin() and !ply.Central_IOR) then	
net.Start("central_ior_cmd") 
net.Send(ply)
ply.Central_IOR = true
return ""
end 
end)

concommand.Add( "objectrender", function(ply, cmd, args) 
if (ply:IsSuperAdmin() and !ply.Central_IOR) then
net.Start("central_ior_cmd") 
net.Send(ply)
ply.Central_IOR = true
end
end)

local function Central_IOR_PreventExploit(player)
if (IsValid(player) and player.Central_IOR and player:IsSuperAdmin()) then 
return true
end
return false
end

local function Central_IOR_FRM(len, ply)
if Central_IOR_PreventExploit(ply) then
ply.Central_IOR = false
end
end

local function Central_IOR_FileExists(extension)
local Central_IOR_Ext = Central_Ior_Sauvegarde
if (extension != nil) then Central_IOR_Ext = Central_Ior_Sauvegarde ..extension end
if file.Exists( Central_IOR_Ext, "DATA" ) then
return true
end
return false
end

local function Central_IOR_BroadcastFunc(table_broadcast, numb, player)
local table_broadcast = table_broadcast
if (numb == 0) then
table_broadcast = util.TableToJSON(table_broadcast)
end
local Central_Compress_Table = util.Compress(table_broadcast)
local Central_Compress_Len = string.len(table_broadcast)
net.Start("central_ior_sndata") 
net.WriteFloat(Central_Compress_Len)
net.WriteData(Central_Compress_Table, Central_Compress_Len)
if (numb == 1) then
net.WriteBool(true)
net.Broadcast()
else
net.WriteBool(false)
net.Send(player)
end
table_broadcast = nil
Central_Compress_Table = nil
Central_Compress_Len = nil
end

local function Central_IOR_SauvegardeData(table, simple, player)
if (!istable(table) or table == nil) then return end
if (!Central_IOR_FileExists()) then 
file.CreateDir(Central_Ior_Sauvegarde)
end
local Central_IOR_UtiLJson = util.TableToJSON(table)
file.Write(Central_Ior_Sauvegarde.. "/sv.txt", Central_IOR_UtiLJson ) 
if (simple == 1) then
Central_IOR_BroadcastFunc(Central_IOR_UtiLJson, 1)
if (IsValid(player)) then
player:SendLua([[chat.AddText( Color(255,0,0),"Improved Object Render : ", Color(255,255,255), "Data has been perfectly saving and is being sent to all player !" )]])
end
else
MsgC( Central_Ior_CacheColor2,  Central_Table_IOR.Language_Server["phrase1"] )
end
Central_Table_Update  = table
Central_IOR_UtiLJson = nil
end

local function Central_IOR_ChargeData()
local Central_IOR_LoadInit = util.JSONToTable(file.Read(Central_Ior_Sauvegarde.. "/sv.txt", "DATA"))
Central_Table_Update  = Central_IOR_LoadInit
MsgC( Central_Ior_CacheColor2, Central_Table_IOR.Language_Server["phrase1"] )
Central_IOR_LoadInit = nil
end

hook.Add("Initialize","Central_IOR_initTable",function()
if (!Central_IOR_FileExists()) then 
file.CreateDir(Central_Ior_Sauvegarde)
end
if (!Central_IOR_FileExists("/sv.txt")) then
MsgC( Central_Ior_CacheColor, Central_Table_IOR.Language_Server["phrase2"] )
Central_IOR_SauvegardeData(Central_Table_IOR.CentralDistanceGeneralDefaultT, 0)
else
MsgC( Central_Ior_CacheColor, Central_Table_IOR.Language_Server["phrase3"] )
Central_IOR_ChargeData()
end
end)

local function Central_IOR_Init(ply)
timer.Simple(7, function()
if !IsValid(ply) then return end
local Central_Tbl_Init = Central_Table_Update
if (Central_Tbl_Init == nil) then
Central_Tbl_Init = Central_Table_IOR.CentralDistanceGeneralDefaultT
end
Central_IOR_BroadcastFunc(Central_Tbl_Init, 0, ply)
end)
end

local function Central_IOR_RCVData(len, ply)
if Central_IOR_PreventExploit(ply) then
local Central_ReceiveDataTbl = net.ReadTable()
Central_IOR_SauvegardeData(Central_ReceiveDataTbl, 1, ply)
else
ply:SendLua([[chat.AddText( Color(255,0,0),"Improved Object Render : ", Color(255,255,255), "You're not superadmin, where you try to send values when you're not allowed to !" )]])
end
end

net.Receive("central_ior_rdvdata", Central_IOR_RCVData)
net.Receive("central_ior_frm", Central_IOR_FRM)
hook.Add( "PlayerInitialSpawn", "Central_IOR_Init",  Central_IOR_Init)