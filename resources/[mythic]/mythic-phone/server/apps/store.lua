PHONE.Store = {
	Install = {
		Check = function(self, app, method)
			-- As of now, just pass true, idfk if we doing this shti
			Wait(5e3)
			return method == "store"
		end,
		Do = function(self, app, apps, method)
			if not hasValue(apps.installed, app) then
				table.insert(apps.installed, app)
				if #apps.home < 20 then
					table.insert(apps.home, app)
				end
			end
			return apps
		end,
	},
	Uninstall = {
		Check = function(self, app)
			Wait(5e3)
			return true
		end,
		Do = function(self, app, apps)
			local newApps = { installed = {}, home = {}, dock = {} }
			for k, v in ipairs(apps.installed) do
				if v ~= app then
					table.insert(newApps.installed, v)
				end
			end
			for k, v in ipairs(apps.home) do
				if v ~= app then
					table.insert(newApps.home, v)
				end
			end
			for k, v in ipairs(apps.dock) do
				if v ~= app then
					table.insert(newApps.dock, v)
				end
			end
			return newApps
		end,
	},
}
AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Store:Install:Check", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		CreateThread(function()
			cb(Phone.Store.Install:Check(data))
		end)
	end)
	Callbacks:RegisterServerCallback("Phone:Store:Install:Do", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		CreateThread(function()
			char:SetData("Apps", Phone.Store.Install:Do(data, char:GetData("Apps"), "store"))
			cb(true, PHONE_APPS[data], os.time() * 1e3)
		end)
	end)
	Callbacks:RegisterServerCallback("Phone:Store:Uninstall:Check", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		CreateThread(function()
			cb(Phone.Store.Uninstall:Check(data))
		end)
	end)
	Callbacks:RegisterServerCallback("Phone:Store:Uninstall:Do", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		CreateThread(function()
			local nApps = Phone.Store.Uninstall:Do(data, char:GetData("Apps"))
			char:SetData("Apps", nApps)
			cb(true)
		end)
	end)
end)
