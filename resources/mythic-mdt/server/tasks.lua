function RegisterTasks()
    Tasks:Register('mdt_warrants', 30, function()
		Logger:Trace('MDT', 'Expiring Warrants')
		local filteredWarrants = {}
        for k, v in ipairs(_warrants) do
            if v.expires < (os.time() * 1000) then
				for user, _ in pairs(_onDutyUsers) do
					TriggerClientEvent("MDT:Client:RemoveData", user, "warrants", v._id)
				end
			else
				table.insert(filteredWarrants, v)
			end
        end

		_warrants = filteredWarrants
    end)
	
    Tasks:Register('mdt_metrics', 5, function()
		Logger:Trace('MDT', 'Metrics Stored')
		Database.Game:updateOne({
			collection = 'mdt_metrics',
			query = {
				date = GlobalState['MDT:Metric:CurrentDay']
			},
			update = {
				['$set'] = {
					Arrests = GlobalState["MDT:Metric:Arrests"],
					Reports = GlobalState["MDT:Metric:Reports"],
					Warrants = GlobalState["MDT:Metric:Warrants"],
					BOLOs = GlobalState["MDT:Metric:BOLOs"],
					Searches = GlobalState["MDT:Metric:Search"],
				}
			},
			options = {
				upsert = true,
			}
		}, function(s, r)
		end)
    end)
	
    Tasks:Register('mdt_metrics_time', 30, function()
		Logger:Trace('MDT', 'Validating Metric Key')
		local date = os.date("*t")
		local t = string.format('%s/%s/%s', date.month, date.day, date.year)
		if t ~= GlobalState['MDT:Metric:CurrentDay'] then
			Logger:Trace('MDT', 'New Day, Resetting Metrics')
			Database.Game:updateOne({
				collection = 'mdt_metrics',
				query = {
					date = GlobalState['MDT:Metric:CurrentDay']
				},
				update = {
					['$set'] = {
						Arrests = GlobalState["MDT:Metric:Arrests"],
						Reports = GlobalState["MDT:Metric:Reports"],
						Warrants = GlobalState["MDT:Metric:Warrants"],
						BOLOs = GlobalState["MDT:Metric:BOLOs"],
						Searches = GlobalState["MDT:Metric:Search"],
					}
				},
				options = {
					upsert = true,
				}
			}, function(s, r)
				GlobalState['MDT:Metric:CurrentDay'] = t
				GlobalState["MDT:Metric:Arrests"] = 0
				GlobalState["MDT:Metric:Reports"] = 0
				GlobalState["MDT:Metric:Warrants"] = 0
				GlobalState["MDT:Metric:BOLOs"] = 0
				GlobalState["MDT:Metric:Search"] = 0
			end)
		end
    end)
end