------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
local Central_Distance_General = 1000
local Central_Distance_Vehicule = 1100  ----- Default value
local Central_Distance_Joueur = 1400
local Central_Distance_Object = 800
----- Works with all maps / Dynamically loads/unloads object visibility
----- Permanent objects, entities, vehicles, players, doors and more...
----- This script can save you between 5 to 70 fps when there are a lot of objects to display on your map.
local Central_Degrees_Pi, Central_Distance_NoDraw, Central_Distance_Multiplicateur, CentralTableVehiculeSent = 300, 500, 5, {}
local Central__Debug = false
local Central_TblDrawOptiBlacklist_General = {
["class C_PlayerResource"] = true,
["class C_GMODGameRulesProxy"] = true,
["class C_RopeKeyframe"] = true,
["class C_BaseEntity"] = true,
["class C_FuncAreaPortalWindow"] = true,
["class C_FogController"] = true,
["class C_EnvTonemapController"] = true,
["class C_Sun"] = true,
["class C_ShadowControl"] = true,
["class C_WaterLODControl"] = true,
["class C_BaseFlex"] = true,
["env_sprite"] = true,
["env_skypaint"] = true,
["gmod_button"] = true,
["gmod_tardis_interior"] = true,
["gmod_hands"] = true,
["func_lod"] = true,
["phys_bone_follower"] = true, 
["manipulate_bone"] = true,
["worldspawn"] = true,
["viewmodel"] = true,
["prop_vehicle_prisoner_pod"] = true,
["msystem_hook_base"] = true,
["vfire_cluster"] = true,
["raggib"] = true,
["npc_headcrab_poison"] = true,
["sizehandler"] = true,
}
local Central_TblDrawOptiWhiteList = {
["prop_vehicle_jeep"] = true,
["prop_physics"] = true,
["player"] = true,
}
local Central_TblDrawOptiBlacklist_Weapons = {
["hidcam_placer"] = true,
}

local function Central_Ent_All_Verif(Central_VerifPlayer)
if (IsValid(Central_VerifPlayer:GetActiveWeapon()) and Central_TblDrawOptiBlacklist_Weapons[Central_VerifPlayer:GetActiveWeapon():GetClass()]) or (Central_VerifPlayer:GetViewEntity():GetClass() != "player") then
return true
end
return false
end

local function Central_Check_Admin(Central_Player_Check)
if ((Central_Player_Check:GetMoveType() == 8 and Central_Player_Check:GetNoDraw() == true and !Central_Player_Check:InVehicle()) or ((FSpectate) and FSpectate.getSpecEnt() != nil) or ((FAdmin) and Central_Player_Check:FAdmin_GetGlobal("FAdmin_cloaked"))) then  
return true 
end
return false
end

local function Central_Ent_DrawBool(Central_Val_Bool, Bool)
if (Bool) then
Central_Val_Bool:SetNoDraw(true)
return
end
Central_Val_Bool:SetNoDraw(false)
end

local function Central_Ent_Draw(Central_DrawBL, Central_Player, Central_Bool, Central_Val)
if (Central_DrawBL) then
if (Central_Player:GetPos():Distance(Central_Val:GetPos()) < Central_Distance_NoDraw or (Central_Check_Admin(Central_Player)) or (Central_Ent_All_Verif(Central_Player))) then return Central_Ent_DrawBool(Central_Val, false) end
if (Central_Bool) then
local Central_Direct_Ang = math.pi / Central_Degrees_Pi
local Central_Aim_Vector = Central_Player:GetAimVector()
local Central_Ent_Vector = Central_Val:GetPos() - Central_Player:GetShootPos()
local Central_AimEnt_Vector = Central_Aim_Vector:Dot( Central_Ent_Vector ) / Central_Ent_Vector:Length() 
local Central_Result_Veh = Central_AimEnt_Vector < Central_Direct_Ang
if (Central_Result_Veh) then
return Central_Ent_DrawBool(Central_Val, true) 
end
end
return Central_Ent_DrawBool(Central_Val, false) 
else
if (Central_Check_Admin(Central_Player) or (Central_Ent_All_Verif(Central_Player))) then return Central_Ent_DrawBool(Central_Val, false) end
if (Central_Bool) then
return Central_Ent_DrawBool(Central_Val, true) 
end
return Central_Ent_DrawBool(Central_Val, false) 
end
end

