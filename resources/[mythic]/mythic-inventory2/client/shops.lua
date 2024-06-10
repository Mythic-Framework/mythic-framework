Shops = {}
showingMarker = false
_isLoggedIn = false

function setupStores(shops)
	for k, v in pairs(shops) do
		if v.coords ~= nil then
			local menu = {
				icon = "sack-dollar",
				text = v.name or "Shop",
				event = "Shop:Client:OpenShop",
				data = v.id,
			}

			if v.restriction ~= nil then
				if v.restriction.job ~= nil then
					menu.jobPerms = {
						{
							job = v.restriction.job.id,
							workplace = v.restriction.job.workplace,
							grade = v.restriction.job.grade,
							permissionKey = v.restriction.job.permissionKey,
							reqDuty = true,
						}
					}
				end
			end

			PedInteraction:Add(
				"shop-" .. v.id,
				GetHashKey(v.npc),
				vector3(v.coords.x, v.coords.y, v.coords.z),
				v.coords.h,
				25.0,
				{
					menu,
				},
				v.icon or "shop"
			)
			if v.blip then
				Blips:Add(
					"inventory_shop_" .. v.id,
					v.name,
					vector3(v.coords.x, v.coords.y, v.coords.z),
					v.blip.sprite,
					v.blip.color,
					v.blip.scale
				)
			end
		end
	end
end

AddEventHandler("Shop:Client:OpenShop", function(obj, data)
	Inventory.Shop:Open(data)
end)
