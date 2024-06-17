--[[ SKILLBAR DEMO ]]
--
local scDelay = 5000
local scPass = 1
RegisterNetEvent("Minigame:Client:Skillbar", function()
	Minigame.Play:Skillbar(scDelay, 10 - scPass, {
		onSuccess = "Minigame:Client:DemoSkillbarSuccess",
		onFail = "Minigame:Client:DemoSkillbarFail",
	})
end)

AddEventHandler("Minigame:Client:DemoSkillbarSuccess", function(data)
	if scDelay <= 1000 then
		Notification:Success("Won All The Things")
		scDelay = 5000
		scPass = 1
	else
		scDelay = scDelay - 1000
		scPass = scPass + 1
		Wait(400)
		TriggerEvent("Minigame:Client:Skillbar")
	end
end)

AddEventHandler("Minigame:Client:DemoSkillbarFail", function(data)
	Notification:Error("Skill Check Failed")
	scDelay = 5000
	scPass = 1
end)

--[[ SCANNER DEMO ]]
--
local scanTimer = 50
local scanPass = 1
RegisterNetEvent("Minigame:Client:Scanner", function()
	Minigame.Play:Scanner(5, scanTimer, 5000, 20, 5 - scanPass, true, {
		onPerfect = "Minigame:Client:DemoScannerPerfect",
		onSuccess = "Minigame:Client:DemoScannerSuccess",
		onFail = "Minigame:Client:DemoScannerFail",
	})
end)

AddEventHandler("Minigame:Client:DemoScannerPerfect", function(data)
	Notification:Success("PERFECTION!")
end)

AddEventHandler("Minigame:Client:DemoScannerSuccess", function(data)
	if scanPass >= 5 then
		Notification:Success("Won All The Things")
		scanPass = 1
	else
		scanPass = scanPass + 1
		Wait(400)
		TriggerEvent("Minigame:Client:Scanner")
	end
end)

AddEventHandler("Minigame:Client:DemoScannerFail", function(data)
	Notification:Error("Scanner Failed")
	scanPass = 1
end)

--[[ SEQUENCER DEMO ]]
--
local seqPass = 1
RegisterNetEvent("Minigame:Client:Sequencer", function()
	Minigame.Play:Sequencer(5, 250, 10000 - (1000 * seqPass), 3 + seqPass, false, {
		onPerfect = "Minigame:Client:DemoSequencerPerfect",
		onSuccess = "Minigame:Client:DemoSequencerSuccess",
		onFail = "Minigame:Client:DemoSequencerFail",
	})
end)

AddEventHandler("Minigame:Client:DemoSequencerPerfect", function(data)
	Notification:Success("PERFECTION!")
end)

AddEventHandler("Minigame:Client:DemoSequencerSuccess", function(data)
	if seqPass >= 3 then
		Notification:Success("Won All The Things")
		seqPass = 1
	else
		seqPass = seqPass + 1
		Wait(1000)
		TriggerEvent("Minigame:Client:Sequencer")
	end
end)

AddEventHandler("Minigame:Client:DemoSequencerFail", function(data)
	Notification:Error("Sequencer Failed")
	seqPass = 1
end)

--[[ KEYPAD DEMO ]]
--
RegisterNetEvent("Minigame:Client:Keypad", function()
	Minigame.Play:Keypad("1234", false, false, false, {
		onSuccess = "Minigame:Client:DemoKeypadSuccess",
		onFail = "Minigame:Client:DemoKeypadFail",
	})
end)

AddEventHandler("Minigame:Client:DemoKeypadSuccess", function(data)
	Notification:Success("Won All The Things")
end)

AddEventHandler("Minigame:Client:DemoKeypadFail", function(data)
	Notification:Error("Keypad Failed")
end)

--[[ SCRAMBLER DEMO ]]
--
local f = 0
RegisterNetEvent("Minigame:Client:Scrambler", function()
	f = 0
	dothingy()
end)

function dothingy()
	Minigame.Play:Scrambler(5, 3000, 14000 + ((f or 0) * 2000), 3, 16 + (f * 4), {
		onPerfect = function()
			if f < 3 then
				f += 1
				dothingy()
			else
				TriggerClientEvent("Minigame:Client:DemoScramblerPerfect")
			end
		end,
		onSuccess = function()
			if f < 3 then
				f += 1
				dothingy()
			else
				TriggerClientEvent("Minigame:Client:DemoScramblerPerfect")
			end
		end,
		onFail = "Minigame:Client:DemoScramblerFail",
	})
end

AddEventHandler("Minigame:Client:DemoScramblerPerfect", function(data)
	Notification:Success("PERFECTION!")
end)

AddEventHandler("Minigame:Client:DemoScramblerSuccess", function(data)
	Notification:Success("Won All The Things")
end)

AddEventHandler("Minigame:Client:DemoScramblerFail", function(data)
	Notification:Error("Sequencer Failed")
end)

--[[ MEMORY DEMO ]]
--
local memPass = 1
RegisterNetEvent("Minigame:Client:Memory", function()
	Minigame.Play:Memory(5, 2000, 10000, 3 + memPass, 3 + memPass, 4 + memPass, 3, {
		onPerfect = "Minigame:Client:DemoMemoryPerfect",
		onSuccess = "Minigame:Client:DemoMemorySuccess",
		onFail = "Minigame:Client:DemoMemoryFail",
	})
end)

AddEventHandler("Minigame:Client:DemoMemoryPerfect", function(data)
	Notification:Success("PERFECTION!")
	memPass = 1
end)

AddEventHandler("Minigame:Client:DemoMemorySuccess", function(data)
	if memPass >= 4 then
		Notification:Success("Won All The Things")
		memPass = 1
	else
		memPass = memPass + 1
		Wait(400)
		TriggerEvent("Minigame:Client:Memory")
	end
end)

AddEventHandler("Minigame:Client:DemoMemoryFail", function(data)
	Notification:Error("Memory Failed")
	memPass = 1
end)

--[[ SLIDERS DEMO ]]
--
local slidersPass = 1
RegisterNetEvent("Minigame:Client:Sliders", function()
	Minigame.Play:Sliders(3, 3000, 25000, 12, 3 + slidersPass, {
		onSuccess = "Minigame:Client:DemoSlidersSuccess",
		onFail = "Minigame:Client:DemoSlidersFail",
	})
end)

AddEventHandler("Minigame:Client:DemoSlidersSuccess", function(data)
	if slidersPass >= 4 then
		Notification:Success("Won All The Things")
		slidersPass = 1
	else
		slidersPass = slidersPass + 1
		Wait(400)
		TriggerEvent("Minigame:Client:Sliders")
	end
end)

AddEventHandler("Minigame:Client:DemoSlidersFail", function(data)
	Notification:Error("Sliders Failed")
	slidersPass = 1
end)
