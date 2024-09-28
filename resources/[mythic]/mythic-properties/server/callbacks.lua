local _selling = {}
local _pendingLoanAccept = {}

local govCut = 5
local commissionCut = 5
local companyCut = 10

local _phoneApp = {
    color = '#136231',
    label = 'Dynasty 8',
    icon = 'house',
}

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Properties:RingDoorbell", function(source, data, cb)
		TriggerClientEvent("Properties:Client:Doorbell", -1, data)
		cb()
	end)

	Callbacks:RegisterServerCallback("Properties:RequestAgent", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data]
		if property ~= nil then
			for k, v in pairs(Fetch:All()) do
				local c = v:GetData("Character")
				if c ~= nil then
					if Jobs.Permissions:HasPermissionInJob(v:GetData("Source"), "realestate", "JOB_SELL") then
						Phone.Email:Send(
							v:GetData("Source"),
							char:GetData("Alias").email,
							os.time() * 1e3,
							"Requesting Agent",
							string.format(
								"Hello,<br /><br />I am interested in buying %s and would like to view the property.<br /><br />You can reach me at %s.<br /><br />Thanks!<br />- %s %s",
								property.label,
								char:GetData("Phone"),
								char:GetData("First"),
								char:GetData("Last")
							),
							{
								location = {
									x = property.location.front.x,
									y = property.location.front.y,
									z = property.location.front.z,
								},
								expires = (os.time() + (60 * 20)) * 1000,
							}
						)
					end
				end
			end
			cb(true)
			return
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Properties:EditProperty", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.property]
		if property ~= nil and Player(source).state.onDuty == "realestate" and data.location then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			if data.location == "garage" then
				local pos = {
					x = coords.x + 0.0,
					y = coords.y + 0.0,
					z = coords.z + 0.0,
					h = heading + 0.0
				}

				cb(Properties.Manage:AddGarage(data.property, pos))
			elseif data.location == "backdoor" then
				local pos = {
					x = coords.x + 0.0,
					y = coords.y + 0.0,
					z = coords.z - 1.2,
					h = heading + 0.0
				}

				cb(Properties.Manage:AddBackdoor(data.property, pos))
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:SpawnInside", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.id]
		if property ~= nil and char then
			local pInt = property.upgrades?.interior

			local routeId = Routing:RequestRouteId("Properties:" .. data.id, false)
			Routing:AddPlayerToRoute(source, routeId)
			GlobalState[string.format("%s:Property", source)] = data.id
			Middleware:TriggerEvent("Properties:Enter", source, data.id)

			if not _insideProperties[property.id] then
				_insideProperties[property.id] = {}
			end

			_insideProperties[property.id][source] = char:GetData("SID")

			local furniture = GetPropertyFurniture(property.id, pInt)

			TriggerClientEvent("Properties:Client:InnerStuff", source, property, pInt, furniture)

			Player(source).state.tpLocation = property?.location?.front
		end
		cb(true)
	end)

	Callbacks:RegisterServerCallback("Properties:EnterProperty", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data]

		if
			(property.keys ~= nil and property.keys[char:GetData("ID")])
			or (not property.sold and Jobs.Permissions:HasPermissionInJob(source, "realestate", "JOB_DOORS"))
			or not property.locked or Police:IsInBreach(source, "property", data)
		then
			local pInt = property.upgrades?.interior

			Pwnzor.Players:TempPosIgnore(source)
			local routeId = Routing:RequestRouteId("Properties:" .. data, false)
			Routing:AddPlayerToRoute(source, routeId)
			GlobalState[string.format("%s:Property", source)] = data
			Middleware:TriggerEvent("Properties:Enter", source, data)

			if not _insideProperties[property.id] then
				_insideProperties[property.id] = {}
			end

			_insideProperties[property.id][source] = char:GetData("SID")
			
			Player(source).state.tpLocation = property?.location?.front

			local furniture = GetPropertyFurniture(property.id, pInt)
			
			cb(true, property.id, pInt)
			TriggerClientEvent("Properties:Client:InnerStuff", source, property, pInt, furniture)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:ExitProperty", function(source, data, cb)
		local property = GlobalState[string.format("%s:Property", source)]

		Pwnzor.Players:TempPosIgnore(source)
		Middleware:TriggerEvent("Properties:Exit", source, property)
		Routing:RoutePlayerToGlobalRoute(source)
		GlobalState[string.format("%s:Property", source)] = nil

		if _insideProperties[property] then
			_insideProperties[property][source] = nil
		end

		Player(source).state.tpLocation = nil

		cb(property)
	end)

	Callbacks:RegisterServerCallback("Properties:ChangeLock", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.id]

		if
			(property.keys ~= nil and property.keys[char:GetData("ID")])
			or (not property.sold and Jobs.Permissions:HasPermissionInJob(source, "realestate", "JOB_DOORS"))
		then
			cb(Properties.Utils:SetLock(data.id, data.state))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:Validate", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.id]

		if data.type == "closet" then
			cb(property.keys and property.keys[char:GetData("ID")] ~= nil)
		elseif data.type == "logout" then
			cb(property.keys and property.keys[char:GetData("ID")] ~= nil)
		elseif data.type == "stash" then
			if property.keys and property.keys[char:GetData("ID")] ~= nil and property.id or Police:IsInBreach(source, "property", property.id, true) then
				local interior = PropertyInteriors[property.upgrades.interior]
				local invType = 1000

				local capacity = false
				local slots = false

				if interior.inventoryOverride then
					invType = interior.inventoryOverride
				else
					local level = property.upgrades?.storage or 1
					if PropertyStorage[property.type] and PropertyStorage[property.type][level] then
						local storage = PropertyStorage[property.type][level]

						capacity = storage.capacity
						slots = storage.slots
					end
				end

				local invId = string.format("Property:%s", property.id)

				Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
					invType = invType,
					owner = invId,
				}, function()
					Inventory:OpenSecondary(
						source,
						invType,
						invId,
						false,
						false,
						false,
						property.label,
						slots,
						capacity
					)
				end)
			end

			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:Upgrade", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.id]

		if char and property.keys and property.keys[char:GetData("ID")] ~= nil and (property.keys[char:GetData("ID")].Permissions?.upgrade or property.keys[char:GetData("ID")].Owner) then
			local propertyUpgrades = PropertyUpgrades[property.type]
			if propertyUpgrades then
				local thisUpgrade = propertyUpgrades[data.upgrade]
				if thisUpgrade then
					local currentLevel = Properties.Upgrades:Get(property.id, data.upgrade)
					local nextLevel = thisUpgrade.levels[currentLevel + 1]
					local p = Banking.Accounts:GetPersonal(char:GetData("SID"))
					if nextLevel and nextLevel.price and p and p.Account then
						local success = Banking.Balance:Charge(p.Account, nextLevel.price, {
							type = "bill",
							title = "Property Upgrade",
							description = string.format("Upgrade %s to Level %s on %s", thisUpgrade.name, currentLevel + 1, property.label),
							data = {
								property = property.id,
								upgrade = data.upgrade,
								level = currentLevel + 1,
							}
						})

						if success then
							local upgraded = Properties.Upgrades:Set(property.id, data.upgrade, currentLevel + 1)
							if not upgraded then
								Logger:Error("Properties", string.format("SID %s Failed to Upgrade Property %s After Payment (%s - Level %s)", char:GetData("SID"), property.id, thisUpgrade.name, currentLevel + 1))
							end

							cb(upgraded)
							return
						end
					end
				end
			end
		end

		cb(false)
	end)

	local interiorChangeCost = 50000

	Callbacks:RegisterServerCallback("Properties:ChangeInterior", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = _properties[data.id]

		if char and data.int and property.keys and property.keys[char:GetData("ID")] ~= nil and (property.keys[char:GetData("ID")].Permissions?.upgrade or property.keys[char:GetData("ID")].Owner) then
			local oldInterior = PropertyInteriors[property?.upgrades?.interior]
			local newInterior = PropertyInteriors[data.int]
			local p = Banking.Accounts:GetPersonal(char:GetData("SID"))

			if p and p.Account and oldInterior and newInterior and newInterior.type == property.type then
				local price = 0
				if oldInterior.price > newInterior.price then
					price = interiorChangeCost
				else
					price = interiorChangeCost + math.floor((newInterior.price or 0) - (oldInterior.price or 0))

					if price < 0 then
						price = 0
					end
				end

				local success = Banking.Balance:Charge(p.Account, price, {
					type = "bill",
					title = "Property Upgrade",
					description = string.format("Upgrade Interior to %s on %s", (newInterior.info?.name or data.int), property.label),
					data = {
						property = property.id,
						upgrade = "interior",
						level = data.int,
					}
				})

				if success then
					local upgraded = Properties.Upgrades:SetInterior(property.id, data.int)
					if not upgraded then
						Logger:Error("Properties", string.format("SID %s Failed to Upgrade Property %s After Payment (Interior - %s)", char:GetData("SID"), property.id, data.int))
					else
						DeletePropertyFurniture(property.id)
						Properties:ForceEveryoneLeave(property.id)
					end

					cb(upgraded)
					return
				end
			end
		end

		cb(false)
	end)

	Callbacks:RegisterServerCallback("Properties:Dyn8:Search", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			local qry = {
				label = {
					["$regex"] = data,
					["$options"] = "i",
				},
				sold = false,
			}

			if Player(source).state.onDuty == 'realestate' then
				qry = {
					label = {
						["$regex"] = data,
						["$options"] = "i",
					},
				}
			end

			Database.Game:aggregate({
				collection = "properties",
				aggregate = {
					{
						["$match"] = {
							label = {
								["$regex"] = data,
								["$options"] = "i",
							},
						},
					},
					{
						['$limit'] = 80
					},
				},
			}, function(success, results)
				if not success then
					cb(false)
					return
				end
				cb(results)
			end)
		else
			cb(false)
		end
	end)

	-- Hello

	Callbacks:RegisterServerCallback("Properties:Dyn8:Sell", function(source, data, cb)
		local char = Fetch:Source(source):GetData('Character')
		local prop = _properties[data.property]
		if Player(source).state.onDuty == 'realestate' then
			if prop ~= nil and not prop.sold and char then
				if _selling[data.property] == nil then
					local target = Fetch:SID(tonumber(data.target))
					if target ~= nil then
						local targetChar = target:GetData('Character')
						if targetChar then
							_selling[data.property] = data.target

							if data.loan and data.time and data.deposit then
								local loanData = Loans:GetAllowedLoanAmount(targetChar:GetData('SID'), 'property')
								local hasLoans = Loans:GetPlayerLoans(targetChar:GetData('SID'), 'property')
								local defaultInterestRate = Loans:GetDefaultInterestRate()

								if #hasLoans <= 1 then
									if loanData?.maxBorrowable and loanData.maxBorrowable > 0 and defaultInterestRate then
										local downPaymentPercent, loanWeeks = math.tointeger(data.deposit), math.tointeger(data.time)
										if downPaymentPercent and loanWeeks then
											local downPayment = Utils:Round(prop.price * (downPaymentPercent / 100), 0)
											local salePriceAfterDown = prop.price - downPayment
											local afterInterest = Utils:Round(salePriceAfterDown * (1 + (defaultInterestRate / 100)), 0)
											local perWeek = Utils:Round(afterInterest / loanWeeks, 0)

											if loanData.maxBorrowable >= salePriceAfterDown then
												SendPendingLoanEmail({
													SID = targetChar:GetData('SID'),
													First = targetChar:GetData('First'),
													Last = targetChar:GetData('Last'),
													Source = targetChar:GetData('Source'),
												}, prop.label, downPaymentPercent, downPayment, loanWeeks, perWeek, salePriceAfterDown, function()
													Billing:Create(targetChar:GetData('Source'), 'Dynasty 8', downPayment, string.format('Property Downpayment for %s', prop.label), function(wasPayed, withAccount)
														if wasPayed then
															local loanSuccess = Loans:CreatePropertyLoan(targetChar:GetData('Source'), prop.id, prop.price, downPayment, loanWeeks)
															if loanSuccess then
																Properties.Commerce:Buy(prop.id, {
																	Char = targetChar:GetData("ID"),
																	SID = targetChar:GetData("SID"),
																	First = targetChar:GetData("First"),
																	Last = targetChar:GetData("Last"),
																	Owner = true,
																})

																SendCompletedLoanSaleEmail({
																	Source = targetChar:GetData("Source"),
																	SID = targetChar:GetData("SID"),
																	First = targetChar:GetData("First"),
																	Last = targetChar:GetData("Last"),
																}, prop.label, downPaymentPercent, downPayment, loanWeeks, perWeek, salePriceAfterDown)

																-- Send Realtor Notification
																Phone.Notification:Add(source, "Property Sale Successful", string.format("(Loan Sale) %s was sold to %s %s.", prop.label, targetChar:GetData('First'), targetChar:GetData('Last')), os.time() * 1000, 7000, _phoneApp, {})

																SendPropertyProfits('Loan Sale', prop.price, prop.label, char:GetData('BankAccount'), withAccount, {
																	SID = targetChar:GetData("SID"),
																	First = targetChar:GetData("First"),
																	Last = targetChar:GetData("Last"),
																})
															end
														else
															Phone.Notification:Add(source, "Property Sale Failed", string.format("(Loan Sale) The downpayment failed when trying to sell %s to %s %s.", prop.label, targetChar:GetData('First'), targetChar:GetData('Last')), os.time() * 1000, 7000, _phoneApp, {})
														end
	
														_selling[data.property] = nil
													end)
												end)
												cb({ success = true, message = 'Loan Offer Sent' })
											else
												cb({ success = false, message = 'Person Doesn\'t Qualify for Loan' })
											end
										end
									else
										cb({ success = false, message = 'Person Doesn\'t Qualify for Loan' })
									end
								else
									cb({ success = false, message = 'Person Doesn\'t Qualify for Loan' })
								end
							else
								cb({ success = true, message = 'Sale Offer Sent' })

								Billing:Create(targetChar:GetData('Source'), 'Dynasty 8', prop.price, 'Purchase of ' .. prop.label, function(wasPayed, withAccount)
									if wasPayed then
										Properties.Commerce:Buy(prop.id, {
											Char = targetChar:GetData("ID"),
											SID = targetChar:GetData("SID"),
											First = targetChar:GetData("First"),
											Last = targetChar:GetData("Last"),
											Owner = true,
										})
	
										-- Send Purchasee Confirmation
										SendCompletedCashSaleEmail({
											Source = targetChar:GetData("Source"),
											SID = targetChar:GetData("SID"),
											First = targetChar:GetData("First"),
											Last = targetChar:GetData("Last"),
										}, prop.label, prop.price)
	
										-- Send Realtor Confirmation
										Phone.Notification:Add(source, "Property Sale Successful", string.format("(Cash Sale) %s was sold to %s %s.", prop.label, targetChar:GetData('First'), targetChar:GetData('Last')), os.time() * 1000, 7000, _phoneApp, {})
	
										SendPropertyProfits('Cash Sale', prop.price, prop.label, char:GetData('BankAccount'), withAccount, {
											SID = targetChar:GetData("SID"),
											First = targetChar:GetData("First"),
											Last = targetChar:GetData("Last"),
										})

										if prop.price >= 250000 then
											local creditIncrease = math.floor(prop.price / 1500)
											if creditIncrease > 300 then
												creditIncrease = 300
											end

											Loans.Credit:Increase(targetChar:GetData('SID'), creditIncrease)
										end
									else
										Phone.Notification:Add(source, "Property Sale Failed", string.format("(Cash Sale) The bank transfer failed when trying to sell %s to %s %s.", prop.label, targetChar:GetData('First'), targetChar:GetData('Last')), os.time() * 1000, 7000, _phoneApp, {})
									end
									_selling[data.property] = nil
								end)
							end
	
							Citizen.SetTimeout(5 * (60 * 1000), function()
								if _selling[data.property] then
									_selling[data.property] = nil
								end
							end)
						else
							cb({ success = false, message = 'Could Not Find State ID' })
						end
					else
						cb({ success = false, message = 'Could Not Find State ID' })
					end
				else
					cb({ success = false, message = 'Property Already Being Sold' })
				end
			else
				cb({ success = false })
			end
		else
			cb({ success = false })
		end
	end)

	Callbacks:RegisterServerCallback("Properties:Dyn8:CheckCredit", function(source, data, cb)
		local target = Fetch:SID(tonumber(data?.target))
		if target ~= nil then
			local targetChar = target:GetData('Character')
			if targetChar then
				local creditCheck = Loans:GetAllowedLoanAmount(targetChar:GetData('SID'), 'property')

				cb({
					SID = targetChar:GetData('SID'),
					price = creditCheck.maxBorrowable,
					score = creditCheck.creditScore,
					name = string.format('%s %s', targetChar:GetData('First'), targetChar:GetData('Last'))
				})
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:Dyn8:Transfer", function(source, data, cb)
		local char = Fetch:Source(source):GetData('Character')
		local prop = _properties[data.property]
		if Player(source).state.onDuty == 'realestate' then
			if prop ~= nil and prop.sold and char then
				local owner = Fetch:SID(prop.owner.SID)
				local newOwner = Fetch:SID(tonumber(data.target))

				if owner and newOwner then
					local ownerChar = owner:GetData("Character")
					local newOwnerChar = newOwner:GetData("Character")

					if ownerChar and newOwnerChar then
						if newOwner:GetData("SID") ~= char:GetData("SID") then
							SendPendingPropertyTransfer(ownerChar:GetData("Source"), true, {
								Property = prop.label,
								First = newOwnerChar:GetData("First"),
								Last = newOwnerChar:GetData("Last"),
								SID = newOwnerChar:GetData("SID"),
							}, function(accepted, stateId)
								if accepted and stateId == ownerChar:GetData("SID") then
									SendPendingPropertyTransfer(newOwnerChar:GetData("Source"), false, {
										Property = prop.label,
										First = ownerChar:GetData("First"),
										Last = ownerChar:GetData("Last"),
										SID = ownerChar:GetData("SID"),
									}, function(accepted, stateId)
										if accepted and stateId == newOwnerChar:GetData("SID") then
											if Properties.Commerce:Buy(prop.id, {
												Char = newOwnerChar:GetData("ID"),
												SID = newOwnerChar:GetData("SID"),
												First = newOwnerChar:GetData("First"),
												Last = newOwnerChar:GetData("Last"),
												Owner = true,
											}) then
												Phone.Notification:Add(source, "Property Transfer Successful", "The property transfer was successful.", os.time() * 1000, 7000, _phoneApp, {})
	
												Logger:Warn(
													"Properties", 
													string.format(
														"Property %s (%s) Transfered From %s %s (%s) to %s %s (%s) By %s %s (%s)",
														prop.label,
														prop.id,
														ownerChar:GetData("First"),
														ownerChar:GetData("Last"),
														ownerChar:GetData("SID"),
														newOwnerChar:GetData("First"),
														newOwnerChar:GetData("Last"),
														newOwnerChar:GetData("SID"),
														char:GetData("First"),
														char:GetData("Last"),
														char:GetData("SID")
													)
												)
											else
												Phone.Notification:Add(source, "Property Transfer Failed", "The property transfer failed.", os.time() * 1000, 7000, _phoneApp, {})
											end
										else
											Phone.Notification:Add(source, "Property Transfer Failed", "The new owner declined the transfer.", os.time() * 1000, 7000, _phoneApp, {})
										end
									end)
								else
									Phone.Notification:Add(source, "Property Transfer Failed", "The owner declined the transfer.", os.time() * 1000, 7000, _phoneApp, {})
								end
							end)

							cb({ success = true })
						else
							cb({ success = false, message = 'Cannot Transfer to Yourself' })
						end
					else
						cb({ success = false, message = 'Both the Owner & New Owner Need to Be Present' })
					end
				else
					cb({ success = false, message = 'Both the Owner & New Owner Need to Be Present' })
				end
			else
				cb({ success = false })
			end
		else
			cb({ success = false })
		end
	end)
