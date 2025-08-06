--[[
    Script: Rover Mode Toggle
    Description:
        Periodically toggles the vehicle's mode between MANUAL and GUIDED.
        Sends the current mode name to the GCS for monitoring.
        Only toggles if the mode is currently MANUAL or GUIDED.
--]]

-- Constants
local MAV_SEVERITY_INFO = 7
local LOOP_DELAY_MS = 1000

-- Rover mode enumeration (mode number → name)
local ROVER_MODES = {
    [0] = "MANUAL", [1] = "ACRO", [2] = "STEERING",
    [3] = "HOLD", [4] = "LOITER", [5] = "FOLLOW",
    [6] = "SIMPLE", [7] = "DOCK", [9] = "CIRCLE",
    [11] = "AUTO", [13] = "RTL", [14] = "SMART RTL",
    [15] = "GUIDED", [16] = "INITIALISING"
}

local function manageFlightMode()
    local currentMode = vehicle:get_mode()

    -- Toggle only between MANUAL and GUIDED
    if currentMode == 15 then
        vehicle:set_mode(0)  -- Set to MANUAL
    elseif currentMode == 0 then
        vehicle:set_mode(15) -- Set to GUIDED
    end

    -- Log current mode name
    local modeName = ROVER_MODES[currentMode] or "UNKNOWN"
    gcs:send_text(MAV_SEVERITY_INFO, "Rover mode: " .. modeName)

    return manageFlightMode, LOOP_DELAY_MS
end

return manageFlightMode()
