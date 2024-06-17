CreateThread(function()
	while GlobalState["MeleeConfig"] == nil do
		Wait(1)
	end
	for k, v in pairs(GlobalState["MeleeConfig"]) do
		SetWeaponDamageModifier(k, v + 0.0)
	end
end)
