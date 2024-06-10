local counter = 0
local _billboardDUIs = {}

function CreateBillboardDUI(url, width, height)
    width = width or 512
    height = height or 512

    counter += 1

    local dictName = string.format("billboard-%s-dict", counter)
    local txtName = string.format("billboard-%s-txt", counter)

    local duiObject = CreateDui(url, width, height)
    local dictObject = CreateRuntimeTxd(dictName)
    local duiHandle = GetDuiHandle(duiObject)

    local txdObject = CreateRuntimeTextureFromDuiHandle(dictObject, txtName, duiHandle)

    _billboardDUIs[counter] = {
        duiWidth = width,
        duiHeight = height,
        duiObject = duiObject,
        duiHandle = duiHandle,
        dictObject = dictObject,
        txtObject = txdObject,
    }

    return {
        id = counter,
        dictionary = dictName,
        texture = txtName,
    }
end

function UpdateBillboardDUI(id, url)
    if not _billboardDUIs[id] then
        return
    end

    SetDuiUrl(_billboardDUIs[id].duiObject, url)
end

function ReleaseBillboardDUI(id)
    if not _billboardDUIs[id] then
        return
    end

    DestroyDui(_billboardDUIs[id].duiObject)
    _billboardDUIs[id] = nil
end