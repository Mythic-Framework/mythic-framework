function CreateVOIPSubmix()
    -- default submix
    -- freq_low = 389.0
    -- freq_hi = 3248.0
    -- fudge = 0.0
    -- rm_mod_freq = 0.0
    -- rm_mix = 0.16
    -- o_freq_lo = 348.0
    -- 0_freq_hi = 4900.0

    local defaultRadioFloats = {
        [`freq_low`] = 100.0,
        [`freq_hi`] = 5000.0,
        [`rm_mod_freq`] = 300.0,
        [`rm_mix`] = 0.2,
        [`fudge`] = 5.0, -- These are the ones that change the crappyness of the radios
        [`o_freq_lo`] = 300.0,
        [`o_freq_hi`] = 5000.0,
    }

    local radioSubmix = CreateAudioSubmix('Radio')
    SetAudioSubmixEffectRadioFx(radioSubmix, 1)
    SetAudioSubmixEffectParamInt(radioSubmix, 1, `default`, 1)
    for k, v in pairs(defaultRadioFloats) do
        SetAudioSubmixEffectParamFloat(radioSubmix, 1, k, v)
    end
    AddAudioSubmixOutput(radioSubmix, 1)

    -- Medium Distance
    local radioSubmix2 = CreateAudioSubmix('Radio2')
    SetAudioSubmixEffectRadioFx(radioSubmix2, 1)
    SetAudioSubmixEffectParamInt(radioSubmix2, 1, `default`, 1)
    for k, v in pairs(defaultRadioFloats) do
        SetAudioSubmixEffectParamFloat(radioSubmix2, 1, k, v)
    end
    SetAudioSubmixEffectParamFloat(radioSubmix2, 1, `rm_mix`, 0.3)
    SetAudioSubmixEffectParamFloat(radioSubmix2, 1, `fudge`, 6.0)
    AddAudioSubmixOutput(radioSubmix2, 1)

    -- Far Distance
    local radioSubmix3 = CreateAudioSubmix('Radio3')
    SetAudioSubmixEffectRadioFx(radioSubmix3, 1)
    SetAudioSubmixEffectParamInt(radioSubmix3, 1, `default`, 1)
    for k, v in pairs(defaultRadioFloats) do
        SetAudioSubmixEffectParamFloat(radioSubmix3, 1, k, v)
    end
    SetAudioSubmixEffectParamFloat(radioSubmix3, 1, `rm_mix`, 0.6)
    SetAudioSubmixEffectParamFloat(radioSubmix3, 1, `fudge`, 12.0)
    AddAudioSubmixOutput(radioSubmix3, 1)

    -- Really Far Distance
    local radioSubmix4 = CreateAudioSubmix('Radio4')
    SetAudioSubmixEffectRadioFx(radioSubmix4, 1)
    SetAudioSubmixEffectParamInt(radioSubmix4, 1, `default`, 1)
    for k, v in pairs(defaultRadioFloats) do
        SetAudioSubmixEffectParamFloat(radioSubmix4, 1, k, v)
    end
    SetAudioSubmixEffectParamFloat(radioSubmix4, 1, `rm_mix`, 0.9)
    SetAudioSubmixEffectParamFloat(radioSubmix4, 1, `fudge`, 18.0)
    AddAudioSubmixOutput(radioSubmix4, 1)

    local phoneSubmix = CreateAudioSubmix('Phone')
    SetAudioSubmixEffectRadioFx(phoneSubmix, 1)
    SetAudioSubmixEffectParamInt(phoneSubmix, 1, `default`, 1)
    SetAudioSubmixEffectParamFloat(phoneSubmix, 1, `freq_low`, 300.0)
    SetAudioSubmixEffectParamFloat(phoneSubmix, 1, `freq_hi`, 8000.0)
    SetAudioSubmixEffectParamFloat(radioSubmix, 1, `rm_mod_freq`, 0.0)
    SetAudioSubmixEffectParamFloat(radioSubmix, 1, `rm_mix`, 0.2)
    SetAudioSubmixEffectParamFloat(radioSubmix, 1, `fudge`, 2.0)
    SetAudioSubmixEffectParamFloat(radioSubmix, 1, `o_freq_lo`, 300.0)
    SetAudioSubmixEffectParamFloat(radioSubmix, 1, `o_freq_hi`, 8000.0)
    AddAudioSubmixOutput(phoneSubmix, 1)

    local megaphoneSubmix = CreateAudioSubmix('Megaphone')
    SetAudioSubmixEffectRadioFx(megaphoneSubmix, 1)
    SetAudioSubmixEffectParamInt(megaphoneSubmix, 1, `default`, 1)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `freq_low`, 250.0)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `freq_hi`, 3000.0)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `rm_mod_freq`, 250.0)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `rm_mix`, 0.05)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `fudge`, 1.5)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `o_freq_lo`, 250.0)
    SetAudioSubmixEffectParamFloat(megaphoneSubmix, 1, `o_freq_hi`, 3000.0)
    AddAudioSubmixOutput(megaphoneSubmix, 1)

    SetAudioSubmixOutputVolumes(megaphoneSubmix, 1, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0)

    return {
        phone = phoneSubmix,
        radio = radioSubmix,
        radio_med = radioSubmix2,
        radio_far = radioSubmix3,
        radio_really_far = radioSubmix4,
        megaphone = megaphoneSubmix,
    }
end