function LoadPropModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
    end
end