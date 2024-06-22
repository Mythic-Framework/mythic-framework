AddEventHandler('Labor:Client:Setup', function()
	Blips:Add('exporter', "Goods Exporter", vector3(-769.529, -2638.597, 12.945), 272, 4, 0.65)
	PedInteraction:Add("LaborExporter", `a_m_m_farmer_01`, vector3(-769.529, -2638.597, 12.945), 63.569, 25.0, {
		{
			icon = "hand-holding-dollar",
			text = "Export Items",
			event = "Labor:Client:Export:GetMenu",
		},
    }, 'sack-dollar', 'WORLD_HUMAN_CLIPBOARD')
end)

AddEventHandler("Labor:Client:Export:GetMenu", function()
    ListMenu:Show(GlobalState["LaborExporter"])
end)

AddEventHandler("Labor:Client:Export:Sell", function(data)
    local itemData = Inventory.Items:GetData(data.item)
    Confirm:Show(
		string.format("Mass Export %s at $%s/unit?", itemData.label, data.price),
		{
			yes = "Labor:Client:Export:Sell:Yes",
			no = "Labor:Client:Export:Sell:No",
		},
		string.format( "Doing this will sell all in your inventory for $%s/unit, are you sure you want to continue?", data.price ),
		data
	)
end)

AddEventHandler("Labor:Client:Export:Sell:Yes", function(data)
    Callbacks:ServerCallback("Labor:Exporter:Sell", data)
end)