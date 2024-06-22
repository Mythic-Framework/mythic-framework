COMPONENTS.Scaleform = {
	_required = { 'Request', 'RequestHud' },
    _name = 'base',
}

--[[ Scaleform Wrapper By Illusivee - https://github.com/Illusivee/scaleform-wrapper ]]

local scaleform = {}
scaleform.__index = scaleform

function COMPONENTS.Scaleform.Request(self, Name)
	local ScaleformHandle = RequestScaleformMovie(Name)
	local StartTime = GetGameTimer()
	while not HasScaleformMovieLoaded(ScaleformHandle) do Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print('Failed Requesting Scaleform ' .. Name)
			return
		end 
	end
	local data = {name = Name, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function COMPONENTS.Scaleform.RequestHud(self, id)
	local ScaleformHandle = RequestHudScaleform(id)
	local StartTime = GetGameTimer()
	while not HasHudScaleformLoaded(ScaleformHandle) do 
		Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print('Failed Loading Scaleform ' .. id)
			return
		end
	end
	local data = {Name = id, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function scaleform:CallScaleFunction(scType, theFunction, ...)
	if scType == 'hud' then
		BeginScaleformMovieMethodHudComponent(self.handle, theFunction)
	elseif scType == 'normal' then
		BeginScaleformMovieMethod(self.handle, theFunction)
	end
    local arg = {...}
    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == 'boolean' then
                PushScaleformMovieMethodParameterBool(arg[i])
			elseif sType == 'number' then
				if math.type(arg[i]) == 'integer' then
					PushScaleformMovieMethodParameterInt(arg[i])
				else
					PushScaleformMovieMethodParameterFloat(arg[i])
				end
            elseif sType == 'string' then
                PushScaleformMovieMethodParameterString(arg[i])
            else
                PushScaleformMovieMethodParameterInt()
            end
		end
	end
	return EndScaleformMovieMethod()
end

function scaleform:CallHudFunction(theFunction, ...)
    self:CallScaleFunction('hud', theFunction, ...)
end

function scaleform:CallFunction(theFunction, ...)
    self:CallScaleFunction('normal', theFunction, ...)
end

function scaleform:Draw2D()
	DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, 255)
end

function scaleform:Draw2DNormal(x, y, width, height)
	DrawScaleformMovie(self.handle, x, y, width, height, 255, 255, 255, 255)
end

function scaleform:Draw2DScreenSpace(locx, locy, sizex, sizey)
	local Width, Height = GetScreenResolution()
	local x = locy / Width
	local y = locx / Height
	local width = sizex / Width
	local height = sizey / Height
	DrawScaleformMovie(self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255)
end

function scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3dNonAdditive(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3d(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Dispose()
	SetScaleformMovieAsNoLongerNeeded(self.handle)
	self = nil
end

function scaleform:IsValid()
	return self and true or false
end