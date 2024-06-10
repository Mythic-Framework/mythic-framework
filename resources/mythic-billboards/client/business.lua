local linkPromise
function GetNewTVLink(id)
    local width = 512
    local height = 512
    if id and _billboardConfig[id] then
        width = _billboardConfig[id].width
        height = _billboardConfig[id].height
    end

    linkPromise = promise.new()
    Input:Show("TVs", "URL - Imgur Only (i.imgur.com/example.png)", {
		{
			id = "name",
			type = "text",
			options = {
                helperText = string.format("Leave Blank to Reset - Resolution: %s x %s", width, height),
				inputProps = {},
			},
		},
	}, "Billboards:Client:RecieveTVLinkInput", {})

    return Citizen.Await(linkPromise)
end

AddEventHandler("Billboards:Client:RecieveTVLinkInput", function(values)
    if linkPromise then
        linkPromise:resolve(values?.name)
        linkPromise = nil
    end
end)

AddEventHandler("Billboards:Client:SetLink", function(e, data)
    local tvLink = GetNewTVLink(data.id)
    Callbacks:ServerCallback("Billboards:UpdateURL", {
        id = data.id,
        link = tvLink
    }, function(success, invalidUrl)
        if success then
            Notification:Success("Updated Link!", 5000)
        else
            if invalidUrl then
                Notification:Error("Invalid URL - Imgur Links Only", 5000)
            else
                Notification:Error("Error", 5000)
            end
        end
    end)
end)