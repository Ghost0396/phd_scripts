--[[
    Script: Loop Counter Logger
    Description:
        Logs an incrementing loop counter to the GCS console every 1000 ms.
--]]

-- Global counter
local loopCounter = 0

-- Constants
local MAV_SEVERITY_DEBUG = 7
local LOOP_DELAY_MS = 1000

-- Function to log the current loop counter value
local function logLoopCounter()
    gcs:send_text(MAV_SEVERITY_DEBUG, "Loop Counter: " .. loopCounter)
end

-- Main update function called on a timer
local function updateLoop()
    logLoopCounter()
    loopCounter = loopCounter + 1
    return updateLoop, LOOP_DELAY_MS
end

-- Start the script
return updateLoop()
