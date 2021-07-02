--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
local Ipr_RenderTbl = Ipr_RenderTbl or false   
local Ipr_ForceDisabled = Ipr_ForceDisabled or false
local Ipr_Frame = Ipr_Frame or nil

local function Ipr_Rendering_CalcDist(player, target, dist)
     return player:GetPos():DistToSqr(target:GetPos()) < (dist * 25000) or false
end

local function Ipr_Rendering_Object(bool, ply, val)
     if (FSpectate) and FSpectate.getSpecEnt() ~= nil or Ipr_ForceDisabled or ply:GetNoDraw() then
          val:SetNoDraw(false)
          return
     end
     if bool then
          local Ipr_Aim_Vector = ply:GetAimVector()
          local Ipr_Ent_V = val:GetPos() - ply:GetEyeTrace().StartPos
          local Ipr_Len = Ipr_Ent_V:Length()
          local Ipr_AimVec = Ipr_Aim_Vector:Dot( Ipr_Ent_V ) / Ipr_Len
          local Ipr_Pi = math.pi / 300
          local Ipr_Inf = Ipr_AimVec < Ipr_Pi

          if Ipr_Inf then
               return val:SetNoDraw(true)
          end
     else
          return val:SetNoDraw(true)
     end
     return val:SetNoDraw(false)
end
 
local function Ipr_Rendering_Ent()
     local Ipr_Sys_Npc = ents.FindByClass("npc_*")
     local Ipr_Sys_Radgoll = ents.FindByClass("class C_ClientRagdoll")
     local Ipr_Sys_SpawnedWeap = ents.FindByClass("spawned_weapon")
     local Ipr_Sys_Veh = ents.FindByClass("prop_vehicle_jeep")
     local Ipr_Sys_Ply = ents.FindByClass("player")
     local Ipr_Sys_Props = ents.FindByClass("prop_physics")

     local Ipr_LocalPlayer = LocalPlayer()
     local Ipr_GetVeh = Ipr_LocalPlayer:GetVehicle()

     if Ipr_RenderTbl.worldspawn.enable then
          for _, object in ipairs(Ipr_Sys_Npc) do
               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.worldspawn.distance) then
                    if ((object:IsNPC() or object.Type == "nextbot") and object:GetSolidFlags() == 20 and object:GetMoveType() == 0) then
                         continue
                    end
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
          for _, object in ipairs(Ipr_Sys_SpawnedWeap) do
               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.worldspawn.distance) then
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
          for _, object in ipairs(Ipr_Sys_Radgoll) do
               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.worldspawn.distance) then
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
     end
     if Ipr_RenderTbl.vehicle.enable then
          for _, object in ipairs(Ipr_Sys_Veh) do
               if (object == Ipr_GetVeh) then
                    continue
               end

               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.vehicle.distance) then
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
     end
     if Ipr_RenderTbl.player.enable then
          for _, object in ipairs(Ipr_Sys_Ply) do
               if (object == Ipr_LocalPlayer or object:GetNWBool("Admin_Sys_Status")) then
                    continue
               end

               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.player.distance) then
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
     end
     if Ipr_RenderTbl.object.enable then
          for _, object in ipairs(Ipr_Sys_Props) do
               if Ipr_Rendering_CalcDist(Ipr_LocalPlayer, object, Ipr_RenderTbl.object.distance) then
                    Ipr_Rendering_Object(true, Ipr_LocalPlayer, object)
               else
                    Ipr_Rendering_Object(false, Ipr_LocalPlayer, object)
               end
          end
     end
end

