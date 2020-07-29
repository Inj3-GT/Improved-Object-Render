------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
------ *Do not touch below or you may break the code
local Central_Degrees_Pi, Central_Distance_NoDraw, Central_Distance_Multiplicateur, CentralTableVehiculeSent, Central_Distance_TimerLoad, Central_Distance_TimerLoad_1, Central_IOR_TimerG = 300, 500, 5, {}, "Central_EntOptimisation", "Central_IORDataSync", 0.3
local Central__Debug = false
local Central_IOR_Module = {[1] = "general",[2] = "vehicle",[3] = "player",[4] = "object",}
local Central_IOR_TableNb = {["CentralObjectNb1"] = 20,["CentralObjectNb2"] = 0,["CentralObjectNb3"] = 16,["CentralObjectNb4"] = 3,["CentralObjectNb5"] = 9,["CentralObjectNb6"] = 4,["CentralObjectNb7"] = 8,["CentralObjectNb8"] = 132,}
local Central_IOR_Table = {
WhiteList = {["prop_vehicle_jeep"] = true,["prop_physics"] = true,["player"] = true,},
BlackList = {["class C_PlayerResource"] = true,["class C_GMODGameRulesProxy"] = true,["class C_RopeKeyframe"] = true,["class C_BaseEntity"] = true,["class C_FuncAreaPortalWindow"] = true,["class C_FogController"] = true,["class C_EnvTonemapController"] = true,["class C_Sun"] = true,["class C_ShadowControl"] = true,["class C_WaterLODControl"] = true,["class C_BaseFlex"] = true,["env_sprite"] = true,["env_skypaint"] = true,["gmod_button"] = true,["gmod_tardis_interior"] = true,
["gmod_hands"] = true,["func_lod"] = true,["phys_bone_follower"] = true, ["manipulate_bone"] = true,["worldspawn"] = true,["viewmodel"] = true,["prop_vehicle_prisoner_pod"] = true,["msystem_hook_base"] = true,["vfire_cluster"] = true,["raggib"] = true,["npc_headcrab_poison"] = true,["sizehandler"] = true,["sammyservers_textscreen"] = true,},
Weapons = {["hidcam_placer"] = true,}
} 
local Central_ForceDisabled, Central_Dev_Creator, Central_Dev_Version, Central_Player_Local = false, "Inj3", "v2.0"
if !Central__Debug then
local Central_ImprovedTable
end

local function Central_IOR_Synchro_Data()
Central_ForceDisabled = true
local Central_IOR_SyncReadInt = net.ReadFloat()
local Central_IOR_SyncReadData = net.ReadData( Central_IOR_SyncReadInt )
local Central_IOR_SyncDecompress = util.Decompress( Central_IOR_SyncReadData, Central_IOR_SyncReadInt)
timer.Create(Central_Distance_TimerLoad_1, Central_IOR_TimerG + 0.1, 1,function()
Central_ImprovedTable = util.JSONToTable( Central_IOR_SyncDecompress )
Central_ForceDisabled = false
end)
end

local function Central_IOR_EntAllVerif(Central_VerifPlayer)
if (IsValid(Central_VerifPlayer:GetActiveWeapon()) and Central_IOR_Table.Weapons[Central_VerifPlayer:GetActiveWeapon():GetClass()]) or (Central_VerifPlayer:GetViewEntity():GetClass() != "player") then
return true
end
return false
end

local function Central_IOR_CheckAdmin(Central_Player_Check)
if ((Central_Player_Check:GetMoveType() == Central_IOR_TableNb.CentralObjectNb7 and Central_Player_Check:GetNoDraw() == true and !Central_Player_Check:InVehicle()) or ((FAdmin) and Central_Player_Check:FAdmin_GetGlobal("FAdmin_cloaked"))) then  
return true 
end
return false
end

local function Central_IOR_EntDrawBool(Central_Val_Bool, Bool)
if (Bool) then
Central_Val_Bool:SetNoDraw(true)
return
end
Central_Val_Bool:SetNoDraw(false)
end

