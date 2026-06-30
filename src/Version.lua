------------------------------------------------------------
-- RM Turtle+
-- File    : Version.lua
-- Purpose : Project version metadata
-- Version : 0.1.0-alpha
------------------------------------------------------------

local Version = {}

Version.NAME = "RM Turtle+"
Version.SHORT_NAME = "RMT+"
Version.VERSION = "0.1.0-alpha"
Version.STATUS = "development"
Version.PROJECT_OWNER = "Grant Lauga"
Version.LEAD_ARCHITECT = "OpenAI ChatGPT"

function Version.GetBanner()
  return Version.NAME .. " " .. Version.VERSION
end

return Version
