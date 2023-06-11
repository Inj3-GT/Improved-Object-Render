--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
local function Ipr_RendDist(p, t, d)
    return p:GetPos():DistToSqr(t:GetPos()) < (d * 25000) or false
end

local function Ipr_RendDraw(v, b)
    if (b) then
        v:AddEffects(EF_NODRAW)
        return
    end
    v:RemoveEffects(EF_NODRAW)
end

local Ipr_Fds = nil
local function Ipr_RendObj(b, p, v)
    if (FSpectate) and (FSpectate.getSpecEnt() ~= nil) or (Ipr_Fds) then
        return Ipr_RendDraw(v, false)
    end
    if (b) then
        local Ipr_Aim_Vector = p:GetAimVector()
        local Ipr_Ent_V = v:GetPos() - p:GetEyeTrace().StartPos
        local Ipr_Len = Ipr_Ent_V:Length()
        local Ipr_AimVec = Ipr_Aim_Vector:Dot(Ipr_Ent_V) / Ipr_Len
        local Ipr_Pi = math.pi / 300
        local Ipr_Inf = Ipr_AimVec < Ipr_Pi

        if (Ipr_Inf) then
            return Ipr_RendDraw(v, true)
        end
    else
        return Ipr_RendDraw(v, true)
    end

    return Ipr_RendDraw(v, false)
end

local function Ipr_FindObj(t, v)
    if (t == 1) then
        if (string.sub(tostring(v), 1, 6) == "Player") then
            return (v ~= LocalPlayer()) and true
        end
    elseif (t == 2) then
        if (string.sub(tostring(v), 1, 6) == "Entity") then
            return true
        end
    else
        local Ipr_Ow = IsValid(v:GetOwner()) and v:GetOwner()
        if v:IsWeapon() and (((Ipr_Ow) and (Ipr_Ow:GetActiveWeapon() == v) and (Ipr_Ow ~= LocalPlayer())) or Ipr_FindObj(2, v)) then
          return true
        end
    end

    return false
end

