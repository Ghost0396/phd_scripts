--[[
    Script: Toggle Arming State
    Description:
        Toggles the vehicle's arming state every 5 seconds.
        Useful for testing automation behaviors.
--]]

-- Constants
local LOOP_DELAY_MS = 5000
local MAV_SEVERITY_INFO = 6

-- Function to toggle arming/disarming the vehicle
local function toggleArmingState()
    if arming:is_armed() then
        gcs:send_text(MAV_SEVERITY_INFO, "Toggling: Vehicle is ARMED — DISARMING now.")
        arming:disarm()
    else
        gcs:send_text(MAV_SEVERITY_INFO, "Toggling: Vehicle is DISARMED — ARMING now.")
        arming:arm()
    end

    -- Schedule next toggle
    return toggleArmingState, LOOP_DELAY_MS
end

-- Start toggling
return toggleArmingState()
