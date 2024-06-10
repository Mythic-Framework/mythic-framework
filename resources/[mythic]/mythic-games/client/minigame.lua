game_action = {
	playableWhileDead = false,
	disarm = true,
	controlDisables = {
		disableMovement = false,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	},
	animation = {
		-- animDict = nil,
		-- anim = nil,
		-- flags = 0,
		-- task = nil,
	},
	prop = {
		model = nil,
		bone = nil,
		coords = { x = 0.0, y = 0.0, z = 0.0 },
		rotation = { x = 0.0, y = 0.0, z = 0.0 },
	},
	propTwo = {
		model = nil,
		bone = nil,
		coords = { x = 0.0, y = 0.0, z = 0.0 },
		rotation = { x = 0.0, y = 0.0, z = 0.0 },
	},
}

local isPlayingGame = false
local disableMouse = false
local wasCancelled = false
local wasFinished = false
local isAnim = false
local isProp = false
local isPropTwo = false
local prop_net = nil
local propTwo_net = nil
local _runGameThread = false
local _playing = nil

AddEventHandler("minigame:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Hud = exports["mythic-base"]:FetchComponent("Hud")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Minigame = exports["mythic-base"]:FetchComponent("Minigame")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
	Jail = exports["mythic-base"]:FetchComponent("Jail")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Admin = exports["mythic-base"]:FetchComponent("Admin")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("minigame", {
		"Hud",
		"Callbacks",
		"Action",
		"Progress",
		"Keybinds",
		"ListMenu",
		"Notification",
		"Minigame",
		"Interaction",
		"Utils",
		"Phone",
		"Inventory",
		"Weapons",
		"Jail",
		"Animations",
		"Admin",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
	end)
end)

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function _disableInput(ped, disables)
	if disables.disableMouse then
		DisableControlAction(0, 1, true) -- LookLeftRight
		DisableControlAction(0, 2, true) -- LookUpDown
		DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
	end

	if disables.disableMovement then
		DisableControlAction(0, 22, true) -- INPUT_JUMP
		DisableControlAction(0, 30, true) -- disable left/right
		DisableControlAction(0, 31, true) -- disable forward/back
		DisableControlAction(0, 36, true) -- INPUT_DUCK
		DisableControlAction(0, 21, true) -- disable sprint
		DisableControlAction(0, 44, true) -- disable cover
	end

	if disables.disableCarMovement then
		DisableControlAction(0, 63, true) -- veh turn left
		DisableControlAction(0, 64, true) -- veh turn right
		DisableControlAction(0, 71, true) -- veh forward
		DisableControlAction(0, 72, true) -- veh backwards
		DisableControlAction(0, 75, true) -- disable exit vehicle
	end

	if disables.disableCombat then
		DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
		DisableControlAction(0, 24, true) -- disable attack
		DisableControlAction(0, 25, true) -- disable aim
		DisableControlAction(1, 37, true) -- disable weapon select
		DisableControlAction(0, 47, true) -- disable weapon
		DisableControlAction(0, 58, true) -- disable weapon
		DisableControlAction(0, 140, true) -- disable melee
		DisableControlAction(0, 141, true) -- disable melee
		DisableControlAction(0, 142, true) -- disable melee
		DisableControlAction(0, 143, true) -- disable melee
		DisableControlAction(0, 263, true) -- disable melee
		DisableControlAction(0, 264, true) -- disable melee
		DisableControlAction(0, 257, true) -- disable melee
	end
end

function normalizeAction(passed)
	local c = deepcopy(game_action)
	for k, v in pairs(passed) do
		c[k] = v
	end
	return c
end

local merge = function(a, b)
	if not a and not b then
		return {}
	elseif type(a) == "string" then
		return a
	elseif not a then
		return b
	elseif not b then
		return a
	end

	local c = {}
	for k, v in pairs(a) do
		c[k] = v
	end
	for k, v in pairs(b) do
		c[k] = v
	end
	return c
end

--[[
	GLOBAL PARAMS
	events: Array of events or functions that will be called based on minigame events
		- onPerfect = Called if whatever games perfection (if there is any) criteria is met
		- onSuccess = Called if whatever games success (but not perfect, or if no perfection event is given) criteria is met
		- onfail = called if minigame timesout or fail criteria is met
]]
MINIGAME = {
	_required = {
		"Play",
		"Cancel",
	},
	Play = {
		--[[
			Timer: Duration of progress bar
			Difficulty: What % (out of 100) the size of the highlighted zone is

			Criteria:
				= Perfection: NONE
				- Success: Key Pressed Within Window
				- Fail: Timeout or key pressed when progress bar not in highlighted area
		]]
		Skillbar = function(self, timer, difficulty, events, action, data)
			local params = {
				type = "skillbar",
				timer = timer,
				difficulty = difficulty,
				events = events,
				data = data,
				needsMouse = false,
			}
			_playing = params

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = false,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Rate: How much the indicator moves each tick, higher is faster. 0.1 = super slow, 10 = super fast
			Difficulty: What % (out of 100) the size of the highlighted zone is

			Criteria:
				= Perfection: NONE
				- Success: Key Pressed Within Window
				- Fail: Timeout or key pressed when progress bar not in highlighted area
		]]
		RoundSkillbar = function(self, rate, difficulty, events, action, data)
			if difficulty < 2 then
				difficulty = 2
			end

			local params = {
				type = "round",
				rate = rate,
				difficulty = difficulty,
				randomKey = true,
				events = events,
				data = data,
				needsMouse = false,
			}
			_playing = params

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = false,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Timer: Time between changes of current (green) bar
			Limit: Total time allowed before game timesout
			Total: How many bars there are in total
			Difficulty: How many bars on each side of the middle bar will be highlighted
			Random Key (Bool): If game uses random key, if false will always use E

			Criteria:
				= Perfection: Singular middle bar is active when key pressed
				- Success: Any highlighted bar is active when key pressed
				- Fail: Timeout or key pressed when no highlighted bar is current
		]]
		Scanner = function(self, countdown, timer, limit, total, difficulty, randomKey, events, action, data)
			local params = {
				type = "scanner",
				countdown = countdown,
				timer = timer,
				limit = limit,
				total = total,
				difficulty = difficulty,
				randomKey = randomKey,
				events = events,
				data = data,
				needsMouse = false,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Flash: How long each key will flash for preview (Total preview time = this * 12)
			Timer: Total time allowed before game timesout
			Total: How many bars there are in total
			Difficulty: Length of the sequence
			Is Masked (Bool): If the output is masked or visible

			Criteria:
				= Perfection: Sequence completed & correct in under 25% the alotted time
				- Success: Sequence entered is correct
				- Fail: Timeout or sequence is incorrect
		]]
		Sequencer = function(self, countdown, flash, timer, difficulty, isMasked, events, action, data)
			local params = {
				type = "sequencer",
				countdown = countdown,
				timer = flash,
				limit = timer,
				difficulty = difficulty,
				mask = isMasked,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Code: The code that is expected (In string, no spaces)
			Is Masked (Bool): If the output is masked or visible

			Criteria:
				= Perfection: NONE
				- Success: Code entered correctly
				- Fail: COde entered incorrectly
		]]
		Keypad = function(self, code, countdown, timer, isMasked, events, action, data)
			local params = {
				type = "keypad",
				countdown = countdown,
				limit = timer,
				difficulty = difficulty,
				total = code,
				mask = isMasked,
				events = events,
				data = merge(data or {}, { code = code }),
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Change: Time, in MS, before the sequence of keys is changed
			Timer: Total time allowed before game timesout
			Strikes: Amount of times an incorrect key can be pressed before game fails
			Numbers: Total amount of keys to have, should be multiples of 4

			Criteria:
				= Perfection: All numbers activated without gaining a strike
				- Success: All numbers activated
				- Fail: Timeout or strike count exceeded
		]]
		Scrambler = function(self, countdown, change, timer, strikes, numbers, events, action, data)
			local params = {
				type = "scrambler",
				countdown = countdown,
				timer = change,
				limit = timer,
				total = strikes,
				difficulty = numbers,
				mask = isMasked,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Preview: Time, in MS, activated cells are highlighted before game is activated
			Timer: Total time allowed before game timesout
			Columns: Number of columns
			Rows: Number of rows
			Num Active: Total number of activate cells
			Strikes: Total amount of wrong cells that can be activated before considered a fail

			Criteria:
				= Perfection: All activated cells clicked without any wrong ones
				- Success:All activated cells clicked
				- Fail: Timeout, incorrect cells exceed strike count, not all active cells clicked
		]]
		Memory = function(self, countdown, preview, timer, columns, rows, numActive, strikes, events, action, data)
			local params = {
				type = "memory",
				countdown = countdown,
				timer = preview,
				limit = timer,
				cols = columns,
				rows = rows,
				errors = strikes,
				difficulty = numActive,
				total = columns * rows,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Limit: Total duration of game
			Timer: How long between target generation (First target is generated at a quarter of this rate after game starts)
			StartSize: Size, in pixels, that targets start at
			MaxSize: Max size, in pixels, that targets grow to
			GrowthRate: How fast targets grow, lower is faster
			Accuracy: Required accuracy player must have to pass game
			IsMoving: Are the targets moving around the screen?

			Criteria:
				- Success: Accuracy equal to or higher than the required accuracy
				- Perfect: 100% Accuracy
				- Fail: Accuracy lower than the required accuracy
		]]
		Aim = function(self, countdown, limit, timer, startSize, maxSize, growthRate, accuracy, isMoving, events, action, data)
			local params = {
				type = "aim",
				countdown = countdown,
				limit = limit,
				timer = timer,
				startSize = startSize,
				maxSize = maxSize,
				difficulty = growthRate,
				accuracy = accuracy,
				isMoving = isMoving,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Timer: How long, in miliseconds, to show the preview
			Limit: Total duration of game
			Difficulty: How many squares
			Difficulty2: How many questions the user has to answer (Up to 8)

			Criteria:
				- Success: Entered Correct Answer
				- Fail: Timeout or incorrect entry
		]]
		Captcha = function(self, countdown, timer, limit, difficulty, difficulty2, events, action, data)
			if difficulty2 > 8 then
				difficulty2 = 8
			end

			local params = {
				type = "captcha",
				countdown = countdown,
				timer = timer,
				limit = limit,
				difficulty = difficulty,
				difficulty2 = difficulty2,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Timer: Range, miliseconds in an array (IE: {3000, 4000}), for keys to take to move from top to bottom
			Limit: Total duration of game
			Difficulty: How many alleys (Up to 4)
			Chances: How many fails player can have before game ends
			IsShuffled: Boolean, are the alleys shuffled (IE, A S D F keyset could be in D S F A order)

			Criteria:
				- Success: Lasted duration of game without failing more than allowed
				- Fail: Failed more than allowed
		]]
		Keymaster = function(self, countdown, timer, limit, difficulty, chances, isShuffled, events, action, data)
			if difficulty > 4 then
				difficulty = 4
			end

			local params = {
				type = "keymaster",
				countdown = countdown,
				timer = timer,
				limit = limit,
				difficulty = difficulty,
				chances = chances,
				shuffled = isShuffled,
				randomKey = true,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Limit: Total duration of game
			Size: How many rows of 10 characters are there (Limit of 10)
			Difficulty: How many characters are in the answer sequence
			Difficulty2: How many characters are in each element
			Charset: Charset to use, or false to use a random one. (Valid Options: numeric, alphabet, alphanumer, greek, symbols)

			Criteria:
				- Success: Prompted finish with the correct values highlighted
				- Fail: Time ran out or selected wrong characters
		]]
		Pattern = function(self, countdown, limit, size, difficulty, difficulty2, charset, events, action, data)
			if size > 10 then
				size = 10
			end

			local params = {
				type = "pattern",
				countdown = countdown,
				limit = limit,
				size = size,
				difficulty = difficulty,
				difficulty2 = difficulty2,
				total = charset,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Timer: How many times icon shuffle, each shuffle is ~1 second (IE: timer = 5 is 5 shuffles or 5 seconds)
			Limit: Total duration of game
			Delay: How long, in ms, to show the final shuffled results before starting input
			Difficulty: How many icons to show, should be divisible by 4
			Difficulty2: How may different icons the user must enter

			Criteria:
				- Success: Submited all successful answers
				- Fail: Time ran out or submitted incorrect answer
		]]
		Icons = function(self, countdown, timer, limit, delay, difficulty, difficulty2, events, action, data)
			local params = {
				type = "icons",
				countdown = countdown,
				timer = timer,
				limit = limit,
				delay = delay,
				difficulty = difficulty,
				difficulty2 = difficulty2,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		--[[
			Countdown: Time before game is started
			Delay: How long to display numbers of targets
			Limit: Total duration of game
			Difficulty: How many targets are tehre

			Criteria:
				- Success: Submited all successful answers
				- Fail: Time ran out or submitted incorrect answer
		]]
		Tracking = function(self, countdown, delay, limit, difficulty, events, action, data)
			local params = {
				type = "tracking",
				countdown = countdown,
				delay = delay,
				limit = limit,
				difficulty = difficulty,
				events = events,
				data = data,
				needsMouse = true,
			}

			action = normalizeAction(action or {})
			action.controlDisables = {
				disableMouse = true,
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			}

			_playGame(params, action)
		end,
		Drill = function(self, events, data)
			Drilling.Start(function(success)
				if success then
					if type(events.onSuccess) == "string" then
						TriggerEvent(events.onSuccess, data or {})
					else
						events.onSuccess(data or {})
					end
					ClearPedTasks(PlayerPedId())
				else
					if type(events.onFail) == "string" then
						TriggerEvent(events.onFail, data or {})
					else
						events.onFail(data or {})
					end
					ClearPedTasks(PlayerPedId())
				end
			end)
		end,
		--[[
			Countdown: Time before game is started
			Preview: Time, in MS, activated cells are highlighted before game is activated
			Speed: How fast sliders are moving, NOTE: Speed is reduced by 100ms on every slider so keep this in mind
			Foregiveness: The size in which the slider may be off but still count (In pixels), higher = easier
			Number of Sliders: How many sliders the game will have

			Criteria:
				- Success: p
				- Fail: Timeout
		]]
		-- Sliders = function(self, countdown, speed, limit, foregiveness, numberOfSliders, events, action, data)
		-- 	print(numberOfSliders)
		-- 	local params = {
		-- 		type = "drill",
		-- 		countdown = countdown,
		-- 		timer = speed,
		-- 		limit = limit,
		-- 		difficulty = foregiveness,
		-- 		total = numberOfSliders,
		-- 		events = events,
		-- 		data = data,
		-- 		needsMouse = true,
		-- 	}

		-- 	action = normalizeAction(action or {})
		-- 	action.controlDisables = {
		-- 		disableMouse = true,
		-- 		disableMovement = true,
		-- 		disableCarMovement = true,
		-- 		disableCombat = true,
		-- 	}

		-- 	_playGame(params, action)
		-- end,
	},
	Cancel = function(self)
		SendNUIMessage({
			type = "FAIL_GAME",
		})

		isPlayingGame = false
		if type(_playing.events.onFail) == "string" then
			TriggerEvent(_playing.events.onFail, _playing.data)
		else
			_playing.events.onFail(_playing.data)
		end

		Minigame:End()
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
	end,
	End = function(self)
		_runGameThread = false
		isPlayingGame = false

		LocalPlayer.state.doingAction = false
	end,
}

