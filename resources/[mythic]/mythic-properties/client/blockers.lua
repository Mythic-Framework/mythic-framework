local _insideInterior = false
local _blockers = {
    {
        coords = vector3(349.053, -204.587, 54.226),
        p1 = vector2(346.63519287109, -200.91296386719),
        p2 = vector2(345.53726196289, -203.76834106445),
        minZ = 53.0,
        maxZ = 57.0
    },
    -- Mirror 2
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(943.62579345703, -655.19952392578),
        p2 = vector2(942.51214599609, -653.87237548828),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(941.8017578125, -645.68890380859),
        p2 = vector2(932.49884033203, -653.54602050781),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(932.61090087891, -655.38067626953),
        p2 = vector2(933.74969482422, -656.74346923828),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(937.03033447266, -657.6455078125),
        p2 = vector2(938.27624511719, -659.09643554688),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(943.63110351562, -655.19519042969),
        p2 = vector2(942.48895263672, -653.83093261719),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(940.136, -653.465, 58.437),
        p1 = vector2(944.03924560547, -649.83880615234),
        p2 = vector2(944.91619873047, -649.123046875),
        minZ = 53.0,
        maxZ = 60.0
    },
    -- Mirror Park 2
    {
        coords = vector3(979.538, -723.831, 58.027),
        p1 = vector2(977.49072265625, -730.64038085938),
        p2 = vector2(990.15765380859, -719.25970458984),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(979.538, -723.831, 58.027),
        p1 = vector2(984.90710449219, -714.44207763672),
        p2 = vector2(983.94708251953, -715.31298828125),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(979.538, -723.831, 58.027),
        p1 = vector2(981.47052001953, -716.17486572266),
        p2 = vector2(980.41186523438, -717.16046142578),
        minZ = 53.0,
        maxZ = 60.0
    },
    {
        coords = vector3(979.538, -723.831, 58.027),
        p1 = vector2(971.60223388672, -727.05413818359),
        p2 = vector2(975.34075927734, -731.21673583984),
        minZ = 53.0,
        maxZ = 60.0
    },
    -- Hello Michael
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-814.50085449219, 183.29626464844),
        p2 = vector2(-816.5009765625, 188.51890563965),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-815.43841552734, 189.77375793457),
        p2 = vector2(-813.9033203125, 190.35061645508),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-807.76861572266, 191.08142089844),
        p2 = vector2(-807.39227294922, 190.1004486084),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-795.74584960938, 187.7223815918),
        p2 = vector2(-795.19024658203, 186.29647827148),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-794.11688232422, 182.5799407959),
        p2 = vector2(-793.32989501953, 180.53860473633),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-794.49493408203, 177.96054077148),
        p2 = vector2(-796.56890869141, 177.15295410156),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-798.51159667969, 172.17864990234),
        p2 = vector2(-797.76226806641, 170.23408508301),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-798.17919921875, 169.23764038086),
        p2 = vector2(-801.04272460938, 168.09976196289),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-802.66558837891, 167.45399475098),
        p2 = vector2(-801.88702392578, 167.74855041504),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-816.32092285156, 182.29377746582),
        p2 = vector2(-817.78930664062, 181.6508026123),
        minZ = 70.0,
        maxZ = 80.0
    },
    {
        coords = vector3(-814.612, 178.734, 72.159),
        p1 = vector2(-807.63299560547, 185.58586120605),
        p2 = vector2(-806.33984375, 186.0139465332),
        minZ = 75.0,
        maxZ = 80.0
    },
    -- 3 Story Boy
    {
        coords = vector3(373.546, 423.625, 145.908),
        p1 = vector2(376.47918701172, 401.01037597656),
        p2 = vector2(366.88241577148, 403.37631225586),
        minZ = 120.0,
        maxZ = 160.0
    },
    {
        coords = vector3(373.546, 423.625, 145.908),
        p1 = vector2(377.09399414062, 402.09707641602),
        p2 = vector2(379.6005859375, 412.19970703125),
        minZ = 120.0,
        maxZ = 160.0
    },
    -- Franklin
    {
        coords = vector3(7.217, 537.873, 176.028),
        p1 = vector2(15.154541015625, 527.73431396484),
        p2 = vector2(-0.57341927289963, 520.34680175781),
        minZ = 130.0,
        maxZ = 190.0
    },
    {
        coords = vector3(7.217, 537.873, 176.028),
        p1 = vector2(-2.3236284255981, 519.51086425781),
        p2 = vector2(-6.3552937507629, 512.49761962891),
        minZ = 130.0,
        maxZ = 190.0
    },
    {
        coords = vector3(7.217, 537.873, 176.028),
        p1 = vector2(-6.4657545089722, 512.49249267578),
        p2 = vector2(-13.693461418152, 516.44049072266),
        minZ = 130.0,
        maxZ = 190.0
    },
    {
        coords = vector3(7.217, 537.873, 176.028),
        p1 = vector2(15.276026725769, 528.82739257812),
        p2 = vector2(12.118527412415, 535.84613037109),
        minZ = 130.0,
        maxZ = 190.0
    },
    {
        coords = vector3(7.217, 537.873, 176.028),
        p1 = vector2(14.573407173157, 536.96362304688),
        p2 = vector2(16.00700378418, 537.62829589844),
        minZ = 130.0,
        maxZ = 190.0
    },
    { -- Office
        coords = vector3(-1578.138, -563.817, 108.523),
        p1 = vector2(-1552.0751953125, -577.12133789062),
        p2 = vector2(-1573.2877197266, -592.53924560547),
        minZ = 115.0,
        maxZ = 100.0
    },

    -- Trevor Trailer
    {
        coords = vector3(1973.509, 3816.256, 33.430),
        p1 = vector2(1974.2683105469, 3816.1450195312),
        p2 = vector2(1979.7308349609, 3819.3195800781),
        minZ = 30.0,
        maxZ = 40.0
    },
    {
        coords = vector3(1973.509, 3816.256, 33.430),
        p1 = vector2(1979.8544921875, 3819.8588867188),
        p2 = vector2(1977.1495361328, 3824.5029296875),
        minZ = 30.0,
        maxZ = 40.0
    },
    {
        coords = vector3(1973.509, 3816.256, 33.430),
        p1 = vector2(1976.5753173828, 3823.2937011719),
        p2 = vector2(1974.9289550781, 3822.4089355469),
        minZ = 30.0,
        maxZ = 40.0
    },

    {
        coords = vector3(295.121, 128.782, 141.051),
        p1 = vector2(291.08529663086, 113.95417785645),
        p2 = vector2(281.86849975586, 117.32453918457),
        minZ = 130.0,
        maxZ = 150.0
    },
    {
        coords = vector3(294.839, 118.298, 134.356),
        p1 = vector2(292.65194702148, 114.42157745361),
        p2 = vector2(285.1139831543, 117.17125701904),
        minZ = 120.0,
        maxZ = 140.0
    },

    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-799.72918701172, 168.84197998047),
        p2 = vector2(-797.98608398438, 169.54194641113),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-797.9375, 170.39259338379),
        p2 = vector2(-798.57507324219, 171.96008300781),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-796.5869140625, 177.22221374512),
        p2 = vector2(-794.505859375, 177.99937438965),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-795.96423339844, 187.77326965332),
        p2 = vector2(-794.92749023438, 185.03967285156),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-814.41522216797, 190.07946777344),
        p2 = vector2(-815.09857177734, 189.67625427246),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-816.21643066406, 188.42631530762),
        p2 = vector2(-814.37951660156, 182.69486999512),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-815.932, 178.175, -77.174),
        p1 = vector2(-807.90270996094, 190.90559387207),
        p2 = vector2(-807.27777099609, 189.75128173828),
        minZ = -85.0,
        maxZ = -40.0
    },
    {
        coords = vector3(-1290.959, 449.157, 39.240),
        p1 = vector2(-1276.5500488281, 427.65747070312),
        p2 = vector2(-1297.9243164062, 428.09921264648),
        minZ = 60.0,
        maxZ = 0.0
    },
    {
        coords = vector3(-1290.959, 449.157, 39.240),
        p1 = vector2(-1280.9681396484, 428.50765991211),
        p2 = vector2(-1281.0819091797, 452.26037597656),
        minZ = 60.0,
        maxZ = 0.0
    },
    -- T3
    {
        coords = vector3(327.796, 101.326, -98.970),
        p1 = vector2(326.70697021484, 99.539443969727),
        p2 = vector2(318.65368652344, 102.04237365723),
        minZ = -110.0,
        maxZ = -80.0
    },
    {
        coords = vector3(327.796, 101.326, -98.970),
        p1 = vector2(327.94891357422, 97.719985961914),
        p2 = vector2(330.4216003418, 106.09580230713),
        minZ = -110.0,
        maxZ = -80.0
    },
    {
        coords = vector3(327.796, 101.326, -98.970),
        p1 = vector2(333.01956176758, 117.02586364746),
        p2 = vector2(315.83279418945, 123.31297302246),
        minZ = -110.0,
        maxZ = -80.0
    },
}

