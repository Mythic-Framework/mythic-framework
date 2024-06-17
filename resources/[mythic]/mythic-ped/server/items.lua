local _maskItems = {
	"mask",
}

local _hatItems = {
	"hat",
	"sombrero",
}

local _accessoryItems = {
	"accessory",
}

function RegisterItemUses()
	for k, v in ipairs(_maskItems) do
		Inventory.Items:RegisterUse(v, "Ped", function(source, item)
			if not Player(source).state.isCuffed then
				local char = Fetch:Source(source):GetData("Character")
				if item.MetaData.mask then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Wait(300)
					local ped = char:GetData("Ped")
					if ped.customization.components.mask.drawableId ~= 0 then
						Ped.Mask:Unequip(source)
					end
					Ped.Mask:Equip(source, item.MetaData.mask)
					Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
				end
			end
		end)
	end

	for k, v in ipairs(_hatItems) do
		Inventory.Items:RegisterUse(v, "Ped", function(source, item)
			if not Player(source).state.isCuffed then
				local char = Fetch:Source(source):GetData("Character")
				if item.MetaData.hat then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Wait(300)
					local ped = char:GetData("Ped")
					if not ped.customization.props.hat.disabled then
						Ped.Hat:Unequip(source)
					end
					Ped.Hat:Equip(source, item.MetaData.hat)
					Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
				end
			end
		end)
	end

	for k, v in ipairs(_accessoryItems) do
		Inventory.Items:RegisterUse(v, "Ped", function(source, item)
			if not Player(source).state.isCuffed then
				local char = Fetch:Source(source):GetData("Character")
				if item.MetaData.accessory then
					TriggerClientEvent("Ped:Client:HatGlassAnim", source)
					Wait(300)
					local ped = char:GetData("Ped")
					if (ped.customization.components.accessory?.drawableId or 0) ~= 0 then
						Ped.Necklace:Unequip(source)
					end

					Ped.Necklace:Equip(
						source,
						item.MetaData.accessory[char:GetData("Gender")]
							or item.MetaData.accessory[tostring(char:GetData("Gender"))]
							or item.MetaData.accessory
					)
					Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
				end
			end
		end)
	end
end