RegisterNUICallback("Minigame:Finish", function(data, cb)
	cb("OK")
	isPlayingGame = false
	if data.state == 0 then
		if type(_playing.events.onFail) == "string" then
			TriggerEvent(_playing.events.onFail, merge(_playing.data or {}, data or {}))
		else
			_playing.events.onFail(merge(_playing.data or {}, data or {}))
		end
	elseif data.state == 1 then
		if type(_playing.events.onSuccess) == "string" then
			TriggerEvent(_playing.events.onSuccess, merge(_playing.data, data or {}))
		else
			_playing.events.onSuccess(merge(_playing.data or {}, data or {}))
		end
	else
		if type(_playing.events.onPerfect) == "string" then
			TriggerEvent(_playing.events.onPerfect, merge(_playing.data or {}, data or {}))
		else
			_playing.events.onPerfect(merge(_playing.data or {}, data or {}))
		end
	end
end)

RegisterNUICallback("Minigame:End", function(data, cb)
	cb("OK")
	Minigame:End()
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Minigame", MINIGAME)
end)

function _playGame(params, action)
	local player = PlayerPedId()
	_playing = params
	_doGameStart(player, action)

	if not IsEntityDead(player) or action.useWhileDead then
		if not isPlayingGame then
			isPlayingGame = true
			wasCancelled = false
			isAnim = false
			isProp = false

			SendNUIMessage({
				type = "SHOW_GAME",
				data = {
					game = params,
				},
			})

			Citizen.CreateThread(function()
				while isPlayingGame do
					SetNuiFocus(true, params.needsMouse)
					SetNuiFocusKeepInput(not params.needsMouse)
					Citizen.Wait(1)
					if IsEntityDead(player) and not action.useWhileDead then
						Minigame:Cancel()
					end
				end
			end)
		else
			Notification:Error("Already Doing An Action", 5000)
		end
	else
		Notification:Error("Already Doing An Action", 5000)
	end
