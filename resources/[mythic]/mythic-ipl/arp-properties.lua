AddEventHandler('Interiors:Enter', function(coords, pId, pInt, pData)
    if pInt and pInt == 69 then
        if pData and pData.style and FinanceOffice3.Style.Theme[pData.style] ~= nil then
            FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme[pData.style], true)
        else
            FinanceOffice3.Style.Set(FinanceOffice3.Style.Theme.conservative, true)
        end

        if pData and pData.signText then
            FinanceOrganization.Name.Set(pData.signText, pData.signStyle or 3, pData.signColor or 0, pData.signFont or 7)
            FinanceOrganization.Office.Enable(true)
        end
    end
end)

AddEventHandler('Interiors:Exit', function()
    FinanceOrganization.Office.Enable(false)
end)