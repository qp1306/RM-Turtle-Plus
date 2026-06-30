------------------------------------------------------------
-- RM Turtle+
-- File    : rmturtle_gvtest.lua
-- Purpose : RF2 background Global Variable write test
-- Version : 0.0.1-dev
--
-- SAFETY:
-- Test-only module. Does not arm, disarm, or control AUX channels.
-- It writes a visible test value to GV9/FM0 so we can confirm an
-- RF2 background module can communicate with normal EdgeTX model logic.
------------------------------------------------------------

local gvtest = {}

-- EdgeTX Lua API uses zero-based GV indexes.
-- 8 = GV9. 0 = FM0/default flight mode.
local GV_INDEX = 8
local FM_INDEX = 0

local lastToggleTime = 0
local currentValue = -50

local function nowSeconds()
  if rf2 and rf2.clock then
    return rf2.clock()
  end
  if getTime then
    return getTime() / 100
  end
  return 0
end

function gvtest.run()
  local now = nowSeconds()

  -- Toggle once per second so the value is easy to see on the radio.
  if now - lastToggleTime >= 1.0 then
    lastToggleTime = now

    if currentValue < 0 then
      currentValue = 50
    else
      currentValue = -50
    end

    if model and model.setGlobalVariable then
      model.setGlobalVariable(GV_INDEX, FM_INDEX, currentValue)
    end
  end
end

function gvtest.reset()
  if model and model.setGlobalVariable then
    model.setGlobalVariable(GV_INDEX, FM_INDEX, 0)
  end
  currentValue = -50
  lastToggleTime = 0
end

return gvtest