local function Ipr_TblObj()
    local Ipr_UpdObj, Ipr_Ents = {}, ents.GetAll()

    for _, e in ipairs(Ipr_Ents) do
        local Ipr_Cl, Ipr_Cx = e:GetClass(), (Ipr_FindObj(nil, e) and "ipr_world") or (Ipr_FindObj(1, e) and "ipr_player") or nil

        for m, c in pairs(Ipr_RenderObject.EntRend) do
            if not Ipr_Cx then
                local Ipr_Mt = string.sub(Ipr_Cl, 1, #m)
                if (Ipr_Mt == "gmod_") and (not e:GetSpawnEffect() or not Ipr_FindObj(2, e)) then
                    break
                end
                if not string.match(Ipr_Mt, m) then
                    continue
                end
            else
                c = Ipr_Cx
            end
            if not Ipr_UpdObj[c] then
                Ipr_UpdObj[c] = {}
            end

            Ipr_UpdObj[c][#Ipr_UpdObj[c] + 1] = e
            break
        end
    end

    return Ipr_UpdObj
end

local function Ipr_RendEnt()
    local Ipr_Lp = LocalPlayer()
    local Ipr_UpdTbl = Ipr_TblObj()

    if (Ipr_RenderObject.Render.worldspawn.enable) then
        local Ipr_SpWorld = Ipr_UpdTbl["ipr_world"]
        if (Ipr_SpWorld) then
            for _, i in ipairs(Ipr_SpWorld) do
                Ipr_RendObj(Ipr_RendDist(Ipr_Lp, i, Ipr_RenderObject.Render.worldspawn.distance), Ipr_Lp, i)
            end
        end
    end
    if (Ipr_RenderObject.Render.vehicle.enable) then
        local Ipr_SpVeh = Ipr_UpdTbl["ipr_vehicle"]
        if (Ipr_SpVeh) then
            local Ipr_GetVeh = Ipr_Lp:GetVehicle()
            for _, i in ipairs(Ipr_SpVeh) do
                if (i == Ipr_GetVeh) then
                    continue
                end
                Ipr_RendObj(Ipr_RendDist(Ipr_Lp, i, Ipr_RenderObject.Render.vehicle.distance), Ipr_Lp, i)
            end
        end
    end
    if (Ipr_RenderObject.Render.player.enable) then
        local Ipr_SpPlayer = Ipr_UpdTbl["ipr_player"]
        if (Ipr_SpPlayer) then
            for _, i in ipairs(Ipr_SpPlayer) do
                if i:GetNWBool("Admin_Sys_Status") then
                    continue
                end
                Ipr_RendObj(Ipr_RendDist(Ipr_Lp, i, Ipr_RenderObject.Render.player.distance), Ipr_Lp, i)
            end
        end
    end
    if (Ipr_RenderObject.Render.object.enable) then
        local Ipr_SpPropP = Ipr_UpdTbl["ipr_prop"]
        if (Ipr_SpPropP) then
            for _, i in ipairs(Ipr_SpPropP) do
                Ipr_RendObj(Ipr_RendDist(Ipr_Lp, i, Ipr_RenderObject.Render.object.distance), Ipr_Lp, i)
            end
        end
    end
end

local Ipr_EntR = 0.15
local function Ipr_Sync_Data()
    Ipr_RenderObject.Render = net.ReadTable()
    local Ipr_RenderTbl_Old = table.Copy(Ipr_RenderObject.Render)

    local Ipr_Dt = false
    for _, data in pairs(Ipr_RenderObject.Render) do
        if (data.enable) then Ipr_Dt = true else data.enable = true end
    end
    Ipr_Fds = true

    if timer.Exists("Ipr_Sys_ObjRender_Sync") then
        timer.Remove("Ipr_Sys_ObjRender_Sync")
    end
    if (Ipr_Dt) then
        timer.Create("Ipr_Sys_ObjRender", Ipr_EntR, 0, Ipr_RendEnt)
    end

    timer.Create("Ipr_Sys_ObjRender_Sync", Ipr_EntR + 0.4, 1,function()
        if not Ipr_Dt then
            if timer.Exists("Ipr_Sys_ObjRender") then
                timer.Remove("Ipr_Sys_ObjRender")
            end
        end

        Ipr_Fds = false
        Ipr_RenderObject.Render = Ipr_RenderTbl_Old
    end)
end

local Ipr_Frame, Ipr_Blur = nil, Material("pp/blurscreen")
local function Ipr_ObjectRender_P()
    if not Ipr_RenderObject.Render.worldspawn then
        return print("Data for are waiting to be received")
    end
    if IsValid(Ipr_Frame) then
        return
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
    local Ipr_Font, ipr_ = "Default", false
    for _, data in pairs(Ipr_RenderObject.Render) do
        if (data.enable) then
            ipr_ = true

            break
        end
    end
    Ipr_Frame.Paint = function(self, w, h)
        local x, y = self:LocalToScreen(0, 0)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(Ipr_Blur)
        for i = 1, 3 do
            Ipr_Blur:SetFloat("$blur", (i / 3) * 5)
            Ipr_Blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
        draw.RoundedBoxEx(6, 0, 0, w, h, Color(0, 0, 0, 50), true, true, true, true )

        draw.RoundedBox(6, 0, 0, w, 25, Color(52, 73, 94, 200) )
        draw.RoundedBox(6, 30, 60, w - 60, 80, Color(52, 73, 94, 200))

        draw.DrawText(Ipr_RenderObject.Language.settings, Ipr_Font, w/2,6, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.datasend, Ipr_Font, w/2,340, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.enable, Ipr_Font, w/2,66, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.world_dist, Ipr_Font, w/2,145, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.veh_dist, Ipr_Font, w/2,195, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.player_dist, Ipr_Font, w/2,245, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Language.object_dist, Ipr_Font, w/2,295, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText(Ipr_RenderObject.Version, Ipr_Font, w-25,415, color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("Status : " ..((ipr_) and "ON" or "OFF"), Ipr_Font, 35,28, color_white, TEXT_ALIGN_CENTER)
        draw.DrawText("Inj3", Ipr_Font, 10,415, color_white, TEXT_ALIGN_LEFT)
    end

    local Ipr_Tbl_Copy = table.Copy(Ipr_RenderObject.Render)
    Ipr_Slide_A:SetPos(-194, 160)
    Ipr_Slide_A:SetSize(485, 20)
    Ipr_Slide_A:SetText( "" )
    Ipr_Slide_A:SetMinMax(20, 5000)
    Ipr_Slide_A:SetValue(Ipr_RenderObject.Render.worldspawn.distance)
    Ipr_Slide_A:SetDecimals(0)
    Ipr_Slide_A.Nom = Ipr_Tbl_Copy.worldspawn
    Ipr_Slide_A.OnValueChanged = function(self, val)
        self.Nom.distance = math.Round(val)
    end

    Ipr_Slide_B:SetPos(-195, 210)
    Ipr_Slide_B:SetSize(485, 20)
    Ipr_Slide_B:SetText( "" )
    Ipr_Slide_B:SetMinMax(20, 5000)
    Ipr_Slide_B:SetValue(Ipr_RenderObject.Render.vehicle.distance)
    Ipr_Slide_B:SetDecimals( 0 )
    Ipr_Slide_B.Nom = Ipr_Tbl_Copy.vehicle
    Ipr_Slide_B.OnValueChanged = Ipr_Slide_A.OnValueChanged

    Ipr_Slide_C:SetPos(-195, 260)
    Ipr_Slide_C:SetSize(485, 20)
    Ipr_Slide_C:SetText( "" )
    Ipr_Slide_C:SetMinMax(20, 5000)
    Ipr_Slide_C:SetValue(Ipr_RenderObject.Render.player.distance)
    Ipr_Slide_C:SetDecimals( 0 )
    Ipr_Slide_C.Nom = Ipr_Tbl_Copy.player
    Ipr_Slide_C.OnValueChanged = Ipr_Slide_A.OnValueChanged

    Ipr_Slide_D:SetPos(-195, 310)
    Ipr_Slide_D:SetSize(485, 20)
    Ipr_Slide_D:SetText( "" )
    Ipr_Slide_D:SetMinMax(20, 5000)
    Ipr_Slide_D:SetValue(Ipr_RenderObject.Render.object.distance)
    Ipr_Slide_D:SetDecimals( 0 )
    Ipr_Slide_D.Nom = Ipr_Tbl_Copy.object
    Ipr_Slide_D.OnValueChanged = Ipr_Slide_A.OnValueChanged

    Ipr_Check_A:SetPos(65, 85)
    Ipr_Check_A:SetFont(Ipr_Font)
    Ipr_Check_A:SetText(Ipr_RenderObject.Language.world)
    Ipr_Check_A:SetTooltip(Ipr_RenderObject.Language.weapandmore)
    Ipr_Check_A:SetValue(Ipr_RenderObject.Render.worldspawn.enable and 1 or 0)
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
    Ipr_Check_B:SetValue(Ipr_RenderObject.Render.vehicle.enable and 1 or 0)
    Ipr_Check_B:SetTextColor( color_white )
    Ipr_Check_B.Nom = Ipr_Tbl_Copy.vehicle
    Ipr_Check_B.OnChange = Ipr_Check_A.OnChange
    Ipr_Check_B:SizeToContents()

    Ipr_Check_C:SetPos(160, 85)
    Ipr_Check_C:SetFont( Ipr_Font )
    Ipr_Check_C:SetText( Ipr_RenderObject.Language.ply )
    Ipr_Check_C:SetTooltip( Ipr_RenderObject.Language.ply )
    Ipr_Check_C:SetValue(Ipr_RenderObject.Render.player.enable and 1 or 0)
    Ipr_Check_C:SetTextColor( color_white )
    Ipr_Check_C.Nom = Ipr_Tbl_Copy.player
    Ipr_Check_C.OnChange = Ipr_Check_A.OnChange
    Ipr_Check_C:SizeToContents()

    Ipr_Check_D:SetPos(160, 115)
    Ipr_Check_D:SetFont( Ipr_Font )
    Ipr_Check_D:SetText( Ipr_RenderObject.Language.obj )
    Ipr_Check_D:SetTooltip( Ipr_RenderObject.Language.obj )
    Ipr_Check_D:SetValue(Ipr_RenderObject.Render.object.enable and 1 or 0)
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