end

local _pendingLoanAccept = {}

function SendPendingLoanEmail(charData, propertyLabel, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining, cb)
    if not _pendingLoanAccept[charData.SID] then
        _pendingLoanAccept[charData.SID] = cb
        Phone.Email:Send(
            charData.Source,
            'loans@dynasty8.com',
            os.time() * 1000,
            string.format('Property Loan - %s', propertyLabel),
            string.format(
                [[
                    Dear %s %s, 
                    Thank you for applying for a property loan for %s. The terms of this loan are set out below.<br><br>
                    Deposit: <b>$%s</b> (%s%%)<br>
                    Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                    Loan Length: <b>%s Weeks</b><br>
                    Weekly Payments: <b>$%s</b><br><br>

                    Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                    It may also lead to the eventual foreclosure of your property by the State of San Andreas.
                    <br><br>
                    If you agree with these terms, please click the link attached above to begin the loan acceptance process.
                    <br><br>
                    Thanks, Dynasty 8 Real Estate
                ]],
                charData.First,
                charData.Last,
                propertyLabel,
                formatNumberToCurrency(math.floor(downPayment)),
                downPaymentPercent,
                formatNumberToCurrency(math.floor(remaining)),
                loanWeeks,
                formatNumberToCurrency(math.floor(weeklyPayments))
            ),
            {
                hyperlink = {
                    event = 'RealEstate:Server:AcceptLoan',
                },
                expires = (os.time() + (60 * 5)) * 1000,
            }
        )

        Citizen.SetTimeout(60000 * 5, function()
            _pendingLoanAccept[charData.SID] = nil
        end)
    else
        cb(false, 1)
    end
