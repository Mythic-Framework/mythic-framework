-- Wound
isBleeding = 0
bleedTickTimer, bleedTickEvidenceTimer, advanceBleedTimer = 0, 0, 0
playerArmor, playerHealth = false, false

LocalDamage = nil

LocalPlayer.state.onPainKillers = 0
LocalPlayer.state.onDrugs = 0
LocalPlayer.state.wasOnPainKillers = false
LocalPlayer.state.wasOnDrugs = false

legCount = 0
armcount = 0
headCount = 0

limbNotifId = 'MHOS_LIMBS'
bleedNotifId = 'MHOS_BLEED'
bleedMoveNotifId = 'MHOS_BLEEDMOVE'

-- Damage
_damagedLimbs = {}
_serverId = GetPlayerServerId(PlayerId())
_key = 'Damage:'.._serverId