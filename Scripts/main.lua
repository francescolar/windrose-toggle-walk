local UEHelpers = require("UEHelpers")

-- ToggleWalk 2.2 (single-player)
-- Flippa il bit bWantWalk sulla struct MovementIntention del
-- R5MovementComponent leggendolo direttamente dal game (no state
-- tracking locale -> resta sincronizzato anche se sprint/altro
-- modifica il bit nel mezzo).

local function loadConfig()
    local key = 67  -- default: C
    local f = io.open("Mods/ToggleWalk/Scripts/config.txt", "r")
    if not f then return key end
    for line in f:lines() do
        local v = line:match("^%s*TOGGLE_KEY%s*=%s*(%d+)")
        if v then key = tonumber(v) end
    end
    f:close()
    return key
end

local TOGGLE_VK = loadConfig()

local cachedMovementComp = nil

-- ---------- helpers ----------
local function getMovementComp()
    if cachedMovementComp and cachedMovementComp:IsValid() then
        return cachedMovementComp
    end

    local p = UEHelpers.GetPlayer()
    if p and p:IsValid() then
        local mv = p.CharacterMovement
        if mv and mv:IsValid() then
            cachedMovementComp = mv
            return cachedMovementComp
        end
    end
    
    return nil
end

local function doToggle()
    local mv = getMovementComp()
    if not mv then return end
    
    local int = mv.MovementIntention
    local newWalk = not int.bWantWalk
    int.bWantWalk = newWalk
    if newWalk then 
        int.bWantSprint = false 
    end
end

RegisterKeyBind(TOGGLE_VK, function()
    ExecuteInGameThread(doToggle)
end)

print("[ToggleWalk] loaded (TOGGLE_KEY=" .. TOGGLE_VK .. ")")