end

RegisterNetEvent('RealEstate:Server:AcceptLoan', function(_, email)
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    if char then
        Phone.Email:Delete(char:GetData('ID'), email)
        local stateId = char:GetData('SID')

        if _pendingLoanAccept[stateId] then
            _pendingLoanAccept[stateId]()
            _pendingLoanAccept[stateId] = nil
        end
    end
end)

function SendCompletedLoanSaleEmail(charData, propertyLabel, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining)
    Phone.Email:Send(
        charData.Source,
        'loans@dynasty8.com',
        os.time() * 1000,
        string.format('Property Loan - %s', propertyLabel),
        string.format(
            [[
                Dear %s %s, 
                Thank you for taking out a property loan for %s, it has been a pleasure doing business with you.
                <br><br>
                
                The terms of this loan are set out below.<br><br>
                Deposit: <b>$%s</b> (%s%%)<br>
                Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                Loan Length: <b>%s Weeks</b><br>
                Weekly Payments: <b>$%s</b><br><br>

                Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                It may also lead to the eventual foreclosure of your property by the State of San Andreas.
                <br><br>
                Thanks, Dynasty 8 Real Estate
            ]],
            charData.First,
            charData.Last,
            propertyLabel,
            formatNumberToCurrency(math.floor(downPayment)),
            downPaymentPercent,
            formatNumberToCurrency(math.floor(remaining)),
            loanWeeks,
            formatNumberToCurrency(math.floor(weeklyPayments))
        )
    )
