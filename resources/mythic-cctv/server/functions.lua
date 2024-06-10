function SetupCameras()
    for k, v in pairs(Config.Cameras) do
        local key = string.format("CCTV:Camera:%s", k)
        GlobalState[key] = v
    end
    GlobalState["CCTV:Camera:Total"] = #Config.Cameras
end