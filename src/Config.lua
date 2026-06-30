------------------------------------------------------------
-- RM Turtle+
-- File    : Config.lua
-- Purpose : Default configuration constants
-- Version : 0.1.0-alpha
------------------------------------------------------------

local Config = {}

-- v0.1 fixed timing values.
-- Later versions may expose these through a configuration UI.
Config.DISARM_TO_MODE_DELAY_MS = 400
Config.MODE_TO_ARM_DELAY_MS = 500

-- Output values used by EdgeTX mixer script logic.
Config.OUTPUT_LOW = -100
Config.OUTPUT_HIGH = 100

-- Boolean thresholds for input normalisation.
Config.INPUT_ACTIVE_THRESHOLD = 0
Config.INPUT_TURTLE_THRESHOLD = 0

-- Safety mode.
Config.PROPS_OFF_ALPHA_ONLY = true

return Config