local function Central_IOR_EntDraw(Central_DrawBL, Central_Player, Central_Bool, Central_Val)
if (Central_IOR_CheckAdmin(Central_Player) or Central_IOR_EntAllVerif(Central_Player)) or ((FSpectate) and FSpectate.getSpecEnt() != nil) then return Central_IOR_EntDrawBool(Central_Val, false) end
if (Central_DrawBL) then
if (Central_Player:GetPos():Distance(Central_Val:GetPos()) < Central_Distance_NoDraw) then return Central_IOR_EntDrawBool(Central_Val, false) end
if (Central_Bool) then
local Central_Direct_Ang = math.pi / Central_Degrees_Pi
local Central_Aim_Vector = Central_Player:GetAimVector()
local Central_Ent_Vector = Central_Val:GetPos() - Central_Player:GetShootPos()
local Central_AimEnt_Vector = Central_Aim_Vector:Dot( Central_Ent_Vector ) / Central_Ent_Vector:Length() 
local Central_Result_Veh = Central_AimEnt_Vector < Central_Direct_Ang
if (Central_Result_Veh) then
return Central_IOR_EntDrawBool(Central_Val, true) 
end
end
return Central_IOR_EntDrawBool(Central_Val, false) 
else
if (Central_Bool) then
return Central_IOR_EntDrawBool(Central_Val, true) 
end
return Central_IOR_EntDrawBool(Central_Val, false) 
end
end

local function Central_IOR_SentObject(object)
if (object:IsScripted()) then
for i =1, #object:GetChildren() do
CentralTableVehiculeSent[object:GetChildren()[i]] = true
end
end
if CentralTableVehiculeSent[object] then return CentralTableVehiculeSent end
return CentralTableVehiculeSent
end

local function Central_IOR_EntDrawOptimisation()
local Central_Player_VGet = Central_Player_Local:GetVehicle()
for _, object in pairs( ents.FindByClass( "*" ) ) do
local Central_ObjClass = object:GetClass()
if (Central_IOR_Table.BlackList[Central_ObjClass] or object == Central_Player_Local or object == Central_Player_VGet) then 
continue
end
if (Central_ForceDisabled) then Central_IOR_EntDrawBool(object, false) continue end
if (Central_ImprovedTable.general["enable"] == 1 and !Central_IOR_Table.WhiteList[Central_ObjClass]) then
if (((object:IsNPC() or object.Type == "nextbot") and (object:GetSolidFlags() == Central_IOR_TableNb.CentralObjectNb1 and object:GetMoveType()  == Central_IOR_TableNb.CentralObjectNb2) or (object:GetSolidFlags() == Central_IOR_TableNb.CentralObjectNb1 and object:GetMoveType()  == Central_IOR_TableNb.CentralObjectNb4 and !object:GetSpawnEffect()) or (Central_IOR_SentObject(object)[object])) or (Central_ObjClass == "prop_dynamic" and object:GetSolidFlags() == Central_IOR_TableNb.CentralObjectNb2 and object:GetRenderGroup() == Central_IOR_TableNb.CentralObjectNb5) or (object:IsWeapon() and object:GetSolidFlags() == Central_IOR_TableNb.CentralObjectNb8)) then
continue 
end
if Central_Player_Local:GetPos():Distance(object:GetPos()) <= Central_ImprovedTable.general["general"] * Central_Distance_Multiplicateur then
Central_IOR_EntDraw(true, Central_Player_Local, true, object)
else
Central_IOR_EntDraw(false, Central_Player_Local, true, object)
end
end
if (Central_ImprovedTable.vehicle["enable"] == 1 and Central_ObjClass == "prop_vehicle_jeep" and object:IsVehicle()) then
if Central_Player_Local:GetPos():Distance(object:GetPos()) <= Central_ImprovedTable.vehicle["vehicle"] * Central_Distance_Multiplicateur then
Central_IOR_EntDraw(true, Central_Player_Local, true, object)
else
Central_IOR_EntDraw(false, Central_Player_Local, true, object)
end
end
if (Central_ImprovedTable.object["enable"] == 1 and Central_ObjClass == "prop_physics" and IsEntity(object)) then 
if (object:GetSolidFlags() == Central_IOR_TableNb.CentralObjectNb6) then continue end      
if Central_Player_Local:GetPos():Distance(object:GetPos()) <= Central_ImprovedTable.object["object"] * Central_Distance_Multiplicateur then
Central_IOR_EntDraw(false, Central_Player_Local, false, object)
else
Central_IOR_EntDraw(false, Central_Player_Local, true, object)
end
end	
if (Central_ImprovedTable.player["enable"] == 1 and Central_ObjClass == "player" and object:IsPlayer()) then
if (!IsValid(object:GetMoveParent()) and object:GetObserverTarget():IsRagdoll() and !object:GetSpawnEffect()) then 
if IsValid(object:GetActiveWeapon()) then
Central_IOR_EntDrawBool(object:GetActiveWeapon(), true)
end
continue
end
if (Central_IOR_CheckAdmin(object)) then 
Central_IOR_EntDrawBool(object, true)
else 
if Central_Player_Local:GetPos():Distance(object:GetPos()) <= Central_ImprovedTable.player["player"] * Central_Distance_Multiplicateur then
Central_IOR_EntDraw(true, Central_Player_Local, true, object)
else
Central_IOR_EntDraw(false, Central_Player_Local, true, object)
end
end
end
end
CentralTableVehiculeSent = {}
end

