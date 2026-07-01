------------------------------------------------------------
-- RM Turtle+
-- Version : 1.0.3
--
-- Switch layout
--   SG up     = Ignored / reserved
--   SG middle = Turtle Mode
--   SG down   = Flight
------------------------------------------------------------

local input = {
  { "ArmReq", SOURCE },
  { "SG", SOURCE },
  { "DMode", VALUE, 1, 20, 4 },
  { "DArm",  VALUE, 2, 30, 9 }
}

local output = { "ARM", "TURTLE" }

local LOW,HIGH=-1000,1000

local ST_DISARMED,ST_FLIGHT,ST_ENTER_DISARM,ST_ENTER_TURTLE,
      ST_TURTLE,ST_EXIT_DISARM,ST_EXIT_FLIGHT = 0,1,2,3,4,5,6

local state=ST_DISARMED
local stateStart=0
local lastValidRequest=false

local function ticks() return getTime and getTime() or 0 end
local function active(v) return v and v>0 end

-- SG down (negative) = Flight
-- SG middle          = Turtle
-- SG up (positive)   = ignored / hold previous request
local function readTurtleRequest(v)
  if v==nil then return lastValidRequest end

  if v < -10 then
    lastValidRequest = false
    return false
  end

  if v > 10 then
    return lastValidRequest
  end

  lastValidRequest = true
  return true
end

local function setState(s)
  if s~=state then state=s; stateStart=ticks() end
end

local function elapsed() return ticks()-stateStart end

local function run(armReqSrc,sgSrc,dMode,dArm)
  local armReq=active(armReqSrc)
  local turtleReq=readTurtleRequest(sgSrc)

  local dModeTicks=(dMode or 4)*10
  local dArmTicks=(dArm or 9)*10
  local secondDelay=dArmTicks-dModeTicks
  if secondDelay<1 then secondDelay=1 end

  if not armReq then
    setState(ST_DISARMED)
    return LOW,LOW
  end

  if state==ST_DISARMED then
    setState(turtleReq and ST_ENTER_DISARM or ST_FLIGHT)
  elseif state==ST_FLIGHT then
    if turtleReq then setState(ST_ENTER_DISARM) end
  elseif state==ST_ENTER_DISARM then
    if not turtleReq then
      setState(ST_FLIGHT)
    elseif elapsed()>=dModeTicks then
      setState(ST_ENTER_TURTLE)
    end
  elseif state==ST_ENTER_TURTLE then
    if not turtleReq then
      setState(ST_EXIT_DISARM)
    elseif elapsed()>=secondDelay then
      setState(ST_TURTLE)
    end
  elseif state==ST_TURTLE then
    if not turtleReq then setState(ST_EXIT_DISARM) end
  elseif state==ST_EXIT_DISARM then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    elseif elapsed()>=dModeTicks then
      setState(ST_EXIT_FLIGHT)
    end
  elseif state==ST_EXIT_FLIGHT then
    if turtleReq then
      setState(ST_ENTER_DISARM)
    elseif elapsed()>=secondDelay then
      setState(ST_FLIGHT)
    end
  end

  if state==ST_FLIGHT then
    return HIGH,LOW
  elseif state==ST_ENTER_DISARM then
    return LOW,LOW
  elseif state==ST_ENTER_TURTLE then
    return LOW,HIGH
  elseif state==ST_TURTLE then
    return HIGH,HIGH
  elseif state==ST_EXIT_DISARM then
    return LOW,HIGH
  else
    return LOW,LOW
  end
end

return {input=input,output=output,run=run}
