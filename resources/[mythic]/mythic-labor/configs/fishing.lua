function GetFishingLootForZone(toolUsed, zone)
    local usingNet = toolUsed == "net"

    -- Chance, Item, Require Difficulty, Check Correct Bait?, Require a Net?

    if zone == 1 then
        return {
            {35, { name = "fishing_grasscarp", max = (usingNet and 5 or 1) }, 1},
            {30, { name = "fishing_chub", max = (usingNet and 6 or 1) }, 1, true},
            {15, { name = "fishing_bike", max = 1 }, 2},
            {10, { name = "fishing_boot", max = 1 }, 3},
            {5, { name = "fishing_chest", max = 1 }, 4},
        }
    elseif zone == 2 or zone == 3 then
        return {
            {35, { name = "fishing_grasscarp", max = 1 }, 1},
            {30, { name = "fishing_chub", max = 1 }, 1},
            {20, { name = "fishing_rainbowtrout", max = 1 }, 3},
            {10, { name = "fishing_boot", max = 2 }, 3},
            --{5, { name = "fishing_chest", max = 1 }, 4},
        }
    elseif zone == 4 then
        return {
            {35, { name = "fishing_kelp", max = (usingNet and 4 or 1) }, 2},
            {20, { name = "fishing_bike", max = 1 }, 2},
            {15, { name = "fishing_boot", max = 1 }, 3},
            {1, { name = "fishing_chest", max = 1 }, 4},
        }
    elseif zone == 5 then
        return {
            {35, { name = "fishing_kelp", max = (usingNet and 4 or 1) }, 1},
            {25, { name = "fishing_bass", max = (usingNet and 5 or 1) }, 1},
            {18, { name = "fishing_rockfish", max = (usingNet and 6 or 1) }, 2, true},
            {12, { name = "fishing_seaweed", max = 5 }, 1},
            {9, { name = "fishing_boot", max = 1 }, 3},
            {1, { name = "fishing_chest", max = 1 }, 4},
        }
    elseif zone == 6 then
        return {
            {35, { name = "fishing_kelp", max = (usingNet and 4 or 1) }, 1},
            {30, { name = "fishing_bass", max = (usingNet and 5 or 1) }, 1},
            {26, { name = "fishing_rockfish", max = (usingNet and 6 or 1) }, 2, true},
            {20, { name = "fishing_tuna", max = (usingNet and 3 or 1) }, 3, true},
            {18, { name = "fishing_lobster", max = (usingNet and 5 or 1) }, 3, true, true},
            {4, { name = "fishing_seaweed", max = 5 }, 1},
            {10, { name = "fishing_boot", max = 1 }, 3},
            {5, { name = "fishing_chest", max = 1 }, 4},
        }
    elseif zone == 7 then
        -- Ultra Deep Water Zones - Not Implemented Yet
        return {}
    end
end

FishingConfig = {
    FishItems = { -- Items That Are *Actually* Fish
        .fishing_rainbowtrout,
        .fishing_chub,
        .fishing_grasscarp,
        .fishing_kelp,
        .fishing_bass,
        .fishing_rockfish,
        .fishing_lobster,
        .fishing_tuna,
        .fishing_bluefintuna,
        .fishing_whale,
        .fishing_dolphin,
        .fishing_shark,
    }
}