local function Ipr_Sync_Data()
     local Ipr_ReadInt = net.ReadUInt(8)
     local Ipr_ReadData = net.ReadData(Ipr_ReadInt)
     local Ipr_Decomp = util.Decompress(Ipr_ReadData, Ipr_ReadInt)

     Ipr_RenderTbl = util.JSONToTable(Ipr_Decomp)
     local Ipr_RenderTbl_Old = table.Copy(Ipr_RenderTbl)
     Ipr_ForceDisabled = true

     local Ipr_Data = false
     for _, data in pairs(Ipr_RenderTbl) do
          if data.enable then
               Ipr_Data = true
          else
               data.enable = true
          end
     end

     if timer.Exists("Ipr_Sys_ObjRender_Sync") then
          timer.Remove("Ipr_Sys_ObjRender_Sync")
     end
     if Ipr_Data then
          timer.Create("Ipr_Sys_ObjRender", 0.3, 0, Ipr_Rendering_Ent)
     end

     timer.Create("Ipr_Sys_ObjRender_Sync", 0.5, 1,function()
     Ipr_ForceDisabled = false

     if not Ipr_Data then
          if timer.Exists("Ipr_Sys_ObjRender") then
               timer.Remove("Ipr_Sys_ObjRender")
          end
     end
     Ipr_RenderTbl = Ipr_RenderTbl_Old
     end)
end

local function Ipr_ObjectRender_P()
if not Ipr_RenderTbl or IsValid(Ipr_Frame) then
     return
end

local Ipr_Tbl_Copy = table.Copy(Ipr_RenderTbl)
local Ipr_Enable, Ipr_Font = "Off", "Default"
local Ipr_Blur = Material("pp/blurscreen")
for _, data in pairs(Ipr_RenderTbl) do
     if data.enable then
          Ipr_Enable = "On"
          break
     end
end

Ipr_Frame = vgui.Create( "DFrame" )
local Ipr_Slide_A = vgui.Create( "DNumSlider", Ipr_Frame )
local Ipr_Slide_B = vgui.Create( "DNumSlider", Ipr_Frame )
local Ipr_Slide_C = vgui.Create( "DNumSlider", Ipr_Frame )
local Ipr_Slide_D = vgui.Create( "DNumSlider", Ipr_Frame )
local Ipr_Check_A = vgui.Create("DCheckBoxLabel", Ipr_Frame)
local Ipr_Check_B = vgui.Create( "DCheckBoxLabel", Ipr_Frame)
local Ipr_Check_C = vgui.Create("DCheckBoxLabel", Ipr_Frame)
local Ipr_Check_D = vgui.Create( "DCheckBoxLabel", Ipr_Frame)
local Ipr_Save_Set = vgui.Create( "DButton", Ipr_Frame )
local Ipr_Close = vgui.Create("DButton", Ipr_Frame)

Ipr_Frame:SetTitle("")
Ipr_Frame:ShowCloseButton(false)
Ipr_Frame:SetIcon("icon16/cog.png")
Ipr_Frame:SetDraggable(true)
Ipr_Frame:MakePopup()
Ipr_Frame:SetTitle("")
Ipr_Frame:SetPos(ScrW()/2-150, ScrH()/2-200)
Ipr_Frame:SetSize(0, 0)
Ipr_Frame:SizeTo(280, 430, .5, 0, 10)
Ipr_Frame.Paint = function( self, w, h )
local x, y = self:LocalToScreen(0, 0)
surface.SetDrawColor(255, 255, 255)
surface.SetMaterial(Material("pp/blurscreen"))
for i = 1, 5 do
     Ipr_Blur:SetFloat("$blur", (i / 3) * 5)
     Ipr_Blur:Recompute()
     render.UpdateScreenEffectTexture()
     surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
end
draw.RoundedBoxEx(6, 0, 0, w, h, Color(0, 0, 0, 50), true, true, true, true )

draw.RoundedBox(6, 0, 0, w, 25, Color(52, 73, 94, 200) )
draw.RoundedBox(6, 30, 60, w - 60, 80, Color(52, 73, 94, 200))