local function CentralVehiculeSent(object)
if (object:IsScripted()) then
for i =1, #object:GetChildren() do
CentralTableVehiculeSent[object:GetChildren()[i]] = true
end
end
if CentralTableVehiculeSent[object] then return CentralTableVehiculeSent end
return CentralTableVehiculeSent
end

local function Central_EntDraw_Optimisation()
local Central_Player_Local = LocalPlayer()
local Central_Player_VGet = Central_Player_Local:GetVehicle()
for _, object in pairs( ents.FindByClass( "*" ) ) do
local Central_ObjClass = object:GetClass()
if (Central_TblDrawOptiBlacklist_General[Central_ObjClass] or object == Central_Player_Local or object == Central_Player_VGet or object:IsWeapon()) then 
continue
end
local Central_Ent_PosXY = Central_Player_Local:GetPos():Distance(object:GetPos())
if (!Central_TblDrawOptiWhiteList[Central_ObjClass]) then
if (((object:IsNPC() or object.Type == "nextbot") and (object:GetSolidFlags() == 20 and object:GetMoveType()  == 0) or (object:GetSolidFlags() == 16 and object:GetMoveType()  == 3 and !object:GetSpawnEffect()) or (CentralVehiculeSent(object)[object])) or (Central_ObjClass == "prop_dynamic" and object:GetSolidFlags() == 0)) then
continue 
end
if Central_Ent_PosXY <= Central_Distance_General * Central_Distance_Multiplicateur then
Central_Ent_Draw(true, Central_Player_Local, true, object)
else
Central_Ent_Draw(false, Central_Player_Local, true, object)
end
end
if (Central_ObjClass == "prop_vehicle_jeep" and object:IsVehicle()) then
if Central_Ent_PosXY <= Central_Distance_Vehicule * Central_Distance_Multiplicateur then
Central_Ent_Draw(true, Central_Player_Local, true, object)
else
Central_Ent_Draw(false, Central_Player_Local, true, object)
end
end
if (Central_ObjClass == "prop_physics") then 
if (object:GetSolidFlags() == 4) then continue end      
if Central_Ent_PosXY <= Central_Distance_Object * Central_Distance_Multiplicateur then
Central_Ent_Draw(false, Central_Player_Local, false, object)
else
Central_Ent_Draw(false, Central_Player_Local, true, object)
end
end	
if (Central_ObjClass == "player" and object:IsPlayer()) then
if (!IsValid(object:GetMoveParent()) and object:GetObserverTarget():IsRagdoll() and !object:GetSpawnEffect()) then 
if IsValid(object:GetActiveWeapon()) then
Central_Ent_DrawBool(object:GetActiveWeapon(), true)
end
continue
end
if (Central_Check_Admin(object)) then 
Central_Ent_DrawBool(object, true) 
else
if Central_Ent_PosXY <= Central_Distance_Joueur * Central_Distance_Multiplicateur then
Central_Ent_Draw(true, Central_Player_Local, true, object)
else
Central_Ent_Draw(false, Central_Player_Local, true, object)
end
end		
end
end
CentralTableVehiculeSent = {}
end

local Central_Distance_TimerLoad = "Central_EntOptimisation"
local function Central_EntDraw_Optimisation_Load()
if (Central__Debug) then
timer.Remove(Central_Distance_TimerLoad)
end
if timer.Exists(Central_Distance_TimerLoad) then return end
timer.Create(Central_Distance_TimerLoad, 0.3, 0, Central_EntDraw_Optimisation ) 
end
if (Central__Debug) then
Central_EntDraw_Optimisation_Load()
end
net.Receive("centralopticlient", Central_EntDraw_Optimisation_Load)
