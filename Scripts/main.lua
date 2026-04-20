local UEHelpers = require("UEHelpers")

-- ToggleWalk 1.11 (single-player

-- ---------- config ----------
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

local STATE_IDLE = 1
local STATE_RUN  = 2
local STATE_WALK = 16

local isWalking = false
local original = nil
local walkValues = nil

local function readEntryNums(map, stid)
    local entry = map:Find(stid)
    if not entry then return nil end
    local s = entry:get()
    local speed = tonumber(tostring(s.Speed))
    local maxAcc = tonumber(tostring(s.MaxAcceleration))
    if not speed or not maxAcc then return nil end
    return { Speed = speed, MaxAcc = maxAcc }
end

local function snapshotIfNeeded(map)
    if original ~= nil then return true end
    local i = readEntryNums(map, STATE_IDLE)
    local r = readEntryNums(map, STATE_RUN)
    local w = readEntryNums(map, STATE_WALK)
    if not (i and r and w) then return false end
    original = { idle = i, run = r }
    walkValues = w
    return true
end

local function writeEntry(map, stid, speed, maxAcc)
    local entry = map:Find(stid)
    if not entry then return end
    pcall(function()
        local s = entry:get()
        s.Speed = speed
        s.MaxAcceleration = maxAcc
    end)
end

local function doToggle()
    local mv = getMovementComp()
    if not mv then return end

    local mp = mv.MovementParams
    if not (mp and mp:IsValid()) then return end
    local md = mp.MovementData
    if not md then return end
    local map = md.StateData
    if not map then return end

    if not snapshotIfNeeded(map) then return end

    isWalking = not isWalking
    local target = isWalking and walkValues or original.run
    local idleTarget = isWalking and walkValues or original.idle

    writeEntry(map, STATE_IDLE, idleTarget.Speed, idleTarget.MaxAcc)
    writeEntry(map, STATE_RUN,  target.Speed,     target.MaxAcc)

    pcall(function() mv.MaxWalkSpeed = target.Speed end)
    pcall(function() mv.MaxAcceleration = target.MaxAcc end)
end

RegisterKeyBind(TOGGLE_VK, function()
    ExecuteInGameThread(doToggle)
end)

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    isWalking = false
end)

print("[ToggleWalk] loaded (TOGGLE_KEY=" .. TOGGLE_VK .. ")")