draw.DrawText(Ipr_RenderObject.Language.settings, Ipr_Font, w/2,6, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.datasend, Ipr_Font, w/2,340, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.enable, Ipr_Font, w/2,66, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.world_dist, Ipr_Font, w/2,145, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.veh_dist, Ipr_Font, w/2,195, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.player_dist, Ipr_Font, w/2,245, color_white, TEXT_ALIGN_CENTER )
draw.DrawText(Ipr_RenderObject.Language.object_dist, Ipr_Font, w/2,295, color_white, TEXT_ALIGN_CENTER )

draw.DrawText("Status : " ..Ipr_Enable, Ipr_Font, 35,28, color_white, TEXT_ALIGN_CENTER )
draw.DrawText("v3.0", Ipr_Font, w-25,415, color_white, TEXT_ALIGN_LEFT )
draw.DrawText("Inj3", Ipr_Font, 10,415, color_white, TEXT_ALIGN_LEFT )
end

Ipr_Slide_A:SetPos(-194, 160)
Ipr_Slide_A:SetSize(485, 20)	
Ipr_Slide_A:SetText( "" )	
Ipr_Slide_A:SetMinMax(20, 5000)
Ipr_Slide_A:SetValue(Ipr_RenderTbl.worldspawn.distance)
Ipr_Slide_A:SetDecimals(0)
Ipr_Slide_A.Nom = Ipr_Tbl_Copy.worldspawn
Ipr_Slide_A.OnValueChanged = function(self, val)
   self.Nom.distance = math.Round(val)
end     
 
Ipr_Slide_B:SetPos(-195, 210)
Ipr_Slide_B:SetSize(485, 20)	
Ipr_Slide_B:SetText( "" )	
Ipr_Slide_B:SetMinMax(20, 5000)
Ipr_Slide_B:SetValue(Ipr_RenderTbl.vehicle.distance)
Ipr_Slide_B:SetDecimals( 0 )
Ipr_Slide_B.Nom = Ipr_Tbl_Copy.vehicle
Ipr_Slide_B.OnValueChanged = Ipr_Slide_A.OnValueChanged

Ipr_Slide_C:SetPos(-195, 260)
Ipr_Slide_C:SetSize(485, 20)	
Ipr_Slide_C:SetText( "" )	
Ipr_Slide_C:SetMinMax(20, 5000)
Ipr_Slide_C:SetValue(Ipr_RenderTbl.player.distance)
Ipr_Slide_C:SetDecimals( 0 )
Ipr_Slide_C.Nom = Ipr_Tbl_Copy.player
Ipr_Slide_C.OnValueChanged = Ipr_Slide_A.OnValueChanged

Ipr_Slide_D:SetPos(-195, 310)
Ipr_Slide_D:SetSize(485, 20)	
Ipr_Slide_D:SetText( "" )	
Ipr_Slide_D:SetMinMax(20, 5000) 
Ipr_Slide_D:SetValue(Ipr_RenderTbl.object.distance)
Ipr_Slide_D:SetDecimals( 0 )
Ipr_Slide_D.Nom = Ipr_Tbl_Copy.object
Ipr_Slide_D.OnValueChanged = Ipr_Slide_A.OnValueChanged

Ipr_Check_A:SetPos(65, 85)	
Ipr_Check_A:SetFont(Ipr_Font)
Ipr_Check_A:SetText(Ipr_RenderObject.Language.world)		
Ipr_Check_A:SetTooltip(Ipr_RenderObject.Language.weapandmore)
Ipr_Check_A:SetValue(Ipr_RenderTbl.worldspawn.enable and 1 or 0)
Ipr_Check_A:SetTextColor(color_white)
Ipr_Check_A.Nom = Ipr_Tbl_Copy.worldspawn
Ipr_Check_A.OnChange = function(self, val)
local Ipr_Bool_OnChange = true
if not self:GetChecked() then
     Ipr_Bool_OnChange = false
end
self.Nom.enable = Ipr_Bool_OnChange
end
Ipr_Check_A:SizeToContents()
 
