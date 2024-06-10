function UpdateCharacterCasinoStats(source, statType, isWin, amount)
    local plyr = Fetch:Source(source)
    if plyr then
        local char = plyr:GetData("Character")
        if char then
            local p = promise.new()

            local update = {
                ["$push"] = {
                    [statType] = {
                        Win = isWin,
                        Amount = amount,
                    },
                },
            }

            if isWin then
                update["$inc"] = {
                    TotalAmountWon = amount,
                    [string.format("AmountWon.%s", statType)] = amount,
                }
            else
                update["$inc"] = {
                    TotalAmountLost = amount,
                    [string.format("AmountLost.%s", statType)] = amount,
                }
            end

            Database.Game:findOneAndUpdate({
                collection = "casino_statistics",
                query = {
                    SID = char:GetData("SID"),
                },
                update = update,
                options = {
                    returnDocument = "after",
                    upsert = true,
                }
            }, function(success, results)
                if success and results then
                    p:resolve(results)
                else
                    p:resolve(false)
                end
            end)

            local res = Citizen.Await(p)
            return res
        end
    end
    return false
end

function SaveCasinoBigWin(source, machine, prize, data)
    local plyr = Fetch:Source(source)
    if plyr then
        local char = plyr:GetData("Character")
        if char then
            local p = promise.new()

            Database.Game:insertOne({
                collection = 'casino_bigwins',
                document = {
                    Type = machine,
                    Time = os.time(),
                    Winner = {
                        SID = char:GetData("SID"),
                        First = char:GetData("First"),
                        Last = char:GetData("Last"),
                        ID = char:GetData("ID"),
                    },
                    Prize = prize,
                    MetaData = data,
                }
            }, function(success, result)
                p:resolve(success)
            end)

            local res = Citizen.Await(p)
            return res
        end
    end
    return false
end