local function Central_IOR_Optimisation_Load()
if (Central__Debug) then
timer.Remove(Central_Distance_TimerLoad)
else
if timer.Exists(Central_Distance_TimerLoad) then return end
local Central_IOR_ReadInt = net.ReadFloat()
local Central_IOR_ReadData = net.ReadData( Central_IOR_ReadInt )
local Central_IOR_Decompress = util.Decompress( Central_IOR_ReadData, Central_IOR_ReadInt)
Central_ImprovedTable = util.JSONToTable( Central_IOR_Decompress )
end
Central_Player_Local = LocalPlayer()
timer.Create(Central_Distance_TimerLoad, Central_IOR_TimerG, 0, Central_IOR_EntDrawOptimisation ) 
end 
if (Central__Debug) then
Central_IOR_Optimisation_Load()
end 

local function Central_IOR_EXT()
Central_IOR_ClientTable = nil
Central_IOR_ClientTableChange = nil
net.Start("central_ior_frm")
net.SendToServer()  
end

local function Central_IOR_Panel()
local Central_Frame_ICN, Central_Frame_ICN_1, Central_Frame_ICN_2, Central_Frame_ICN_3, Central_Frame_ICN_4, Central_Frame_ICN_Font = "icon16/cog.png", "icon16/bullet_wrench.png", "icon16/cross.png", "icon16/bullet_green.png", "icon16/bullet_red.png", "Default"

local Central_IOR_ClientTable = Central_ImprovedTable
local Central_IOR_ClientTableChange = table.Copy( Central_IOR_ClientTable )
local Central_IOR_Enable, Central_IOR_EnableColor = "Off", Color( 255, 0, 0, 250 )
for k, v in pairs(Central_IOR_ClientTable) do
if v["enable"] == 1 then Central_IOR_Enable = "On" Central_IOR_EnableColor = Color( 0, 125, 0, 255 ) end
end

local Central_IOR_Frame = vgui.Create( "DFrame" )
local Central_IOR_Slider_1 = vgui.Create( "DNumSlider", Central_IOR_Frame )
local Central_IOR_Slider_2 = vgui.Create( "DNumSlider", Central_IOR_Frame )
local Central_IOR_Slider_3 = vgui.Create( "DNumSlider", Central_IOR_Frame )
local Central_IOR_Slider_4 = vgui.Create( "DNumSlider", Central_IOR_Frame )
local Central_IOR_CheckBox_1 = vgui.Create("DCheckBoxLabel", Central_IOR_Frame)
local Central_IOR_CheckBox_2 = vgui.Create( "DCheckBoxLabel", Central_IOR_Frame)
local Central_IOR_CheckBox_3 = vgui.Create("DCheckBoxLabel", Central_IOR_Frame)
local Central_IOR_CheckBox_4 = vgui.Create( "DCheckBoxLabel", Central_IOR_Frame)
local Central_IOR_X1 = vgui.Create( "DButton", Central_IOR_Frame )
local Central_IOR_X2 = vgui.Create("DButton", Central_IOR_Frame)
local Central_IOR_X3 = vgui.Create("DButton", Central_IOR_Frame)

