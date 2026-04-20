local UEHelpers = require("UEHelpers")

-- ToggleWalk 2.1 (single-player)
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

-- ---------- helpers ----------
local function getMovementComp()
    local p = UEHelpers.GetPlayer()
    if not (p and p:IsValid()) then return nil end
    local mv = p.CharacterMovement
    if mv and mv:IsValid() then return mv end
    return nil
end

local function doToggle()
    local mv = getMovementComp()
    if not mv then return end
    pcall(function()
        local int = mv.MovementIntention
        local newWalk = not int.bWantWalk
        int.bWantWalk = newWalk
        if newWalk then int.bWantSprint = false end
    end)
end

RegisterKeyBind(TOGGLE_VK, function()
    ExecuteInGameThread(doToggle)
end)

print("[ToggleWalk] loaded (TOGGLE_KEY=" .. TOGGLE_VK .. ")")
