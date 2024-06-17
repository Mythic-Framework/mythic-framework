_sceneFonts = {
    { name = 'Chalet', font = 0 },
    { name = "Sign Painter", font = 1 },
    { name = 'Chalet Comprimé', font = 4 },
	{ name = "Pricedown", font = 7 },
}

_streamedFonts = {
    { file = 'ArialNarrow', name = 'Arial Narrow' },
    { file = 'Lato', name = 'Lato' },
    { file = 'Inkfree', name = 'Inkfree' },
    { file = 'Kid', name = 'Kid' },
    { file = 'Strawberry', name = 'Strawberry' },
    { file = 'PaperDaisy', name = 'Paper Daisy' },
    { file = 'WriteMeASong', name = 'Write Me A Song' },
    { file = 'DirtyLizard', name = 'Dirty Lizard' },
    { file = 'Maren', name = 'Maren' },
    { file = 'HappyDay', name = 'Happy Day' },
    { file = 'ImpactLabel', name = 'Impact Label' },
    { file = 'Easter', name = 'Easter' },
}

function RegisterStreamedFonts()
    for k, v in ipairs(_streamedFonts) do
        RegisterFontFile(v.file)
        local font = RegisterFontId(v.name)
        table.insert(_sceneFonts, {
            name = v.name,
            font = font,
        })
    end
end

CreateThread(function()
    RegisterStreamedFonts()
end)