local _uwuPrizes = {
    {100, "uwu_prize_b8"},
    {1400, "uwu_prize_b2"},
    {1, "uwu_prize_b10"},
    {1300, "uwu_prize_b3"},
    {800, "uwu_prize_b5"},
    {700, "uwu_prize_b6"},
    {10, "uwu_prize_b9"},
    {1000, "uwu_prize_b4"},
    {1600, "uwu_prize_b1"},
    {200, "uwu_prize_b7"},
}

AddEventHandler("Businesses:Server:Startup", function()
    Inventory.Items:RegisterUse("uwu_prize_box", "Businesses", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		if Inventory.Items:Has(char:GetData("SID"), 1, "uwu_prize_box", 1) then
            if Inventory.Items:RemoveSlot(item.Owner, "uwu_prize_box", 1, item.Slot, 1) then
                local prize = Utils:WeightedRandom(_uwuPrizes)
                Inventory:AddItem(char:GetData("SID"), prize, 1, {}, 1)
            end
		end
	end)
end)