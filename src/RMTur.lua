------------------------------------------------------------
-- RM Turtle+
-- File    : RMTur.lua
-- Version : 0.0.6-dev
-- Purpose : Standalone EdgeTX mixer script for automatic Turtle Mode
--
-- SAFETY:
-- Test on spare channels first.
-- Do NOT connect these outputs to your real ARM/TURTLE channels
-- until the sequence has been checked in the channel monitor.
--
-- Required workflow:
--   SG- = Flight
--   SG  = Turtle
--   SG+ = Ignored / reserved
--
-- Setup:
--   ArmReq = L04
--   SG     = SG
--   DMode  = 4       (0.4 s from ARM low to mode change)
--   DArm   = 9       (0.9 s total from start to ARM high)
------------------------------------------------------------

local input = {
  { "ArmReq", SOURCE },
  { "SG", SOURCE },
  { "DMode", VALUE, 1, 20, 4 },
  { "DArm",  VALUE, 2, 30, 9 }
}

local output = {
  "ARM",
  "TURTLE"
}

local LOW  = -100
local HIGH = 100

local ST_DISARMED       = 0
local ST_FLIGHT         = 1
local ST_ENTER_DISARM   = 2
local ST_ENTER_TURTLE   = 3
local ST_TURTLE         = 4
local ST_EXIT_DISARM    = 5
local ST_EXIT_FLIGHT    = 6

local state = ST_DISARMED
local stateStart = 0
local lastValidRequest = false

local function ticks()
  if getTime then
    return getTime()
  end
  return 0
end

local function active(v)
  return v ~= nil and v > 0
end

-- EdgeTX 3-position switches normally report approximately:
--   SG- = negative
--   SG  = zero
--   SG+ = positive
--
-- Grant's workflow:
--   SG- = Flight
--   SG  = Turtle
--   SG+ = Ignore / hold last valid request
local function readTurtleRequest(sgValue)
  if sgValue == nil then
    return lastValidRequest
  end

  if sgValue < -10 then
    lastValidRequest = false
    return false
  end

  if sgValue > 10 then
    return lastValidRequest
  end

  lastValidRequest = true
  return true
end

local function setState(newState)
  if state ~= newState then
    state = newState
    stateStart = ticks()
  end
end

local function elapsed()
  return ticks() - stateStart
end

local function run(armReqSrc, sgSrc, dMode, dArm)
  local armReq = active(armReqSrc)
  local turtleReq = readTurtleRequest(sgSrc)

  local dModeTicks = (dMode or 4) * 10
  local dArmTicks  = (dArm or 9) * 10
  local secondDelay = dArmTicks - dModeTicks

  if secondDelay < 1 then
    secondDelay = 1
  end

  -- Hard safety override:
  -- If the pilot's arm request is off, both outputs immediately go low.
  if not armReq then
    setState(ST_DISARMED)
    return LOW, LOW
  end

  -- State transitions.
  if state == ST_DISARMED then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    else
      setState(ST_FLIGHT)
    end

  elseif state == ST_FLIGHT then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    end

  elseif state == ST_ENTER_DISARM then
    if not turtleReq then
      setState(ST_FLIGHT)
    elseif elapsed() >= dModeTicks then
      setState(ST_ENTER_TURTLE)
    end

  elseif state == ST_ENTER_TURTLE then
    if not turtleReq then
      setState(ST_EXIT_DISARM)
    elseif elapsed() >= secondDelay then
      setState(ST_TURTLE)
    end

  elseif state == ST_TURTLE then
    if not turtleReq then
      setState(ST_EXIT_DISARM)
    end

  elseif state == ST_EXIT_DISARM then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    elseif elapsed() >= dModeTicks then
      setState(ST_EXIT_FLIGHT)
    end

  elseif state == ST_EXIT_FLIGHT then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    elseif elapsed() >= secondDelay then
      setState(ST_FLIGHT)
    end

  else
    setState(ST_DISARMED)
    return LOW, LOW
  end

  if state == ST_FLIGHT then
    return HIGH, LOW
  elseif state == ST_ENTER_DISARM then
    return LOW, LOW
  elseif state == ST_ENTER_TURTLE then
    return LOW, HIGH
  elseif state == ST_TURTLE then
    return HIGH, HIGH
  elseif state == ST_EXIT_DISARM then
    return LOW, HIGH
  elseif state == ST_EXIT_FLIGHT then
    return LOW, LOW
  end

  return LOW, LOW
end

return {
  input = input,
  output = output,
  run = run
}
