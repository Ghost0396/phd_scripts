--[[
    Script: Read Auxiliary Switch Position
    Description:
        Reads the position of an auxiliary switch configured in RCx_OPTION (300-307),
        corresponding to AUX1 through AUX8. Prints the switch position as LOW, MEDIUM,
        HIGH, or unknown every second.

    Notes:
        - SCRIPTING_1 = 300 corresponds to AUX1.
        - Possible switch positions: LOW (0), MEDIUM (1), HIGH (2).
        - The script runs repeatedly every 1000 ms.
--]]

-- Constants
local MAV_SEVERITY_DEBUG = 7
local LOOP_DELAY_IN_MS = 1000

-- RC option for AUX1
local SCRIPTING_1 = 300

-- Switch position values
local LOW = 0
local MEDIUM = 1
local HIGH = 2

local switch_1

-- Function to read the auxiliary switch position and print its state
function read_aux()

    -- Check if the switch object was successfully found
    if not switch_1 then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Switch does not exist for option " .. SCRIPTING_1)
        return read_aux, LOOP_DELAY_IN_MS
    end

    -- Read the current position of the switch
    local switch_1_value = switch_1:get_aux_switch_pos()

    -- Evaluate and report the switch position
    if switch_1_value == LOW then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Switch is LOW")
    elseif switch_1_value == MEDIUM then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Switch is MEDIUM")
    elseif switch_1_value == HIGH then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Switch is HIGH")
    else
        gcs:send_text(MAV_SEVERITY_DEBUG, "Switch is in unknown position")
    end

    -- Schedule the next check
    return read_aux, LOOP_DELAY_IN_MS
end

-- Initialize: find the switch channel based on the configured RC option
switch_1 = rc:find_channel_for_option(SCRIPTING_1)

-- Start the script
return read_aux()
