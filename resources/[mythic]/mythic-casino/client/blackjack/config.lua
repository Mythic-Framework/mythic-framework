_blackjackTables = {
    [0] = {
        dealer = {
            coords = vector3(1044.193, 53.456, 69.060),
            heading = 189.722,
            voice = 5,
            clothing = 7, -- Female More than 7
            isFemale = true,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01`,
            coords = vector3(1044.392456, 52.664093, 68.060074),
            heading = 13.46,
        },
        polyzone = {
            center = vector3(1044.4, 52.62, 69.06),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 15,
                --debugPoly=true,
                minZ = 68.06,
                maxZ = 70.26
            }
        },
    },
    [1] = {
        dealer = {
            coords = vector3(1043.663, 56.004, 69.060),
            heading = 19.829,
            voice = 3,
            clothing = 7,
            --isFemale = true,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01`,
            coords = vector3(1043.424072, 56.797089, 68.060074),
            heading = 193.465,
        },
        polyzone = {
            center = vector3(1043.37, 56.88, 69.06),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 15,
                --debugPoly=true,
                minZ = 68.06,
                maxZ = 70.26
            }
        },
    },
    [2] = {
        dealer = {
            coords = vector3(1036.594, 51.690, 69.060),
            heading = 198.062,
            voice = 3,
            clothing = 3,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01`,
            coords = vector3(1036.812988, 50.905663, 68.060074),
            heading = 13.156,
        },
        polyzone = {
            center = vector3(1036.83, 50.93, 69.06),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 15,
                --debugPoly=true,
                minZ = 68.06,
                maxZ = 70.46
            }
        },
    },
    [3] = {
        dealer = {
            coords = vector3(1036.043, 54.221, 69.060),
            heading = 14.862,
            voice = 3,
            clothing = 3,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01`,
            coords = vector3(1035.850098, 55.024582, 68.060074),
            heading = 193.156,
        },
        polyzone = {
            center = vector3(1035.86, 55.04, 69.06),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 15,
                --debugPoly=true,
                minZ = 68.06,
                maxZ = 70.46
            }
        },
    },
    -- [4] = {
    --     dealer = {
    --         coords = vector3(1029.776, 62.375, 69.865),
    --         heading = 103.347,
    --         voice = 3,
    --         clothing = 3,
    --     },
    --     table = {
    --         prop = `vw_prop_casino_blckjack_01b`,
    --         coords = vector3(1028.989014, 62.169212, 68.860077),
    --         heading = 283.1567,
    --     },
    --     polyzone = {
    --         center = vector3(1028.96, 62.16, 69.87),
    --         length = 2.0,
    --         width = 3.0,
    --         options = {
    --             heading = 285,
    --             --debugPoly=true,
    --             minZ = 68.87,
    --             maxZ = 71.47
    --         }
    --     },
    -- },
    -- [5] = {
    --     dealer = {
    --         coords = vector3(1022.197, 60.580, 69.865),
    --         heading = 286.850,
    --         voice = 3,
    --         clothing = 3,
    --     },
    --     table = {
    --         prop = `vw_prop_casino_blckjack_01b`,
    --         coords = vector3(1023.019653, 60.771294, 68.860008),
    --         heading = 103.466,
    --     },
    --     polyzone = {
    --         center = vector3(1023.08, 60.78, 69.87),
    --         length = 2.0,
    --         width = 3.0,
    --         options = {
    --             heading = 285,
    --             --debugPoly=true,
    --             minZ = 68.87,
    --             maxZ = 71.47
    --         }
    --     },
    -- },
    [4] = {
        dealer = {
            coords = vector3(1027.063, 39.879, 69.865),
            heading = 292.652,
            voice = 3,
            clothing = 3,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01b`,
            coords = vector3(1027.855347, 40.083855, 68.860008),
            heading = 103.46606445313,
        },
        polyzone = {
            center = vector3(1027.9, 40.1, 69.87),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 285,
                --debugPoly=true,
                minZ = 68.87,
                maxZ = 71.47
            }
        },
    },
    [5] = {
        dealer = {
            coords = vector3(1034.647, 41.724, 69.865),
            heading = 103.740,
            voice = 3,
            clothing = 3,
        },
        table = {
            prop = `vw_prop_casino_blckjack_01b`,
            coords = vector3(1033.817505, 41.512794, 68.860077),
            heading = 283.156,
        },
        polyzone = {
            center = vector3(1033.77, 41.55, 69.87),
            length = 2.0,
            width = 3.0,
            options = {
                heading = 285,
                --debugPoly=true,
                minZ = 68.87,
                maxZ = 71.47
            }
        },
    },
}

_blackjackTablesCount = 0
for k, v in pairs(_blackjackTables) do
    _blackjackTablesCount += 1
end