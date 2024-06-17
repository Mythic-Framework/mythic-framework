-- ====================================================================================
-- #Author: Jonathan D @ Gannon
-- All Credits To GCPhone For Most Of This Code
-- ====================================================================================
local myPedId = nil

local phoneProp = 0
local phoneModel = `prop_npc_phone`
-- OR "prop_npc_phone"
-- OR "prop_npc_phone_02"
-- OR "prop_cs_phone_01"

local currentStatus = "out"
local lastDict = nil
local lastAnim = nil
local lastIsFreeze = false

local ANIMS = {
	["cellphone@"] = {
		["out"] = {
			["text"] = "cellphone_text_in",
			["call"] = "cellphone_call_listen_base",
		},
		["text"] = {
			["out"] = "cellphone_text_out",
			["text"] = "cellphone_text_in",
			["call"] = "cellphone_text_to_call",
		},
		["call"] = {
			["out"] = "cellphone_call_out",
			["text"] = "cellphone_call_to_text",
			["call"] = "cellphone_text_to_call",
		},
	},
	["anim@cellphone@in_car@ps"] = {
		["out"] = {
			["text"] = "cellphone_text_in",
			["call"] = "cellphone_call_in",
		},
		["text"] = {
			["out"] = "cellphone_text_out",
			["text"] = "cellphone_text_in",
			["call"] = "cellphone_text_to_call",
		},
		["call"] = {
			["out"] = "cellphone_horizontal_exit",
			["text"] = "cellphone_call_to_text",
			["call"] = "cellphone_text_to_call",
		},
	},
}

function newPhoneProp()
	deletePhone()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
	SetEntityCollision(phoneProp, false, false)

	local bone = GetPedBoneIndex(myPedId, 28422)
	AttachEntityToEntity(phoneProp, myPedId, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)

	CreateThread(function()
		while LocalPlayer.state.phoneOpen do
			Wait(3)
		end
		deletePhone()
	end)
end

function deletePhone()
	if phoneProp ~= 0 then
		DeleteEntity(phoneProp)
		phoneProp = 0
	end
end

--[[
	out || text || Call ||
--]]
function PhonePlayAnim(status, freeze, force)
	if currentStatus == status and force ~= true then
		return
	end

	myPedId = PlayerPedId()

	local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId, false) then
		dict = "anim@cellphone@in_car@ps"
	end
	loadAnimDict(dict)

	local anim = ANIMS[dict][currentStatus][status]
	if currentStatus ~= "out" then
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end
	local flag = 50
	if freeze == true then
		flag = 18
	end

	TaskPlayAnim(myPedId, dict, anim, 3.0, -1, -1, flag, 0, false, false, false)

	if status ~= "out" and currentStatus == "out" then
		Wait(380)
		newPhoneProp()
	end

	lastDict = dict
	lastAnim = anim
	lastIsFreeze = freeze
	currentStatus = status

	if status == "out" then
		Wait(180)
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end
end

function PhonePlayOut()
	if not Phone.Call:Status() then
		PhonePlayAnim("out")
	end
end

function PhonePlayText()
	CreateThread(function()
		while LocalPlayer.state.phoneOpen do
			if
				(not IsEntityPlayingAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 3)
				or (IsPedInAnyVehicle(myPedId, false) and not IsEntityPlayingAnim(PlayerPedId(), "anim@cellphone@in_car@ps", "cellphone_text_in", 3)))
				and not Phone.Call:Status()
			then
				PhonePlayAnim("text", false, true)
			end
			Wait(1000)
		end
	end)
end

function PhonePlayCall(freeze)
	CreateThread(function()
		while _call ~= nil and not _call.onHold do
			if not LocalPlayer.state.phoneOpen then
				if 
					not IsEntityPlayingAnim(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 3)
					or (IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityPlayingAnim(PlayerPedId(), "anim@cellphone@in_car@ps", "cellphone_text_to_call", 3))
				then
					PhonePlayAnim("call", freeze, true)
				end
			end
			Wait(1000)
		end
	end)
end

function PhoneCallToText()
	if not Phone.Call:Status() then
		PhonePlayAnim("text", false, true)
	end
end

function PhoneTextToCall()
	PhonePlayAnim("call", false, true)
end

function PhonePlayIn()
	if not Phone.Call:Status() then
		PhonePlayAnim("text", false, true)
	end
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(1)
	end
end