Ipr_Check_B:SetPos(65, 115)	
Ipr_Check_B:SetFont( Ipr_Font )
Ipr_Check_B:SetText( Ipr_RenderObject.Language.veh )		
Ipr_Check_B:SetTooltip( Ipr_RenderObject.Language.veh)
Ipr_Check_B:SetValue(Ipr_RenderTbl.vehicle.enable and 1 or 0)
Ipr_Check_B:SetTextColor( color_white )
Ipr_Check_B.Nom = Ipr_Tbl_Copy.vehicle
Ipr_Check_B.OnChange = Ipr_Check_A.OnChange
Ipr_Check_B:SizeToContents()	

Ipr_Check_C:SetPos(160, 85)	
Ipr_Check_C:SetFont( Ipr_Font )
Ipr_Check_C:SetText( Ipr_RenderObject.Language.ply )		
Ipr_Check_C:SetTooltip( Ipr_RenderObject.Language.ply )
Ipr_Check_C:SetValue(Ipr_RenderTbl.player.enable and 1 or 0)
Ipr_Check_C:SetTextColor( color_white )
Ipr_Check_C.Nom = Ipr_Tbl_Copy.player
Ipr_Check_C.OnChange = Ipr_Check_A.OnChange
Ipr_Check_C:SizeToContents()	
 
Ipr_Check_D:SetPos(160, 115)	
Ipr_Check_D:SetFont( Ipr_Font )
Ipr_Check_D:SetText( Ipr_RenderObject.Language.obj )		
Ipr_Check_D:SetTooltip( Ipr_RenderObject.Language.obj )
Ipr_Check_D:SetValue(Ipr_RenderTbl.object.enable and 1 or 0)
Ipr_Check_D:SetTextColor( color_white )
Ipr_Check_D.Nom = Ipr_Tbl_Copy.object
Ipr_Check_D.OnChange = Ipr_Check_A.OnChange
Ipr_Check_D:SizeToContents()	
 
Ipr_Save_Set:SetPos(70, 385)
Ipr_Save_Set:SetSize(145, 23) 
Ipr_Save_Set:SetText( "" )
Ipr_Save_Set:SetImage( "icon16/bullet_wrench.png" )	
function Ipr_Save_Set:Paint( w, h )
     draw.RoundedBox( 6, 0, 0, w, h, Color(52, 73, 94, 200) )
     if self:IsHovered() then
          draw.RoundedBox( 6, 0, 0, w, h,  Color(0, 0, 0, 70))
     end
     draw.DrawText( Ipr_RenderObject.Language.save_settings, Ipr_Font, w/2+7,5, color_white, TEXT_ALIGN_CENTER )
end
Ipr_Save_Set.DoClick = function() 
net.Start("Ipr_ObjectRender_Data")
net.WriteTable(Ipr_Tbl_Copy)
net.SendToServer()  

Ipr_Frame:Remove()
end
 
Ipr_Close:SetPos(95, 28) 
Ipr_Close:SetSize(90, 23)
Ipr_Close:SetText( "" ) 
Ipr_Close:SetImage( "icon16/cross.png" )
function Ipr_Close:Paint( w, h )
     draw.RoundedBox( 6, 0, 0, w, h, Color(52, 73, 94, 200) )
     if self:IsHovered() then
          draw.RoundedBox( 6, 0, 0, w, h,  Color(0, 0, 0, 70))
     end
     draw.DrawText( Ipr_RenderObject.Language.close_, Ipr_Font, w/2+6,5, color_white, TEXT_ALIGN_CENTER )
end
Ipr_Close.DoClick = function()
	 Ipr_Frame:Remove()
end
end

net.Receive("Ipr_ObjectRender_Data", Ipr_Sync_Data)
net.Receive("Ipr_ObjectRender_P", Ipr_ObjectRender_P)
hook.Remove("PostDrawEffects", "RenderWidgets")