end

function SendCompletedCashSaleEmail(charData, propertyLabel, price)
    Phone.Email:Send(
        charData.Source,
        'sales@dynasty8.com',
        os.time() * 1000,
        string.format('Property Purchase - %s', propertyLabel),
        string.format(
            [[
                Dear %s %s,
                We thank you for completing your purchase of <b>%s</b> for $%s, it has been a pleasure doing business with you.
                The Property Address is <b>%s</b><br>
                <br><br>
                Thanks, Dynasty 8 Real Estate
            ]],
            charData.First,
            charData.Last,
            propertyLabel,
            formatNumberToCurrency(math.floor(price)),
			propertyLabel
        ),
        {}
    )
end

function SendPropertyProfits(type, propPrice, propLabel, playerBankAccount, payedAccount, buyerData)
	local dynastyAccount = Banking.Accounts:GetOrganization('realestate')
    if dynastyAccount then
        Banking.Balance:Deposit(dynastyAccount.Account, math.floor(propPrice * (companyCut / 100)), {
            type = 'transfer',
            title = 'Property Purchase',
            description = string.format('Property %s - %s to %s %s (SID %s)', type, propLabel, buyerData.First, buyerData.Last, buyerData.SID),
            data = {
				property = propLabel,
				buyer = buyerData,
			},
        })
    end

    Banking.Balance:Deposit(playerBankAccount, math.floor(propPrice * (commissionCut / 100)), {
        type = 'transfer',
		title = 'Dynasty 8 - Property Sale Commission',
		description = string.format('Property %s - %s to %s %s (SID %s)', type, propLabel, buyerData.First, buyerData.Last, buyerData.SID),
		data = {
			property = propLabel,
			buyer = buyerData,
		},
    })

	Banking.Balance:Deposit(100000, math.floor(propPrice * (govCut / 100)), {
        type = 'transfer',
		title = 'Property Sales Tax',
		description = string.format('Property %s - %s to %s %s (SID %s)', type, propLabel, buyerData.First, buyerData.Last, buyerData.SID),
		data = {
			property = propLabel,
			buyer = buyerData,
		},
    })
