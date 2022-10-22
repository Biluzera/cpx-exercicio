-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINTDEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
function PrintDebug(message, err)
   if Config["debug"] then
       if err then
           error(message)
       else
           print("\n^3[" .. ResourceName .. "]^0 " .. message)
       end
   end
end
--------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
--------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.55, 0.55)
        SetTextColour(255,255,255,255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 150)
        SetTextDropshadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawTxt(text,x,y)
	SetTextFont(4)
	SetTextScale(0.4,0.4)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end