Central_IOR_Frame:SetTitle("")
Central_IOR_Frame:ShowCloseButton(false)
Central_IOR_Frame:SetIcon(Central_Frame_ICN)
Central_IOR_Frame:SetDraggable(true)
Central_IOR_Frame:MakePopup()
Central_IOR_Frame:SetTitle("")
Central_IOR_Frame:SetPos(ScrW()/2-150, ScrH()/2-200)
Central_IOR_Frame:SetSize( 0, 0 )
Central_IOR_Frame:SizeTo( 280, 430, .5, 0, 10)
Central_IOR_Frame.Paint = function( self, w, h )
draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255, 240))
draw.RoundedBox( 6, 0, 0, w, 25, Color(0,50,175,240))
draw.RoundedBox( 8, 30, 55, w - 60, 80, Color(0,69,165,250))
draw.RoundedBox( 8, 32, 57, w - 64, 76, Color(255,255,255,250))
draw.DrawText( Central_Table_IOR.Language["phrase1"], Central_Frame_ICN_Font, w/2+6,6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase2"], Central_Frame_ICN_Font, w/2,340, Color( 255, 0, 0, 250 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase3"], Central_Frame_ICN_Font, w/2,61, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase4"], Central_Frame_ICN_Font, w/2,145, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase5"], Central_Frame_ICN_Font, w/2,195, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase6"], Central_Frame_ICN_Font, w/2,245, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  Central_Table_IOR.Language["phrase7"], Central_Frame_ICN_Font, w/2,295, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText(  "Status : " ..Central_IOR_Enable, Central_Frame_ICN_Font, 35,28, Central_IOR_EnableColor, TEXT_ALIGN_CENTER )
draw.DrawText( Central_Dev_Creator, Central_Frame_ICN_Font, 15,416, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Central_Dev_Version, Central_Frame_ICN_Font, w-15,416, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
end
   
Central_IOR_Slider_1:SetPos( -194, 160 )
Central_IOR_Slider_1:SetSize( 485, 20 )	
Central_IOR_Slider_1:SetText( "" )	
Central_IOR_Slider_1:SetMinMax( 105, 3000 )
Central_IOR_Slider_1:SetValue(Central_IOR_ClientTable.general["general"])
Central_IOR_Slider_1:SetDecimals( 0 )
Central_IOR_Slider_1.Nom = Central_IOR_Module[1]
Central_IOR_Slider_1.OnValueChanged = function(self, val)
local Central_SLF = self.Nom
Central_IOR_ClientTableChange[Central_SLF][Central_SLF] = math.Round(self:GetValue())
end      
 
Central_IOR_Slider_2:SetPos( -195, 210 )
Central_IOR_Slider_2:SetSize( 485, 20 )	
Central_IOR_Slider_2:SetText( "" )	
Central_IOR_Slider_2:SetMinMax( 105, 3000 )
Central_IOR_Slider_2:SetValue(Central_IOR_ClientTable.vehicle["vehicle"])
Central_IOR_Slider_2:SetDecimals( 0 )
Central_IOR_Slider_2.Nom = Central_IOR_Module[2]
Central_IOR_Slider_2.OnValueChanged = Central_IOR_Slider_1.OnValueChanged

Central_IOR_Slider_3:SetPos( -195, 260 )
Central_IOR_Slider_3:SetSize( 485, 20 )	
Central_IOR_Slider_3:SetText( "" )	
Central_IOR_Slider_3:SetMinMax( 105, 3000 )
Central_IOR_Slider_3:SetValue(Central_IOR_ClientTable.player["player"])
Central_IOR_Slider_3:SetDecimals( 0 )
Central_IOR_Slider_3.Nom = Central_IOR_Module[3]
Central_IOR_Slider_3.OnValueChanged = Central_IOR_Slider_1.OnValueChanged

Central_IOR_Slider_4:SetPos( -195, 310 )
Central_IOR_Slider_4:SetSize( 485, 20 )	
Central_IOR_Slider_4:SetText( "" )	
Central_IOR_Slider_4:SetMinMax( 105, 3000 ) 
Central_IOR_Slider_4:SetValue(Central_IOR_ClientTable.object["object"])
Central_IOR_Slider_4:SetDecimals( 0 )
Central_IOR_Slider_4.Nom = Central_IOR_Module[4]
Central_IOR_Slider_4.OnValueChanged = Central_IOR_Slider_1.OnValueChanged

Central_IOR_CheckBox_1:SetPos( 65,80 )	
Central_IOR_CheckBox_1:SetFont( Central_Frame_ICN_Font )
Central_IOR_CheckBox_1:SetText( Central_Table_IOR.Language["phrase9"] )		
Central_IOR_CheckBox_1:SetTooltip( Central_Table_IOR.Language["phrase14"]  )
Central_IOR_CheckBox_1:SetValue(Central_IOR_ClientTable.general["enable"])
Central_IOR_CheckBox_1:SetTextColor( Color(0,0,0) )
Central_IOR_CheckBox_1.Nom = Central_IOR_Module[1]
Central_IOR_CheckBox_1.OnChange = function(self, val)
local Central_SLF = self.Nom
local Central_Int = 1
if !self:GetChecked() then
Central_Int = 0
end
Central_IOR_ClientTableChange[Central_SLF]["enable"] = Central_Int
end   
Central_IOR_CheckBox_1:SizeToContents()	
 
Central_IOR_CheckBox_2:SetPos( 65,110 )	
Central_IOR_CheckBox_2:SetFont( Central_Frame_ICN_Font )
Central_IOR_CheckBox_2:SetText( Central_Table_IOR.Language["phrase10"] )		
Central_IOR_CheckBox_2:SetTooltip( Central_Table_IOR.Language["phrase10"] )
Central_IOR_CheckBox_2:SetValue(Central_IOR_ClientTable.vehicle["enable"])
Central_IOR_CheckBox_2:SetTextColor( Color(0,0,0) )
Central_IOR_CheckBox_2.Nom = Central_IOR_Module[2]
Central_IOR_CheckBox_2.OnChange = Central_IOR_CheckBox_1.OnChange
Central_IOR_CheckBox_2:SizeToContents()	

Central_IOR_CheckBox_3:SetPos( 160,80 )	
Central_IOR_CheckBox_3:SetFont( Central_Frame_ICN_Font )
Central_IOR_CheckBox_3:SetText( Central_Table_IOR.Language["phrase11"] )		
Central_IOR_CheckBox_3:SetTooltip( Central_Table_IOR.Language["phrase11"] )
Central_IOR_CheckBox_3:SetValue(Central_IOR_ClientTable.player["enable"])
Central_IOR_CheckBox_3:SetTextColor( Color(0,0,0) )
Central_IOR_CheckBox_3.Nom = Central_IOR_Module[3]
Central_IOR_CheckBox_3.OnChange = Central_IOR_CheckBox_1.OnChange
Central_IOR_CheckBox_3:SizeToContents()	
 
Central_IOR_CheckBox_4:SetPos( 160,110 )	
Central_IOR_CheckBox_4:SetFont( Central_Frame_ICN_Font )
Central_IOR_CheckBox_4:SetText( Central_Table_IOR.Language["phrase12"] )		
Central_IOR_CheckBox_4:SetTooltip( Central_Table_IOR.Language["phrase12"] )
Central_IOR_CheckBox_4:SetValue(Central_IOR_ClientTable.object["enable"])
Central_IOR_CheckBox_4:SetTextColor( Color(0,0,0) )
Central_IOR_CheckBox_4.Nom = Central_IOR_Module[4]
Central_IOR_CheckBox_4.OnChange = Central_IOR_CheckBox_1.OnChange
Central_IOR_CheckBox_4:SizeToContents()	
 
Central_IOR_X1:SetPos( 60, 372 )
Central_IOR_X1:SetSize( 160, 23 ) 
Central_IOR_X1:SetText( "" )
Central_IOR_X1:SetImage( Central_Frame_ICN_1 )	
Central_IOR_X1.Paint = function( self, w, h )	
local Central_IOR_VT = math.abs(math.sin(CurTime() * 3) * 255)
local Central_IOR_VT_A = Color(0, Central_IOR_VT, 0)
draw.RoundedBox( 6, 3, 0, w-4, h, Central_IOR_VT_A )
draw.RoundedBox( 6, 2, 1, w-2, h-2, Color(0, 69, 175) )
draw.DrawText( Central_Table_IOR.Language["phrase8"], Central_Frame_ICN_Font, w/2+7,5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
Central_IOR_X1.DoClick = function() 
net.Start("central_ior_rdvdata")
net.WriteTable(Central_IOR_ClientTableChange)
net.SendToServer()  
timer.Simple(0.1,function()
Central_IOR_EXT()
Central_IOR_Frame:Remove()
end)
end
 
Central_IOR_X2:SetPos( 95, 28 ) 
Central_IOR_X2:SetSize( 90, 18 )
Central_IOR_X2:SetText( "" ) 
Central_IOR_X2:SetImage( Central_Frame_ICN_2 )
function Central_IOR_X2:Paint( w, h )
local Central_IOR_RD = math.abs(math.sin(CurTime() * 3) * 255)
local Central_IOR_RD_A = Color(Central_IOR_RD, 0, 0)
draw.RoundedBox( 6, 3, 0, w-4, h, Central_IOR_RD_A )
draw.RoundedBox( 6, 2, 1, w-2, h-2, Color(0, 69, 175) )
draw.DrawText( Central_Table_IOR.Language["phrase13"], Central_Frame_ICN_Font, w/2+5,3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
Central_IOR_X2.DoClick = function()
Central_IOR_EXT() 
Central_IOR_Frame:Remove()
end

Central_IOR_X3:SetPos( 79, 402 ) 
Central_IOR_X3:SetSize( 125, 23 )
Central_IOR_X3:SetText( "" ) 
if Central_IOR_Enable == "Off" then
Central_IOR_X3:SetImage( Central_Frame_ICN_3 )
else
Central_IOR_X3:SetImage( Central_Frame_ICN_4 )
end
function Central_IOR_X3:Paint( w, h )
local Central_IOR_RD = math.abs(math.sin(CurTime() * 3) * 255)
local Central_IOR_RD_A = Color(Central_IOR_RD, 0, 0)
draw.RoundedBox( 6, 3, 0, w-4, h, Central_IOR_RD_A )
draw.RoundedBox( 6, 2, 1, w-2, h-2, Color(0, 69, 175) )
if Central_IOR_Enable == "On" then
draw.DrawText( Central_Table_IOR.Language["phrase15"], Central_Frame_ICN_Font, w/2+6,5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
else
draw.DrawText( Central_Table_IOR.Language["phrase16"], Central_Frame_ICN_Font, w/2+6,5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
end
Central_IOR_X3.DoClick = function()
for k, v in pairs(Central_IOR_ClientTableChange) do
if Central_IOR_Enable == "On" then
v["enable"] = 0
else
v["enable"] = 1
end
end
net.Start("central_ior_rdvdata")
net.WriteTable(Central_IOR_ClientTableChange)
net.SendToServer() 
timer.Simple(0.1,function()
Central_IOR_EXT() 
Central_IOR_Frame:Remove()
end)
end

end

net.Receive("central_ior_sndata", Central_IOR_Synchro_Data)
net.Receive("central_ior_loadopti", Central_IOR_Optimisation_Load)
net.Receive("central_ior_cmd", Central_IOR_Panel)