end

function _doGameStart(player, action)
	_runGameThread = true
	LocalPlayer.state.doingAction = true

	Citizen.CreateThread(function()
		while isPlayingGame do
			_disableInput(player, action.controlDisables)
			Citizen.Wait(1)
		end
	end)

	Citizen.CreateThread(function()
		while _runGameThread do
			if isPlayingGame and action ~= nil then
				if not isAnim then
					if action.animation then
						if action.animation.task ~= nil then
							if GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
								TaskStartScenarioInPlace(player, action.animation.task, 0, true)
							end
						elseif action.animation.animDict ~= nil and action.animation.anim ~= nil then
							if action.animation.flags == nil then
								action.animation.flags = 1
							end

							if DoesEntityExist(player) and not IsEntityDead(player) then
								loadAnimDict(action.animation.animDict)
								TaskPlayAnim(
									player,
									action.animation.animDict,
									action.animation.anim,
									3.0,
									1.0,
									-1,
									action.animation.flags,
									0,
									0,
									0,
									0
								)
							end
						elseif action.animation.anim ~= nil then
							Animations.Emotes:Play(action.animation.anim, false, action.duration or -1, true)
						else
							if GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
								TaskStartScenarioInPlace(player, "PROP_HUMAN_BUM_BIN", 0, true)
							end
						end
						if action.disarm then
							Weapons:UnequipIfEquippedNoAnim()
						end
					end

					isAnim = true
				end
				if not isProp and action.prop ~= nil and action.prop.model ~= nil then
					RequestModel(action.prop.model)

					while not HasModelLoaded(GetHashKey(action.prop.model)) do
						Citizen.Wait(0)
					end

					local pCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 0.0)
					local modelSpawn =
						CreateObject(GetHashKey(action.prop.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)

					local netid = ObjToNet(modelSpawn)
					SetNetworkIdExistsOnAllMachines(netid, true)
					NetworkSetNetworkIdDynamic(netid, true)
					SetNetworkIdCanMigrate(netid, false)
					if action.prop.bone == nil then
						action.prop.bone = 60309
					end

					if action.prop.coords == nil then
						action.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
					end

					if action.prop.rotation == nil then
						action.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
					end

					AttachEntityToEntity(
						modelSpawn,
						player,
						GetPedBoneIndex(player, action.prop.bone),
						action.prop.coords.x,
						action.prop.coords.y,
						action.prop.coords.z,
						action.prop.rotation.x,
						action.prop.rotation.y,
						action.prop.rotation.z,
						1,
						1,
						0,
						1,
						0,
						1
					)
					prop_net = netid

					isProp = true

					if not isPropTwo and action.propTwo ~= nil and action.propTwo.model ~= nil then
						RequestModel(action.propTwo.model)

						while not HasModelLoaded(GetHashKey(action.propTwo.model)) do
							Citizen.Wait(0)
						end

						local pCoords = GetEntityCoords(player)
						local modelSpawn = CreateObject(
							GetHashKey(action.propTwo.model),
							pCoords.x,
							pCoords.y,
							pCoords.z,
							true,
							true,
							true
						)

						local netid = ObjToNet(modelSpawn)
						SetNetworkIdExistsOnAllMachines(netid, true)
						NetworkSetNetworkIdDynamic(netid, true)
						SetNetworkIdCanMigrate(netid, false)
						if action.propTwo.bone == nil then
							action.propTwo.bone = 60309
						end

						if action.propTwo.coords == nil then
							action.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
						end

						if action.propTwo.rotation == nil then
							action.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
						end

						AttachEntityToEntity(
							modelSpawn,
							player,
							GetPedBoneIndex(player, action.propTwo.bone),
							action.propTwo.coords.x,
							action.propTwo.coords.y,
							action.propTwo.coords.z,
							action.propTwo.rotation.x,
							action.propTwo.rotation.y,
							action.propTwo.rotation.z,
							1,
							1,
							0,
							1,
							0,
							1
						)
						propTwo_net = netid

						isPropTwo = true
					end
				end

				if action.vehicle and not IsPedInAnyVehicle(player) then
					Minigame:Cancel()
				end
			end
			Citizen.Wait(0)
		end
		_gameCleanup(action)
	end)
end

function _gameCleanup(action)
	LocalPlayer.state.doingAction = false
	if action ~= nil and action.animation then
		if action.animation.task ~= nil or (action.animation.animDict ~= nil and action.animation.anim ~= nil) then
			if GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
				if action.animation.task ~= nil then
					ClearPedTasksImmediately(LocalPlayer.state.ped)
				end
				ClearPedSecondaryTask(PlayerPedId())
				StopAnimTask(PlayerPedId(), action.animation.animDict, action.animation.anim, 1.0)
			end
		elseif action.animation.anim ~= nil then
			Animations.Emotes:ForceCancel()
		else
			if action.animation.task ~= nil and GetVehiclePedIsIn(LocalPlayer.state.ped) == 0 then
				ClearPedTasksImmediately(LocalPlayer.state.ped)
			end
		end
	end

	DeleteEntity(prop_net)
	DeleteEntity(propTwo_net)
	DeleteEntity(NetToObj(prop_net))
	DeleteEntity(NetToObj(propTwo_net))
	prop_net = nil
	propTwo_net = nil
	_playing = nil
end
