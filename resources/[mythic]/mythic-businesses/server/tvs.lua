local _started = false
AddEventHandler('Businesses:Server:Startup', function()
    if not _started then
        _started = true
        for k, v in pairs(_tvData) do
            if v?.default then
                GlobalState[string.format('TVsLink:%s', k)] = v.default
            end
        end

        Database.Game:find({
            collection = 'business_tvs',
            query = {}
        }, function(success, results)
            if success and #results > 0 then
                for k, v in pairs(results) do
                    if v.tv and _tvData[v.tv] then
                        GlobalState[string.format('TVsLink:%s', v.tv)] = v.link
                    end
                end
            end
        end)
    end

    Callbacks:RegisterServerCallback('TVs:UpdateTVLink', function(source, data, cb)
        if data.tv and data.link then
            local tv = _tvData[data.tv]
            if tv then
                local res = SetBusinessTVLink(data.tv, data.link)
                if res then
                    GlobalState[string.format('TVsLink:%s', data.tv)] = data.link
                    TriggerClientEvent('TVs:Client:Update', -1, data.tv)
                end

                cb(res)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

function SetBusinessTVLink(tvId, link)
    local p = promise.new()

    Database.Game:findOneAndUpdate({
        collection = 'business_tvs',
        query = {
            tv = tvId,
        },
        update = {
            ['$set'] = {
                link = link,
            },
        },
        options = {
            returnDocument = 'after',
            upsert = true,
        }
    }, function(success, results)
        if success and results then
            p:resolve(results.link)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end