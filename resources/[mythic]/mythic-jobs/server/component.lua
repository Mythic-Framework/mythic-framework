_characterDuty = {}
_dutyData = {}

_JOBS = {
	GetAll = function(self)
		return JOB_CACHE
	end,
	Get = function(self, jobId)
		return JOB_CACHE[jobId]
	end,
	DoesExist = function(self, jobId, workplaceId, gradeId)
		local job = Jobs:Get(jobId)
		if job then
			if workplaceId and job.Workplaces then
				for _, workplace in ipairs(job.Workplaces) do
					if workplace.Id == workplaceId then
						if not gradeId then
							return {
								Id = job.Id,
								Name = job.Name,
								Workplace = false,
								Hidden = job.Hidden,
							}
						end

						for _, grade in ipairs(workplace.Grades) do
							if grade.Id == gradeId then
								return {
									Id = job.Id,
									Name = job.Name,
									Workplace = {
										Id = workplace.Id,
										Name = workplace.Name,
									},
									Grade = {
										Id = grade.Id,
										Name = grade.Name,
										Level = grade.Level,
									},
									Hidden = job.Hidden,
								}
							end
						end
					end
				end
			elseif not workplaceId then
				if not gradeId then
					return {
						Id = job.Id,
						Name = job.Name,
						Workplace = false,
						Hidden = job.Hidden,
					}
				elseif gradeId and job.Grades then
					for _, grade in ipairs(job.Grades) do
						if grade.Id == gradeId then
							return {
								Id = job.Id,
								Name = job.Name,
								Workplace = false,
								Grade = {
									Id = grade.Id,
									Name = grade.Name,
									Level = grade.Level,
								},
								Hidden = job.Hidden,
							}
						end
					end
				end
			end
		end
		return false
	end,
	GiveJob = function(self, stateId, jobId, workplaceId, gradeId, noOverride)
		local newJob = Jobs:DoesExist(jobId, workplaceId, gradeId)
		if not newJob or not newJob.Grade then
			return false
		end

		local char = Fetch:SID(stateId)
		if char then 
			char = char:GetData('Character')
		end

		if char then
			local charJobData = char:GetData('Jobs')
			if not charJobData then charJobData = {}; end

			for k, v in ipairs(charJobData) do
				if v.Id == newJob.Id then
					if noOverride then
						return false
					else
						table.remove(charJobData, k)
					end
				end
			end

			table.insert(charJobData, newJob)

			local source = char:GetData('Source')
			char:SetData('Jobs', charJobData)

			Middleware:TriggerEvent('Characters:ForceStore', source)

			Phone:UpdateJobData(source)

			TriggerEvent('Jobs:Server:JobUpdate', source)

			return true
		else
			local p = promise.new()
			Database.Game:findOne({
				collection = 'characters',
				query = {
					SID = stateId,
				}
			}, function(success, results)
				if success and #results > 0 then
					local charData = results[1]
					local charJobData = charData.Jobs
					if not charJobData then charJobData = {}; end

					for k, v in ipairs(charJobData) do
						if v.Id == newJob.Id then
							if noOverride then
								p:resolve(false)
								return
							else
								table.remove(charJobData, k)
							end
						end
					end

					table.insert(charJobData, newJob)

					Database.Game:updateOne({
						collection = 'characters',
						query = {
							SID = stateId,
						},
						update = {
							['$set'] = {
								Jobs = charJobData,
							}
						}
					}, function(success, updated)
						if success and updated > 0 then
							p:resolve(true)
						else
							p:resolve(false)
						end
					end)
				else
					p:resolve(false)
				end
			end)

			local res = Citizen.Await(p)
			return res
		end
	end,
	RemoveJob = function(self, stateId, jobId)
		local char = Fetch:SID(stateId)
		if char then
			char = char:GetData('Character')
		end

		if char then
			local found = false
			local charJobData = char:GetData('Jobs')
			if not charJobData then charJobData = {}; end
			local removedJobData

			for k, v in ipairs(charJobData) do
				if v.Id == jobId then
					removedJobData = v
					found = true
					table.remove(charJobData, k)
				end
			end

			if found then
				local source = char:GetData('Source')
				char:SetData('Jobs', charJobData)
				Jobs.Duty:Off(source, jobId, true)

				Middleware:TriggerEvent('Characters:ForceStore', source)
				Phone:UpdateJobData(source)
				TriggerEvent('Jobs:Server:JobUpdate', source)

				if removedJobData.Workplace and removedJobData.Workplace.Name then
					Execute:Client(source, 'Notification', 'Info', 'No Longer Employed at '.. removedJobData.Workplace.Name)
				else
					Execute:Client(source, 'Notification', 'Info', 'No Longer Employed at '.. removedJobData.Name)
				end

				return true
			end
		else
			local p = promise.new()
			Database.Game:findOne({
				collection = 'characters',
				query = {
					SID = stateId,
				}
			}, function(success, results)
				if success and #results > 0 then
					local charData = results[1]
					local charJobData = charData.Jobs
					if charJobData then
						for k, v in ipairs(charJobData) do
							if v.Id == jobId then
								found = true
								table.remove(charJobData, k)
							end
						end

						if found then
							Database.Game:updateOne({
								collection = 'characters',
								query = {
									SID = stateId,
								},
								update = {
									['$set'] = {
										Jobs = charJobData,
									}
								}
							}, function(success, updated)
								if success and updated > 0 then
									p:resolve(true)
								else
									p:resolve(false)
								end
							end)
						else
							p:resolve(false)
						end
					else
						p:resolve(false)
					end
				else
					p:resolve(false)
				end
			end)

			local res = Citizen.Await(p)
			return res
		end
	end,
	Duty = {
		On = function(self, source, jobId, hideNotify)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local stateId = char:GetData('SID')
					local charJobs = char:GetData('Jobs')
					local hasJob = false

					for k, v in ipairs(charJobs) do
						if v.Id == jobId then
							hasJob = v
							break
						end
					end

					if hasJob then
						local dutyData = _characterDuty[stateId]
						if dutyData then
							if dutyData.Id == hasJob.Id then
								return true -- Already on duty as that job
							else
								local success = Jobs.Duty:Off(source, false, true)
								if not success then
									return false
								end
							end
						end

						_characterDuty[stateId] = {
							Source = source,
							Id = hasJob.Id,
							StartTime = os.time(),
							Time = os.time(),
							WorkplaceId = (hasJob.Workplace and hasJob.Workplace.Id or false),
							GradeId = hasJob.Grade.Id,
							GradeLevel = hasJob.Grade.Level,
							First = char:GetData('First'),
							Last = char:GetData('Last'),
							Callsign = char:GetData('Callsign'),
						}

						local ply = Player(source)
						if ply and ply.state then
							ply.state.onDuty = _characterDuty[stateId].Id
						end

						local callsign = char:GetData('Callsign')
						TriggerEvent('Job:Server:DutyAdd', _characterDuty[stateId], source, stateId, callsign)
						TriggerClientEvent('Job:Client:DutyChanged', source, _characterDuty[stateId].Id)
						Jobs.Duty:RefreshDutyData(hasJob.Id)

						local lastOnDutyData = char:GetData('LastClockOn') or {}
						lastOnDutyData[hasJob.Id] = os.time()
						char:SetData('LastClockOn', lastOnDutyData)

						if not hideNotify then
							if hasJob.Workplace then
								Execute:Client(source, 'Notification', 'Success', string.format('You\'re Now On Duty as %s - %s', hasJob.Workplace.Name, hasJob.Grade.Name))
							else
								Execute:Client(source, 'Notification', 'Success', string.format('You\'re Now On Duty as %s - %s', hasJob.Name, hasJob.Grade.Name))
							end
						end

						return hasJob
					end
				end
			end

			if not hideNotify then
				Execute:Client(source, 'Notification', 'Error', 'Failed to Go On Duty')
			end

			return false
		end,
		Off = function(self, source, jobId, hideNotify)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local stateId = char:GetData('SID')
					local dutyData = _characterDuty[stateId]
					if dutyData and (not jobId or (dutyData.Id == jobId)) then
						local dutyId = dutyData.Id
						local ply = Player(source)
						if ply and ply.state then
							ply.state.onDuty = false
						end
						
						local existing = char:GetData("Salary") or {}
						local workedMinutes = math.floor((os.time() - dutyData.Time) / 60)
						local j = Jobs:Get(dutyData.Id)
						local salary = math.ceil((j.Salary * j.SalaryTier) * (workedMinutes / _payPeriod))
						
                        Logger:Info("Jobs", string.format("Adding Salary Data For ^3%s^7 Going Off-Duty (^2%s Minutes^7 - ^3$%s^7)", char:GetData("SID"), workedMinutes, salary))

                        if existing[dutyData.Id] then
                            existing[dutyData.Id] = {
                                date = os.time(),
                                job = dutyData.Id,
                                minutes = (existing[dutyData.Id]?.minutes or 0) + workedMinutes,
                                total = (existing[dutyData.Id]?.total or 0) + salary,
                            }
                        else
                            existing[dutyData.Id] = {
                                date = os.time(),
                                job = dutyData.Id,
                                minutes = workedMinutes,
                                total = salary,
                            }
                        end

                        char:SetData("Salary", existing)

						TriggerEvent('Job:Server:DutyRemove', dutyData, source, stateId)
						TriggerClientEvent('Job:Client:DutyChanged', source, false)
						_characterDuty[stateId] = nil
						Jobs.Duty:RefreshDutyData(dutyId)

						local totalWorkedMinutes = math.floor((os.time() - dutyData.StartTime) / 60)
						local allTimeWorked = char:GetData("TimeClockedOn") or {}
						local jobTimeWorked = allTimeWorked[dutyData.Id] or {}

						if totalWorkedMinutes and totalWorkedMinutes >= 5 then
							table.insert(jobTimeWorked, {
								time = os.time(),
								minutes = totalWorkedMinutes,
							})

							local deleteBefore = os.time() - (60 * 60 * 24 * 14) -- Only Keep Last 14 Days
							for k,v in ipairs(jobTimeWorked) do
								if tonumber(v.time) < deleteBefore then
									table.remove(jobTimeWorked, k)
								end
							end

							allTimeWorked[dutyData.Id] = jobTimeWorked
						end
						char:SetData("TimeClockedOn", allTimeWorked)

						if not hideNotify then
							Execute:Client(source, 'Notification', 'Info', 'You\'re Now Off Duty')
						end

						return true
					end
				end
			end

			if not hideNotify then
				Execute:Client(source, 'Notification', 'Error', 'Failed to Go Off Duty')
			end

			return false
		end,
		Get = function(self, source, jobId)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local dutyData = _characterDuty[char:GetData('SID')]
					if dutyData and (not jobId or (jobId == dutyData.Id)) then
						return dutyData
					end
				end
			end
			return false
		end,
		GetDutyData = function(self, jobId)
			return _dutyData[jobId]
		end,
		RefreshDutyData = function(self, jobId)
			if not _dutyData[jobId] then
				_dutyData[jobId] = {}
			end

			local onDutyPlayers = {}
			local totalCount = 0
			local workplaceCounts = false

			for k, v in pairs(_characterDuty) do
				if v ~= nil and v.Id == jobId then
					totalCount = totalCount + 1
					table.insert(onDutyPlayers, v.Source)
					if v.WorkplaceId then
						if not workplaceCounts then
							workplaceCounts = {}
						end

						if not workplaceCounts[v.WorkplaceId] then
							workplaceCounts[v.WorkplaceId] = 1
						else
							workplaceCounts[v.WorkplaceId] = workplaceCounts[v.WorkplaceId] + 1
						end
					end
				end
			end

			_dutyData[jobId] = {
				Active = totalCount > 0,
				Count = totalCount,
				WorkplaceCounts = workplaceCounts,
				DutyPlayers = onDutyPlayers,
			}

			GlobalState[string.format('Duty:%s', jobId)] = totalCount
			if workplaceCounts then
				for workplace, count in pairs(workplaceCounts) do
					GlobalState[string.format('Duty:%s:%s', jobId, workplace)] = count
				end
			end
		end,
	},
	Permissions = {
		IsOwner = function(self, source, jobId)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local jobData = Jobs:Get(jobId)
					if jobData.Owner and jobData.Owner == char:GetData('SID') then
						return true
					end
				end
			end
			return false
		end,
		IsOwnerOfCompany = function(self, source)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local stateId = char:GetData('SID')
					local jobs = char:GetData('Jobs') or {}
					for k, v in ipairs(jobs) do
						local jobData = Jobs:Get(v.Id)
						if jobData.Owner and jobData.Owner == stateId then
							return true
						end
					end
				end
			end
			return false
		end,
		GetJobs = function(self, source)
			local player = Fetch:Source(source)
			if player then
				local char = player:GetData('Character')
				if char then
					local jobs = char:GetData('Jobs') or {}
					return jobs
				end
			end
			return false
		end,
		HasJob = function(self, source, jobId, workplaceId, gradeId, gradeLevel, checkDuty, permissionKey)
			local jobs = Jobs.Permissions:GetJobs(source)
			if not jobs then
				return false
			end
			if jobId then
				for k, v in ipairs(jobs) do
					if v.Id == jobId then
						if not workplaceId or (v.Workplace and v.Workplace.Id == workplaceId) then
							if not gradeId or (v.Grade.Id == gradeId) then
								if not gradeLevel or (v.Grade.Level and v.Grade.Level >= gradeLevel) then
									if not checkDuty or (checkDuty and Jobs.Duty:Get(source, jobId)) then
										if
											not permissionKey
											or (
												permissionKey
												and Jobs.Permissions:HasPermissionInJob(source, jobId, permissionKey)
											)
										then
											return v
										end
									end
								end
							end
						end
						break
					end
				end
			elseif permissionKey then
				return Jobs.Permissions:HasPermission(source, permissionKey)
			end
			return false
		end,
		-- Gets the permissions the character has in a job they have
		GetPermissionsFromJob = function(self, source, jobId, workplaceId)
			local jobData = Jobs.Permissions:HasJob(source, jobId, workplaceId)
			if jobData then
				local perms = GlobalState[string.format('JobPerms:%s:%s:%s', jobData.Id, (jobData.Workplace and jobData.Workplace.Id or false), jobData.Grade.Id)]
				if perms then
					return perms
				end
			end
			return false
		end,
		-- Checks if character has a permission in a specific job they have
		HasPermissionInJob = function(self, source, jobId, permissionKey)
			local permissionsInJob = Jobs.Permissions:GetPermissionsFromJob(source, jobId)
			if permissionsInJob then
				if permissionsInJob[permissionKey] then
					return true
				end
			end
			return false
		end,
		-- Gets permissions from all jobs
		GetAllPermissions = function(self, source)
			local allPermissions = {}
			local jobs = Jobs.Permissions:GetJobs(source)
			if jobs and #jobs > 0 then
				for k, v in ipairs(jobs) do
					local perms = GlobalState[string.format('JobPerms:%s:%s:%s', v.Id, (v.Workplace and v.Workplace.Id or false), v.Grade.Id)]
					if perms ~= nil then
						for k, v in pairs(perms) do
							if not allPermissions[k] then
								allPermissions[k] = v
							end
						end
					end
				end
			end
			return allPermissions
		end,
		-- Checks if character has a permission in any of their jobs
		HasPermission = function(self, source, permissionKey)
			local allPermissions = Jobs.Permissions:GetAllPermissions(source)
			return allPermissions[permissionKey]
		end,
	},
	Management = {
		Create = function(self, name, ownerSID) -- For player business creations
			if not name then
				name = Generator:Company()
			end
			local jobId = string.format('Company_%s', Sequence:Get('Company'))
			if jobId and name then
				local existing = Jobs:Get(jobId)
				if not existing then
					local p = promise.new()
					local document = {
						Type = 'Company',
						Custom = true,
						Id = jobId,
						Name = name,
						Owner = ownerSID,
						Salary = 100,
						SalaryTier = 1,
						Grades = {
							{
								Id = 'owner',
								Name = 'Owner',
								Level = 100,
								Permissions = {
									JOB_MANAGEMENT = true,
									JOB_FIRE = true,
									JOB_HIRE = true,
									JOB_MANAGE_EMPLOYEES = true,
								},
							}
						},
					}

					Database.Game:insertOne({
						collection = 'jobs',
						document = document,
					}, function(success, inserted)
						if success and inserted > 0 then
							RefreshAllJobData(document.Id)

							Jobs:GiveJob(ownerSID, document.Id, false, 'owner')

							p:resolve(document)
						else
							p:resolve(false)
						end
					end)

					local res = Citizen.Await(p)
					return res
				end
			end
			return false
		end,
		Transfer = function(self, jobId, newOwner)
			-- TODO
			--Middleware:TriggerEvent("Business:Transfer", jobId, source:GetData("SID"), target:GetData("SID"))
		end,
		Upgrades = {
			-- TODO
			Has = function(self, jobId, upgradeKey)

			end,
			Unlock = function(self, jobId, upgradeKey)

			end,
			Lock = function(self, jobId, upgradeKey)

			end,
			Reset = function(self, jobId)

			end,
		},
		Delete = function(self, jobId)
			-- TODO
		end,
		Edit = function(self, jobId, settingData)
			if Jobs:DoesExist(jobId) then
				local actualSettingData = {}

				for k, v in pairs(settingData) do
					if k ~= 'Grades' and k ~= 'Workplaces' and k ~= 'Id' and v ~= nil then
						actualSettingData[k] = v
					end
				end

				local p = promise.new()
				Database.Game:updateOne({
					collection = 'jobs',
					query = {
						Id = jobId,
					},
					update = {
						['$set'] = actualSettingData,
					},
				}, function(success, res)
					if success then
						RefreshAllJobData(jobId)

						if actualSettingData.Name then
							Jobs.Management.Employees:UpdateAllJob(jobId, actualSettingData.Name)
						end

						p:resolve(true)
					else
						p:resolve(false)
					end
				end)

				local res = Citizen.Await(p)
				return {
					success = res,
					code = 'ERROR',
				}
			else
				return {
					success = false,
					code = 'MISSING_JOB',
				}
			end
		end,
		Workplace = {
			Edit = function(self, jobId, workplaceId, newWorkplaceName)
				if Jobs:DoesExist(jobId, workplaceId) then
					local p = promise.new()
					Database.Game:updateOne({
						collection = 'jobs',
						query = {
							Type = 'Government',
							Id = jobId,
							['Workplaces.Id'] = workplaceId,
						},
						update = {
							['$set'] = {
								['Workplaces.$[workplace].Name'] = newWorkplaceName,
							},
						},
						options = {
							arrayFilters = { 
								{ ['workplace.Id'] = workplaceId }
							},
						},
					}, function(success, res)
						if success then
							RefreshAllJobData(jobId)
							Jobs.Management.Employees:UpdateAllWorkplace(jobId, workplaceId, newWorkplaceName)

							p:resolve(true)
						else
							p:resolve(false)
						end
					end)

					local res = Citizen.Await(p)
					return {
						success = res,
						code = 'ERROR',
					}
				else
					return {
						success = false,
						code = 'ERROR',
					}
				end
			end,
		},
		Grades = {
			Create = function(self, jobId, workplaceId, gradeName, gradeLevel, gradePermissions)
				if Jobs:DoesExist(jobId, workplaceId) then
					local p = promise.new()
					local gradeId
					if workplaceId then
						gradeId = string.format("Grade_%s", Sequence:Get(string.format("Company:%s:%s:Grades", jobId, workplaceId)))
					else
						gradeId = string.format("Grade_%s", Sequence:Get(string.format("Company:%s:Grades", jobId)))
					end

					if not Jobs:DoesExist(jobId, workplaceId, gradeId) then
						local query = {}
						local update = {}
						local options = {}
						
						local gradeData = {
							Id = gradeId,
							Name = gradeName,
							Level = gradeLevel,
							Permissions = gradePermissions or {},
						}
	
						if workplaceId then
							query = {
								Type = 'Government',
								Id = jobId,
								['Workplaces.Id'] = workplaceId,
							}
	
							update = {
								['$push'] = {
									['Workplaces.$[workplace].Grades'] = gradeData,
								}
							}
	
							options = {
								arrayFilters = {
									{
										['workplace.Id'] = workplaceId,
									},
								},
								multi = true,
							}
						else
							query = {
								Type = 'Company',
								Id = jobId,
							}
	
							update = {
								['$push'] = {
									Grades = gradeData,
								}
							}
	
							options = {
								multi = true
							}
						end
	
						Database.Game:updateOne({
							collection = 'jobs',
							query = query,
							update = update,
							options = options,
						}, function(success, updated)
							if success then
								RefreshAllJobData(jobId)
	
								p:resolve(true)
							else
								p:resolve(false)
							end
						end)
	
						local res = Citizen.Await(p)
						return {
							success = res,
							code = 'ERROR',
						}
					else
						return {
							success = false,
							code = 'ERROR',
						}
					end
				else
					return {
						success = false,
						code = 'MISSING_JOB',
					}
				end
			end,
			Edit = function(self, jobId, workplaceId, gradeId, settingData)
				if Jobs:DoesExist(jobId, workplaceId, gradeId) then
					local p = promise.new()
					local query = {}
					local update = {}
					local options = {}

					if workplaceId then
						query = {
							Type = 'Government',
							Id = jobId,
							['Workplaces.Id'] = workplaceId,
							["Workplaces.Grades.Id"] = gradeId,
						}

						update = {
							['$set'] = {}
						}

						for k, v in pairs(settingData) do
							if k ~= 'Id' then
								local updateKey = string.format('Workplaces.$[workplace].Grades.$[grade].%s', k)
								update['$set'][updateKey] = v
							end
						end

						options = {
							arrayFilters = {
								{
									['workplace.Id'] = workplaceId,
								},
								{
									["grade.Id"] = gradeId,
								}
							},
						}
					else
						query = {
							Type = 'Company',
							Id = jobId,
							['Grades.Id'] = gradeId,
						}

						update = {
							['$set'] = {}
						}

						for k, v in pairs(settingData) do
							if k ~= 'Id' then
								local updateKey = string.format('Grades.$[grade].%s', k)
								update['$set'][updateKey] = v
							end
						end

						options = {
							arrayFilters = { { ['grade.Id'] = gradeId } },
						}
					end

					Database.Game:updateOne({
						collection = 'jobs',
						query = query,
						update = update,
						options = options,
					}, function(success, updated)
						if success then
							RefreshAllJobData(jobId)
							Jobs.Management.Employees:UpdateAllGrade(jobId, workplaceId, gradeId, settingData)

							p:resolve(true)
						else
							p:resolve(false)
						end
					end)

					local res = Citizen.Await(p)
					return {
						success = res,
						code = 'ERROR',
					}
				else
					return {
						success = false,
						code = 'MISSING_JOB',
					}
				end
			end,
			Delete = function(self, jobId, workplaceId, gradeId)
				local peopleWithJobGrade = Jobs.Management.Employees:GetAll(jobId, workplaceId, gradeId)
				if #peopleWithJobGrade <= 0 then
					if Jobs:DoesExist(jobId, workplaceId, gradeId) then
						local p = promise.new()
						local query = {}
						local update = {}
						local options = {}

						if workplaceId then
							query = {
								Type = 'Government',
								Id = jobId,
								['Workplaces.Id'] = workplaceId,
							}

							update = {
								['$pull'] = {
									['Workplaces.$[workplace].Grades'] = {
										Id = gradeId,
									}
								}
							}

							options = {
								arrayFilters = {
									{
										['workplace.Id'] = workplaceId,
									},
								},
								multi = true,
							}
						else
							query = {
								Type = 'Company',
								Id = jobId,
							}

							update = {
								['$pull'] = {
									Grades = {
										Id = gradeId,
									}
								}
							}

							options = {
								multi = true
							}
						end

						Database.Game:updateOne({
							collection = 'jobs',
							query = query,
							update = update,
							options = options,
						}, function(success, updated)
							if success then
								RefreshAllJobData(jobId)

								p:resolve(true)
							else
								p:resolve(false)
							end
						end)

						local res = Citizen.Await(p)
						return {
							success = res,
							code = 'ERROR',
						}
					else
						return {
							success = false,
							code = 'MISSING_JOB',
						}
					end
				else
					return {
						success = false,
						code = 'JOB_OCCUPIED',
					}
				end
			end,
		},
		Employees = {
			GetAll = function(self, jobId, workplaceId, gradeId)
				local jobCharacters = {}
				local onlineCharacters = {}
				for k, v in pairs(Fetch:All()) do
					local char = v:GetData('Character')
					if char then
						table.insert(onlineCharacters, char:GetData('SID'))
						local jobs = char:GetData('Jobs')
						if jobs and #jobs > 0 then
							for k, v in ipairs(jobs) do
								if v.Id == jobId and (not workplaceId or (workplaceId and (v.Workplace and v.Workplace.Id == workplaceId))) and (not gradeId or (v.Grade.Id == gradeId)) then
									table.insert(jobCharacters, {
										Source = char:GetData('Source'),
										SID = char:GetData('SID'),
										First = char:GetData('First'),
										Last = char:GetData('Last'),
										Phone = char:GetData('Phone'),
										JobData = v,
									})
								end
							end
						end
					end
				end

				local p = promise.new()

				local query = {
					SID = {
						['$nin'] = onlineCharacters,
					},
					Jobs = {
						['$elemMatch'] = {
							Id = jobId
						}
					}
				}

				if workplaceId then
					query.Jobs['$elemMatch']['Workplace.Id'] = workplaceId
				end

				if gradeId then
					query.Jobs['$elemMatch']['Grade.Id'] = gradeId
				end

				Database.Game:find({
					collection = 'characters',
					query = query,
				}, function(success, results)
					if success then
						for _, c in ipairs(results) do
							if c.Jobs and #c.Jobs > 0 then
								for k, v in ipairs(c.Jobs) do
									if v.Id == jobId and (not workplaceId or (workplaceId and (v.Workplace and v.Workplace.Id == workplaceId))) and (not gradeId or (v.Grade.Id == gradeId)) then
										table.insert(jobCharacters, {
											Source = false,
											SID = c.SID,
											First = c.First,
											Last = c.Last,
											Phone = c.Phone,
											JobData = v,
										})
									end
								end
							end
						end
						p:resolve(true)
					else
						p:resolve(false)
					end
				end)

				local res = Citizen.Await(p)
				if res then
					return jobCharacters
				else
					return false
				end
			end,
			UpdateAllJob = function(self, jobId, newJobName)
				for k, v in pairs(Fetch:All()) do
					local char = v:GetData('Character')
					if char then
						table.insert(onlineCharacters, char:GetData('SID'))
						local jobs = char:GetData('Jobs')
						if jobs and #jobs > 0 then
							for k, v in ipairs(jobs) do
								if v.Id == jobId then
									v.Name = newJobName
									char:SetData('Jobs', jobs)
									Phone:UpdateJobData(char:GetData('Source'))
								end
							end
						end
					end
				end

				local query = {
					SID = {
						['$nin'] = onlineCharacters,
					},
					Jobs = {
						['$elemMatch'] = {
							Id = jobId,
						}
					}
				}

				local update = {
					['$set'] = {
						['Jobs.$[job].Name'] = newJobName
					}
				}

				local options = {
					arrayFilters = { 
						{
							['job.Id'] = jobId,
						},
					},
				}

				Database.Game:update({
					collection = 'characters',
					query = query,
					update = update,
					options = options,
				}, function(success, updated)
					if success then
						p:resolve(updated)
					else
						p:resolve(false)
					end
				end)

				local res = Citizen.Await(p)
				return res
			end,
			UpdateAllWorkplace = function(self, jobId, workplaceId, newWorkplaceName)
				local p = promise.new()

				local jobCharacters = {}
				local onlineCharacters = {}
				for k, v in pairs(Fetch:All()) do
					local char = v:GetData('Character')
					if char then
						table.insert(onlineCharacters, char:GetData('SID'))
						local jobs = char:GetData('Jobs')
						if jobs and #jobs > 0 then
							for k, v in ipairs(jobs) do
								if v.Id == jobId and (v.Workplace and (v.Workplace.Id == workplaceId)) then
									v.Workplace.Name = newWorkplaceName
									char:SetData('Jobs', jobs)
									Phone:UpdateJobData(char:GetData('Source'))
								end
							end
						end
					end
				end

				Database.Game:update({
					collection = 'characters',
					query = {
						SID = {
							['$nin'] = onlineCharacters,
						},
						Jobs = {
							['$elemMatch'] = {
								Type = 'Government',
								Id = jobId,
								['Workplace.Id'] = workplaceId
							}
						}
					},
					update = {
						['$set'] = {
							['Jobs.$[job].Workplace.Name'] = newWorkplaceName,
						}
					},
					options = {
						arrayFilters = { 
							{
								['job.Id'] = jobId,
							},
						},
					}
				}, function(success, updated)
					if success then
						p:resolve(updated)
					else
						p:resolve(false)
					end
				end)

				local res = Citizen.Await(p)
				return res
			end,
			UpdateAllGrade = function(self, jobId, workplaceId, gradeId, settingData)
				local jobCharacters = {}
				local onlineCharacters = {}

				if settingData.Name or settingData.Level then
					local p = promise.new()
					for k, v in pairs(Fetch:All()) do
						local char = v:GetData('Character')
						if char then
							table.insert(onlineCharacters, char:GetData('SID'))
							local jobs = char:GetData('Jobs')
							if jobs and #jobs > 0 then
								for k, v in ipairs(jobs) do
									if v.Id == jobId and (not workplaceId or (workplaceId and v.Workplace and (v.Workplace.Id == workplaceId))) and v.Grade.Id == gradeId then

										if settingData.Name then
											v.Grade.Name = settingData.Name
										end

										if settingData.Level then
											v.Grade.Level = settingData.Level
										end
	
										char:SetData('Jobs', jobs)
										Phone:UpdateJobData(char:GetData('Source'))
									end
								end
							end
						end
					end

					local query = {}
					local update = {}
					local options = {}

					if workplaceId then
						query = {
							SID = {
								['$nin'] = onlineCharacters,
							},
							Jobs = {
								['$elemMatch'] = {
									Id = jobId,
									['Workplace.Id'] = workplaceId,
									['Grade.Id'] = gradeId,
								}
							}
						}
					else
						query = {
							SID = {
								['$nin'] = onlineCharacters,
							},
							Jobs = {
								['$elemMatch'] = {
									Id = jobId,
									['Grade.Id'] = gradeId,
								}
							}
						}
					end

					update = { ['$set'] = {} }

					if settingData.Name then
						update['$set']['Jobs.$[job].Grade.Name'] = settingData.Name
					end

					if settingData.Level then
						update['$set']['Jobs.$[job].Grade.Level'] = settingData.Level
					end

					options = {
						arrayFilters = { 
							{
								['job.Id'] = jobId,
							},
						},
					}

					Database.Game:update({
						collection = 'characters',
						query = query,
						update = update,
						options = options,
					}, function(success, updated)
						if success then
							p:resolve(updated)
						else
							p:resolve(false)
						end
					end)

					local res = Citizen.Await(p)
					return res
				end
			end,
		}
	},
	Data = {
		Set = function(self, jobId, key, val)
			if Jobs:DoesExist(jobId) and key then
				local p = promise.new()
				Database.Game:updateOne({
					collection = "jobs",
					query = {
						Id = jobId,
					},
					update = {
						["$set"] = {
							[string.format("Data.%s", key)] = val,
						},
					},
				}, function(success, res)
					if success then
						RefreshAllJobData(jobId)

						p:resolve(true)
					else
						p:resolve(false)
					end
				end)

				local res = Citizen.Await(p)
				return {
					success = res,
					code = "ERROR",
				}
			else
				return {
					success = false,
					code = "MISSING_JOB",
				}
			end
		end,
		Get = function(self, jobId, key)
			if key and JOB_CACHE[jobId] and JOB_CACHE[jobId].Data then
				return JOB_CACHE[jobId].Data[key]
			end
		end,
	},
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
	exports['mythic-base']:RegisterComponent('Jobs', _JOBS)
end)