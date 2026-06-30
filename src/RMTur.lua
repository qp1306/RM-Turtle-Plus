------------------------------------------------------------
-- RM Turtle+
-- File    : RMTur.lua
-- Purpose : First installable EdgeTX mixer script load test
-- Version : 0.0.1-dev
--
-- SAFETY:
-- This development stub is not flight ready.
-- It does not pass through or generate any active control output.
-- Both outputs are intentionally held LOW for safe load testing.
------------------------------------------------------------

local INPUTS = {
  { "ArmReq", SOURCE },
  { "TurtSw", SOURCE }
}

local OUTPUTS = {
  "ARM",
  "TURTLE"
}

local function run(armReq, turtleSw)
  -- Load-test only.
  -- Outputs stay low so this file can be used only to confirm that
  -- EdgeTX sees the mixer script and exposes two outputs.
  return -100, -100
end

return {
  input = INPUTS,
  output = OUTPUTS,
  run = run
}
