local _sellers = {
	{
		coords = vector3(-309.908, 6185.945, 30.560),
		heading = 53.751,
		model = `a_m_y_bevhills_01`,
	},
}

AddEventHandler('Labor:Client:Setup', function()
	for k, v in ipairs(_sellers) do
		PedInteraction:Add(string.format('PawnSeller%s', k), v.model, v.coords, v.heading, 25.0, {
			{
				icon = 'ring',
				text = 'Sell Jewelry',
				event = 'Pawn:Client:Sell',
                data = 'jewelry',
			},
            {
				icon = 'sack-dollar',
				text = 'Sell Valuable Goods',
				event = 'Pawn:Client:Sell',
                data = 'valuegoods',
			},
            {
				icon = 'tv',
				text = 'Sell Electronics',
				event = 'Pawn:Client:Sell',
                data = 'electronics',
			},
            {
				icon = 'kitchen-set',
				text = 'Sell Appliance',
				event = 'Pawn:Client:Sell',
                data = 'appliance',
			},
			{
				icon = 'baseball-bat-ball',
				text = 'Sell Sporting Equipment',
				event = 'Pawn:Client:Sell',
                data = 'golf',
			},
			{
				icon = 'palette',
				text = 'Sell Artwork',
				event = 'Pawn:Client:Sell',
                data = 'art',
			},
			{
				icon = 'bars-progress',
				text = 'Sell Precious Metals',
				event = 'Pawn:Client:Sell',
                data = 'raremetals',
			},
            -- {
			-- 	icon = 'box',
			-- 	text = 'Buy Items',
			-- 	event = 'Pawn:Client:SellJewelry',
			-- 	rep = { id = 'Pawn', level = 3 },
			-- },
		}, 'sack-dollar')
	end
end)

AddEventHandler('Pawn:Client:Sell', function(e, data)
    Callbacks:ServerCallback("Pawn:Sell", data)
end)