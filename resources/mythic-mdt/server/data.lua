local _ran = false

function DefaultData()
	if _ran then
		return
	end
	local Default = exports["mythic-base"]:FetchComponent("Default")
end