AddEventHandler('Interiors:Enter', function(coords)
    if not _insideInterior then
        _insideInterior = true

        -- Only Load Nearby Blockers Since They Aren't Going to move much in an interior
        local nearBlockers = {}
        for k, v in ipairs(_blockers) do
            if #(coords - v.coords) <= 50.0 then
                table.insert(nearBlockers, v)
            end
        end

        if #nearBlockers > 0 then
            CreateThread(function()
                while _insideInterior do
                    for k, v in ipairs(nearBlockers) do
                        _drawWall(v.p1, v.p2, v.minZ, v.maxZ, 30, 30, 30, 255)
                    end
                    Wait(3)
                end
            end)
        end
    end
end)

AddEventHandler('Interiors:Exit', function()
    _insideInterior = false
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    _insideInterior = false
end)

function _drawWall(p1, p2, minZ, maxZ, r, g, b, a)
    local bottomLeft = vector3(p1.x, p1.y, minZ)
    local topLeft = vector3(p1.x, p1.y, maxZ)
    local bottomRight = vector3(p2.x, p2.y, minZ)
    local topRight = vector3(p2.x, p2.y, maxZ)

    DrawPoly(bottomLeft,topLeft,bottomRight,r,g,b,a)
    DrawPoly(topLeft,topRight,bottomRight,r,g,b,a)
    DrawPoly(bottomRight,topRight,topLeft,r,g,b,a)
    DrawPoly(bottomRight,topLeft,bottomLeft,r,g,b,a)
end