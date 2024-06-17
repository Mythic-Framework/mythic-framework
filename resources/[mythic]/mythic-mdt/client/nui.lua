RegisterNUICallback("Search", function(data, cb)
	Callbacks:ServerCallback("MDT:Search:" .. data.type, data, cb)
end)

RegisterNUICallback("View", function(data, cb)
	Callbacks:ServerCallback("MDT:View:" .. data.type, data.id, cb)
end)

RegisterNUICallback("Create", function(data, cb)
	Callbacks:ServerCallback("MDT:Create:" .. data.type, data, cb)
end)

RegisterNUICallback("Update", function(data, cb)
	Callbacks:ServerCallback("MDT:Update:" .. data.type, data, cb)
end)

RegisterNUICallback("Delete", function(data, cb)
	Callbacks:ServerCallback("MDT:Delete:" .. data.type, data, cb)
end)

RegisterNUICallback("SentencePlayer", function(data, cb)
	Callbacks:ServerCallback("MDT:SentencePlayer", data, cb)
end)

RegisterNUICallback("ManageEmployment", function(data, cb)
	Callbacks:ServerCallback("MDT:ManageEmployment", data, cb)
end)

RegisterNUICallback("HireEmployee", function(data, cb)
	Callbacks:ServerCallback("MDT:Hire", data, cb)
end)

RegisterNUICallback("FireEmployee", function(data, cb)
	Callbacks:ServerCallback("MDT:Fire", data, cb)
end)

RegisterNUICallback("CheckCallsign", function(data, cb)
	Callbacks:ServerCallback("MDT:CheckCallsign", data, cb)
end)

RegisterNUICallback("CheckParole", function(data, cb)
	Wait(((data.index and (data.index + 1) or 1) * 250)) -- Really Dumb Because You Can't do 2 NUI Cbs at the same time Lazy Fix
	Callbacks:ServerCallback("MDT:CheckParole", data.SID, cb)
end)

RegisterNUICallback("EvidenceLocker", function(data, cb)
	cb(true)
	Callbacks:ServerCallback("MDT:OpenEvidenceLocker", data)
end)

RegisterNUICallback("GetMetrics", function(data, cb)
	if data == GlobalState['MDT:Metric:CurrentDay'] then
		cb({
			labels = {
				'Arrests', 'Reports', 'Warrants', 'BOLO\'s', 'Searches',
			},
			datasets = {
			  {
				label = 'Metrics',
				data = {
					GlobalState["MDT:Metric:Arrests"] or 0,
					GlobalState["MDT:Metric:Reports"] or 0,
					GlobalState["MDT:Metric:Warrants"] or 0,
					GlobalState["MDT:Metric:BOLOs"] or 0,
					GlobalState["MDT:Metric:Search"] or 0,
				},
				backgroundColor = {
				  'rgba(255, 99, 132, 0.2)',
				  'rgba(54, 162, 235, 0.2)',
				  'rgba(255, 206, 86, 0.2)',
				  'rgba(75, 192, 192, 0.2)',
				  'rgba(153, 102, 255, 0.2)',
				},
				borderColor = {
				  'rgba(255, 99, 132, 1)',
				  'rgba(54, 162, 235, 1)',
				  'rgba(255, 206, 86, 1)',
				  'rgba(75, 192, 192, 1)',
				  'rgba(153, 102, 255, 1)',
				},
				borderWidth = 1,
			  },
			},
		})
	else
		Callbacks:ServerCallback('MDT:GetMetrics', data, function(metrics)
			if metrics ~= nil then
				cb({
					labels = {
						'Arrests', 'Reports', 'Warrants', 'BOLO\'s', 'Searches',
					},
					datasets = {
					  {
						label = 'Metrics',
						data = metrics,
						backgroundColor = {
						  'rgba(255, 99, 132, 0.2)',
						  'rgba(54, 162, 235, 0.2)',
						  'rgba(255, 206, 86, 0.2)',
						  'rgba(75, 192, 192, 0.2)',
						  'rgba(153, 102, 255, 0.2)',
						},
						borderColor = {
						  'rgba(255, 99, 132, 1)',
						  'rgba(54, 162, 235, 1)',
						  'rgba(255, 206, 86, 1)',
						  'rgba(75, 192, 192, 1)',
						  'rgba(153, 102, 255, 1)',
						},
						borderWidth = 1,
					  },
					},
				})
			else
				cb(nil)
			end
		end)
	end
end)

RegisterNUICallback("PrintBadge", function(data, cb)
	Callbacks:ServerCallback("MDT:PrintBadge", data, cb)
end)

RegisterNUICallback("RevokeSuspension", function(data, cb)
	Callbacks:ServerCallback("MDT:RevokeLicenseSuspension", data, cb)
end)

RegisterNUICallback("ClearRecord", function(data, cb)
	Callbacks:ServerCallback("MDT:ClearCriminalRecord", data, cb)
end)