end

local _pendingTransferAccept = {}

function SendPendingPropertyTransfer(source, isOwner, data, cb)
	_pendingTransferAccept[source] = cb

	local description = string.format("Transfer of %s from %s %s (%s)", data.Property, data.First, data.Last, data.SID)
	if isOwner then
		description = string.format("Transfer of %s to %s %s (%s)", data.Property, data.First, data.Last, data.SID)
	end

	Phone.Notification:Add(source, "Property Transfer Request", description, os.time() * 1000, 15000, _phoneApp, {
        accept = "RealEstate:Client:AcceptTransfer",
        cancel = "RealEstate:Client:DenyTransfer",
    }, {
        data = data,
    })
end

RegisterNetEvent('RealEstate:Server:AcceptTransfer', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    if char then
        local stateId = char:GetData('SID')

        if _pendingTransferAccept[src] then
            _pendingTransferAccept[src](true, stateId)
            _pendingTransferAccept[src] = nil
        end
    end
end)

RegisterNetEvent('RealEstate:Server:DenyTransfer', function()
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    if char then
        local stateId = char:GetData('SID')

        if _pendingTransferAccept[src] then
            _pendingTransferAccept[src](false, stateId)
            _pendingTransferAccept[src] = nil
        end
    end
end)

function formatNumberToCurrency(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end