_MDT.Metrics = {
	Today = function(self)
		return MDT.Metrics:Get(GlobalState["MDT:Metric:CurrentDay"])
	end,
	Get = function(self, key)
		local p = promise.new()
		Database.Game:findOne({
			collection = "mdt_metrics",
			query = {
				date = key,
			},
		}, function(success, results)
			if not success or #results == 0 then
				p:resolve(false)
				return
			end

			p:resolve(results[1])
		end)
		return Citizen.Await(p)
	end,
}

function MetricsStartup()
	local date = os.date("*t")
	GlobalState["MDT:Metric:CurrentDay"] = string.format("%s/%s/%s", date.month, date.day, date.year)

	local r = MDT.Metrics:Today() or {}
	GlobalState["MDT:Metric:Arrests"] = r.Arrests or 0
	GlobalState["MDT:Metric:Reports"] = r.Reports or 0
	GlobalState["MDT:Metric:Warrants"] = r.Warrants or 0
	GlobalState["MDT:Metric:BOLOs"] = r.BOLOs or 0
	GlobalState["MDT:Metric:Search"] = r.Search or 0
end

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:GetMetrics", function(source, data, cb)
        cb(MDT.Metrics:Get(data))
	end)
end)
