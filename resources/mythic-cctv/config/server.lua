Config = Config or {}

Config.AllowedJobs = {
    police = true,
    dgang = true,
}

--[[
    Camera Types;
        blurred
        medium
        low
        blackandwhite
        brown
]]
Config.Cameras = {
    {label = "24/7 - Davis Cam 1", x = -57.146, y = -1752.099, z = 31.661, r = { x = -11.275, y = 0.000, z = -109.257 }, canRotate = false, isOnline = true, quality = "low", group = "store1"},
    {label = "24/7 - Davis Cam 2", x = -43.986, y = -1747.982, z = 31.181, r = { x = -27.102, y = -0.000, z = -165.832 }, canRotate = false, isOnline = true, quality = "low", group = "store1"},
    
    {label = "24/7 - North Rockford Dr Cam 1", x = -1827.255, y = 784.642, z = 140.551, r = { x = -11.472, y = -0.000, z = -23.939 }, canRotate = false, isOnline = true, quality = "low", group = "store2"},
    {label = "24/7 - North Rockford Dr Cam 2", x = -1829.718, y = 798.282, z = 139.957, r = { x = -24.188, y = 0.000, z = -83.190 }, canRotate = false, isOnline = true, quality = "low", group = "store2"},
    
    {label = "24/7 - Little Seoul Cam 1", x = -717.920, y = -915.900, z = 21.451, r = { x = -12.061, y = 0.000, z = -67.729 }, canRotate = false, isOnline = true, quality = "low", group = "store3"},
    {label = "24/7 - Little Seoul Cam 2", x = -710.470, y = -904.150, z = 20.981, r = { x = -20.880, y = -0.000, z = -126.706 }, canRotate = false, isOnline = true, quality = "low", group = "store3"},
    
    {label = "24/7 - Grapeseed Cam 1", x = 1702.986, y = 4933.736, z = 44.283, r = { x = -11.690, y = 0.000, z = 170.551 }, canRotate = false, isOnline = true, quality = "low", group = "store4"},
    {label = "24/7 - Grapeseed Cam 2", x = 1708.339, y = 4921.038, z = 43.834, r = { x = -24.210, y = -0.000, z = 108.346 }, canRotate = false, isOnline = true, quality = "low", group = "store4"},
    
    {label = "24/7 - Grand Senora Cam 1", x = 2679.095, y = 3290.074, z = 57.490, r = { x = -15.259, y = 0.000, z = 173.866 }, canRotate = false, isOnline = true, quality = "low", group = "store5"},
    {label = "24/7 - Grand Senora Cam 2", x = 2673.430, y = 3289.540, z = 57.483, r = { x = -28.330, y = -0.000, z = 174.851 }, canRotate = false, isOnline = true, quality = "low", group = "store5"},
    
    {label = "24/7 - Mt Chiliad Cam 1", x = 1738.581, y = 6414.694, z = 37.296, r = { x = -18.586, y = -0.000, z = 85.439 }, canRotate = false, isOnline = true, quality = "low", group = "store6"},
    {label = "24/7 - Mt Chiliad Cam 2", x = 1731.334, y = 6423.424, z = 37.278, r = { x = -28.507, y = -0.000, z = -152.356 }, canRotate = false, isOnline = true, quality = "low", group = "store6"},
    
    {label = "24/7 - Harmony Cam 1", x = 539.920, y = 2665.774, z = 44.409, r = { x = -30.505, y = -0.000, z = -58.851 }, canRotate = false, isOnline = true, quality = "low", group = "store7"},
    {label = "24/7 - Harmony Cam 2", x = 543.704, y = 2661.591, z = 44.417, r = { x = -32.513, y = 0.000, z = -61.332 }, canRotate = false, isOnline = true, quality = "low", group = "store7"},
    
    {label = "24/7 - Sandy Shores Cam 1", x = 1966.472, y = 3748.642, z = 34.598, r = { x = -26.781, y = 0.000, z = 148.139 }, canRotate = false, isOnline = true, quality = "low", group = "store8"},
    {label = "24/7 - Sandy Shores Cam 2", x = 1954.988, y = 3747.461, z = 34.606, r = { x = -32.647, y = 0.000, z = -93.909 }, canRotate = false, isOnline = true, quality = "low", group = "store8"},
    
    {label = "24/7 - West Strawberry Cam 1", x = 34.389, y = -1342.936, z = 31.723, r = { x = -27.383, y = -0.000, z = 115.196 }, canRotate = false, isOnline = true, quality = "low", group = "store9"},
    {label = "24/7 - West Strawberry Cam 2", x = 23.938, y = -1338.369, z = 31.766, r = { x = -36.359, y = -0.000, z = -121.181 }, canRotate = false, isOnline = true, quality = "low", group = "store9"},
    
    {label = "24/7 - Downtown Vinewood Cam 1", x = 383.229, y = 328.228, z = 105.806, r = { x = -28.735, y = 0.000, z = 105.179 }, canRotate = false, isOnline = true, quality = "low", group = "store10"},
    {label = "24/7 - Downtown Vinewood Cam 2", x = 381.081, y = 333.513, z = 105.820, r = { x = -29.995, y = -0.000, z = 102.463 }, canRotate = false, isOnline = true, quality = "low", group = "store10"},
    
    {label = "24/7 - Banham Canyon Cam 1", x = -3046.180, y = 592.659, z = 10.153, r = { x = -29.067, y = -0.000, z = -134.047 }, canRotate = false, isOnline = true, quality = "low", group = "store11"},
    {label = "24/7 - Banham Canyon Cam 2", x = -3047.322, y = 581.192, z = 10.168, r = { x = -32.413, y = -0.000, z = -11.881 }, canRotate = false, isOnline = true, quality = "low", group = "store11"},
    
    {label = "24/7 - Chumash Cam 1", x = -3245.739, y = 1010.180, z = 15.082, r = { x = -25.955, y = -0.000, z = -158.470 }, canRotate = false, isOnline = true, quality = "low", group = "store12"},
    {label = "24/7 - Chumash Cam 2", x = -3251.238, y = 1000.169, z = 15.099, r = { x = -33.750, y = -0.000, z = -36.816 }, canRotate = false, isOnline = true, quality = "low", group = "store12"},
    
    {label = "24/7 - Tataviam Mountains Cam 1", x = 2553.326, y = 390.828, z = 110.860, r = { x = -31.758, y = -0.000, z = -154.588 }, canRotate = false, isOnline = true, quality = "low", group = "store13"},
    {label = "24/7 - Tataviam Mountains Cam 2", x = 2548.241, y = 380.630, z = 110.862, r = { x = -30.340, y = -0.000, z = -41.635 }, canRotate = false, isOnline = true, quality = "low", group = "store13"},
    
    {label = "24/7 - Mirror Park Cam 1", x = 1153.504, y = -327.009, z = 71.436, r = { x = -19.413, y = -0.000, z = -51.031 }, canRotate = false, isOnline = true, quality = "low", group = "store14"},
    {label = "24/7 - Mirror Park Cam 2", x = 1158.917, y = -314.240, z = 70.923, r = { x = -39.649, y = 0.000, z = -115.795 }, canRotate = false, isOnline = true, quality = "low", group = "store14"},
    
    {label = "24/7 - East Strawberry Cam 1", x = 290.650, y = -1260.870, z = 31.752, r = { x = -22.286, y = -0.000, z = -157.896 }, canRotate = false, isOnline = true, quality = "low", group = "store15"},
    {label = "24/7 - East Strawberry Cam 2", x = 302.250, y = -1268.276, z = 31.282, r = { x = -37.798, y = -0.000, z = 144.859 }, canRotate = false, isOnline = true, quality = "low", group = "store15"},
    
    {label = "24/7 - Paleto Cam 1", x = 170.661, y = 6637.689, z = 33.953, r = { x = -23.117, y = -0.000, z = 76.900 }, canRotate = false, isOnline = true, quality = "low", group = "store16"},
    {label = "24/7 - Paleto Cam 2", x = 166.437, y = 6648.389, z = 33.949, r = { x = -28.039, y = -0.000, z = -164.320 }, canRotate = false, isOnline = true, quality = "low", group = "store16"},

    {label = "Vangelico Jewellery Cam 1", x = -627.438, y = -239.845, z = 40.374, r = { x = -13.827, y = -0.000, z = -18.146 }, canRotate = true, isOnline = true, quality = "brown", group = "vangelico"},
    {label = "Vangelico Jewellery Cam 2", x = -620.302, y = -224.253, z = 40.387, r = { x = -12.725, y = -0.000, z = 162.209 }, canRotate = true, isOnline = true, quality = "brown", group = "vangelico"},
    {label = "Vangelico Jewellery Cam 3", x = -622.398, y = -236.109, z = 40.382, r = { x = -14.536, y = -0.000, z = -15.272 }, canRotate = true, isOnline = true, quality = "brown", group = "vangelico"},
    {label = "Vangelico Jewellery Cam 4", x = -627.575, y = -229.604, z = 40.385, r = { x = -11.504, y = -0.000, z = 154.571 }, canRotate = true, isOnline = true, quality = "brown", group = "vangelico"},

    {label = "Fleeca - Hawick Ave East (Lobby)", x = 316.969, y = -280.250, z = 56.199, r = { x = -28.152, y = 0.000, z = 36.842 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_east" },
    {label = "Fleeca - Hawick Ave East (Vault Door)", x = 309.282, y = -281.434, z = 55.870, r = { x = -30.002, y = 0.000, z = -144.300 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_east" },
    {label = "Fleeca - Hawick Ave East (Vault)", x = 315.624, y = -284.227, z = 55.943, r = { x = -40.553, y = -0.000, z = 113.850 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_east" },

    {label = "Fleeca - Hawick Ave West (Lobby)", x = -348.147, y = -51.061, z = 51.060, r = { x = -24.457, y = -0.000, z = 36.695 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_west" },
    {label = "Fleeca - Hawick Ave West (Vault Door)", x = -355.828, y = -52.339, z = 50.721, r = { x = -27.567, y = -0.000, z = -143.934 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_west" },
    {label = "Fleeca - Hawick Ave West (Vault)", x = -349.485, y = -55.013, z = 50.804, r = { x = -28.906, y = -0.000, z = 111.223 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_hawick_west" },

    {label = "Fleeca - Blvd Del Perro (Lobby)", x = -1209.770, y = -329.542, z = 39.814, r = { x = -19.418, y = 0.000, z = 87.837 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_delperro" },
    {label = "Fleeca - Blvd Del Perro (Vault Door)", x = -1214.211, y = -335.941, z = 39.454, r = { x = -24.693, y = 0.000, z = -96.218 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_delperro" },
    {label = "Fleeca - Blvd Del Perro (Vault)", x = -1207.940, y = -333.193, z = 39.539, r = { x = -31.701, y = 0.000, z = 154.884 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_delperro" },

    {label = "Fleeca - Great Ocean Hwy (Lobby)", x = -2962.311, y = 485.884, z = 17.733, r = { x = -23.118, y = -0.000, z = 142.995 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_great_ocean" },
    {label = "Fleeca - Great Ocean Hwy (Vault Door)", x = -2958.829, y = 478.968, z = 17.382, r = { x = -25.441, y = -0.000, z = -33.265 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_great_ocean" },
    {label = "Fleeca - Great Ocean Hwy (Vault)", x = -2958.118, y = 485.855, z = 17.475, r = { x = -26.701, y = -0.000, z = -149.328 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_great_ocean" },

    {label = "Fleeca - Route 68 (Lobby)", x = 1172.177, y = 2706.841, z = 40.050, r = { x = -22.646, y = -0.000, z = -118.028 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_route68" },
    {label = "Fleeca - Route 68 (Vault Door)", x = 1178.835, y = 2710.727, z = 39.781, r = { x = -21.859, y = 0.000, z = 61.894 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_route68" },
    {label = "Fleeca - Route 68 (Vault)", x = 1172.058, y = 2711.177, z = 39.874, r = { x = -28.670, y = 0.000, z = -56.374 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_route68" },

    {label = "Fleeca - Vespucci Blvd (Lobby)", x = 152.609, y = -1041.868, z = 31.420, r = { x = -22.292, y = -0.000, z = 41.696 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_vespucci" },
    {label = "Fleeca - Vespucci Blvd (Vault Door)", x = 145.003, y = -1043.122, z = 31.050, r = { x = -21.544, y = -0.000, z = -138.304 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_vespucci" },
    {label = "Fleeca - Vespucci Blvd (Vault)", x = 151.307, y = -1045.852, z = 31.131, r = { x = -27.292, y = -0.000, z = 103.310 }, canRotate = true, isOnline = true, quality = "medium", group = "fleeca_vespucci" },
    
    {label = "Bay City Maze Bank - Lobby #1", x = -1315.266, y = -822.446, z = 20.813, r = { x = -25.387, y = -0.000, z = -86.372 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Lobby #2", x = -1308.467, y = -831.956, z = 20.791, r = { x = -25.702, y = 0.000, z = 85.675 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Tills", x = -1305.733, y = -814.596, z = 20.928, r = { x = -35.269, y = 0.000, z = -156.884 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Outter Vault", x = -1295.703, y = -822.566, z = 20.790, r = { x = -36.726, y = -0.000, z = 38.746 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Inner Vault #1", x = -1295.590, y = -814.468, z = 18.590, r = { x = -33.504, y = 0.000, z = 166.147 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Inner Vault #2", x = -1293.818, y = -815.894, z = 18.664, r = { x = -27.992, y = -0.000, z = 175.634 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Office Hall", x = -1293.167, y = -843.867, z = 20.974, r = { x = -27.756, y = 0.000, z = 37.405 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Office #1", x = -1298.697, y = -832.269, z = 20.709, r = { x = -44.843, y = -0.000, z = -19.484 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Office #2", x = -1295.484, y = -836.400, z = 20.672, r = { x = -45.197, y = 0.000, z = -16.808 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    {label = "Bay City Maze Bank - Office #3", x = -1290.665, y = -842.586, z = 20.662, r = { x = -39.331, y = -0.000, z = -9.957 }, canRotate = true, isOnline = true, quality = "blurred", group = "mazebank" },
    
    {label = "Lombank - Lobby Cam 1", x = 6.566, y = -920.700, z = 36.403, r = { x = -24.496, y = -0.000, z = -145.391 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Lobby Cam 2", x = 9.072, y = -939.181, z = 36.442, r = { x = -28.512, y = -0.000, z = -53.461 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Offices", x = 21.955, y = -942.131, z = 36.444, r = { x = -21.662, y = -0.000, z = 17.720 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Upper Vault Gate", x = 22.515, y = -941.171, z = 31.749, r = { x = -15.717, y = -0.000, z = 0.988 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Lower Vault Gate", x = 30.676, y = -929.664, z = 28.392, r = { x = -30.284, y = -0.000, z = 109.492 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Lower Vault Door", x = 22.629, y = -917.356, z = 28.381, r = { x = -12.331, y = -0.000, z = -164.642 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Lower Vault Cam 1", x = 32.513, y = -918.778, z = 28.529, r = { x = -19.300, y = -0.000, z = 21.618 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },
    {label = "Lombank - Lower Vault Cam 2", x = 27.842, y = -905.864, z = 28.509, r = { x = -18.945, y = -0.000, z = -149.524 }, canRotate = true, isOnline = true, quality = "blurred", group = "lombank" },

    {label = "Paleto - Exterior Front", x = -103.558, y = 6451.413, z = 34.660, r = { x = -19.993, y = -0.000, z = 64.690 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Exterior Rear", x = -74.874, y = 6471.274, z = 37.693, r = { x = -17.316, y = -0.000, z = 85.872 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Lobby", x = -102.195, y = 6475.878, z = 33.315, r = { x = -10.834, y = -0.000, z = 161.389 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Tills", x = -114.958, y = 6470.772, z = 33.351, r = { x = -15.322, y = -0.000, z = -104.635 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Vault Door", x = -100.012, y = 6465.389, z = 33.658, r = { x = -27.369, y = -0.000, z = 83.909 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Vault", x = -95.388, y = 6461.215, z = 33.701, r = { x = -26.976, y = -0.000, z = 70.917 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Office #1", x = -101.688, y = 6460.564, z = 33.343, r = { x = -28.615, y = 0.000, z = 86.186 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Office #2", x = -97.415, y = 6464.810, z = 33.339, r = { x = -31.489, y = -0.000, z = 3.469 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },
    {label = "Paleto - Office #3", x = -105.868, y = 6480.933, z = 33.362, r = { x = -28.615, y = -0.000, z = -170.940 }, canRotate = true, isOnline = true, quality = "blurred", group = "paleto" },

    {label = "Pacific Bank - ATMs", x = 237.908, y = 234.100, z = 109.965, r = { x = -14.890, y = -0.000, z = -165.588 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Main Area Cam 1", x = 243.841, y = 221.995, z = 116.196, r = { x = -29.615, y = -0.000, z = -83.107 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Main Area Cam 2", x = 268.856, y = 221.630, z = 116.361, r = { x = -31.347, y = -0.000, z = 95.317 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Gate 1", x = 273.095, y = 228.296, z = 100.570, r = { x = -21.189, y = -0.000, z = -163.974 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Gate 2", x = 265.137, y = 206.262, z = 100.656, r = { x = -27.607, y = -0.000, z = -61.060 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Cam 1", x = 264.648, y = 215.045, z = 100.729, r = { x = -28.788, y = 0.000, z = -21.021 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Cam 2", x = 254.517, y = 225.571, z = 100.403, r = { x = -24.103, y = -0.000, z = 100.790 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Cam 3", x = 239.452, y = 225.029, z = 100.400, r = { x = -17.646, y = -0.000, z = -80.942 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Room 1", x = 243.696, y = 216.499, z = 100.655, r = { x = -34.496, y = -0.000, z = 158.467 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Upper Vault Room 2", x = 250.252, y = 234.132, z = 100.758, r = { x = -33.000, y = -0.000, z = -19.289 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Lower Vault Cam 1", x = 232.338, y = 233.870, z = 99.681, r = { x = -27.331, y = -0.000, z = 124.452 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    {label = "Pacific Bank - Lower Vault Cam 2", x = 225.977, y = 229.858, z = 99.735, r = { x = -23.040, y = -0.000, z = -66.178 }, canRotate = true, isOnline = true, quality = "blurred", group = "pacific_bank"},
    
    {label = "Diamond Casino - Exterior Cam 1", x = 913.811, y = 35.502, z = 84.674, r = { x = -12.874, y = 0.000, z = 123.120 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 2", x = 928.717, y = 61.135, z = 84.741, r = { x = -15.276, y = -0.000, z = -2.313 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 3", x = 949.867, y = 81.660, z = 84.736, r = { x = -27.953, y = -0.000, z = -83.494 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 4", x = 973.132, y = 85.431, z = 84.759, r = { x = -18.504, y = -0.000, z = -29.084 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 5", x = 1001.086, y = 70.831, z = 84.760, r = { x = -12.638, y = -0.000, z = -88.730 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 6", x = 1003.536, y = 56.315, z = 84.768, r = { x = -8.071, y = 0.000, z = 148.121 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 7", x = 966.193, y = -3.363, z = 84.782, r = { x = -6.063, y = -0.000, z = -52.273 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 8", x = 940.121, y = -1.530, z = 84.768, r = { x = -9.449, y = 0.000, z = 147.136 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Exterior Cam 9", x = 904.623, y = 6.340, z = 84.786, r = { x = -18.071, y = -0.000, z = 58.278 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Entrance", x = 951.844, y = 21.605, z = 74.084, r = { x = -13.819, y = -0.000, z = -8.415 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Reception", x = 965.656, y = 47.939, z = 74.779, r = { x = -48.425, y = 0.000, z = 162.137 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Clothing Store", x = 962.947, y = 19.905, z = 74.259, r = { x = -15.788, y = 0.000, z = -75.029 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Floor Cam 1", x = 968.254, y = 32.894, z = 75.318, r = { x = -15.984, y = -0.000, z = -75.344 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Floor Cam 2", x = 971.606, y = 21.722, z = 75.517, r = { x = -13.465, y = -0.000, z = -43.336 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Floor Cam 3", x = 986.523, y = 49.319, z = 76.460, r = { x = -34.488, y = -0.000, z = -124.714 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - Floor Cam 4", x = 997.815, y = 42.512, z = 76.569, r = { x = -23.386, y = -0.000, z = 97.924 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - VIP Cam 1", x = 1006.379, y = 60.663, z = 73.452, r = { x = -16.969, y = 0.000, z = 175.365 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - VIP Cam 2", x = 1012.854, y = 32.819, z = 73.591, r = { x = -26.457, y = 0.000, z = 20.326 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - VIP Cam 3", x = 1020.008, y = 42.149, z = 73.523, r = { x = -25.236, y = -0.000, z = -9.163 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - High Roller Cam 1", x = 1023.343, y = 60.895, z = 72.565, r = { x = -40.591, y = 0.000, z = -99.359 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},
    {label = "Diamond Casino - High Roller Cam 2", x = 1028.059, y = 40.149, z = 72.583, r = { x = -31.142, y = 0.000, z = -69.674 }, canRotate = true, isOnline = true, quality = "blurred", group = "diamond_casino"},

    {label = "Art Gallery - Entrance", x = 18.399, y = 150.852, z = 96.096, r = { x = -22.979, y = -0.000, z = 122.631 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 1", x = 29.475, y = 146.708, z = 102.688, r = { x = -47.034, y = -0.000, z = 111.726 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 2", x = 15.258, y = 137.571, z = 102.919, r = { x = -42.231, y = -0.000, z = -109.652 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 3", x = 21.649, y = 154.922, z = 102.898, r = { x = -48.372, y = -0.000, z = -111.267 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 4", x = 43.007, y = 137.396, z = 101.545, r = { x = -36.758, y = -0.000, z = 69.521 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 5", x = 46.053, y = 146.378, z = 102.898, r = { x = -48.963, y = 0.000, z = 71.017 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
    {label = "Art Gallery - Gallery Cam 6", x = 39.508, y = 128.715, z = 102.898, r = { x = -45.931, y = 0.000, z = 68.773 }, canRotate = true, isOnline = true, quality = "blurred", group = "art_gallery"},
}