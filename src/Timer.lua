------------------------------------------------------------
-- RM Turtle+
-- File    : Timer.lua
-- Purpose : Small millisecond timer helper
-- Version : 0.1.0-alpha
------------------------------------------------------------

local Timer = {}

Timer.active = false
Timer.startedAtMs = 0
Timer.durationMs = 0

function Timer.NowMs()
  -- EdgeTX getTime() returns 1/100 second ticks.
  -- Convert to milliseconds.
  if getTime then
    return getTime() * 10
  end

  -- Fallback for non-EdgeTX development environments.
  return 0
end

function Timer.Start(durationMs)
  Timer.active = true
  Timer.startedAtMs = Timer.NowMs()
  Timer.durationMs = durationMs or 0
end

function Timer.Stop()
  Timer.active = false
  Timer.startedAtMs = 0
  Timer.durationMs = 0
end

function Timer.ElapsedMs()
  if not Timer.active then
    return 0
  end

  return Timer.NowMs() - Timer.startedAtMs
end

function Timer.Expired()
  if not Timer.active then
    return false
  end

  return Timer.ElapsedMs() >= Timer.durationMs
end

return Timer
