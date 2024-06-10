COMPONENTS.Convar = {
    DISCORD_APP = { value = GetConvar('discord_app', '') },
    MAX_CLIENTS = { value = tonumber(GetConvar('sv_maxclients', '32')) },
    LOGGING = { value = tonumber(GetConvar('log_level', 0)) },
    MFW_VERSION = { value = GetConvar('mfw_version', "UNKNOWN") },
}