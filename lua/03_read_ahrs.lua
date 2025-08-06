--[[
    Script: AHRS Attitude Monitor
    Description:
        Reads and logs roll, pitch, and yaw from the vehicle's AHRS.
        Outputs values to GCS every 1 second.
--]]

-- Constants
local MAV_SEVERITY_INFO = 7      -- 7 = DEBUG level
local LOOP_DELAY_MS = 1000       -- 1 second interval

-- Function to read AHRS attitude and send to GCS
local function getahrs()
    local roll = ahrs:get_roll()
    local pitch = ahrs:get_pitch()
    local yaw = ahrs:get_yaw()

    -- Check for nil values (unlikely but safe)
    if not roll or not pitch or not yaw then
        gcs:send_text(MAV_SEVERITY_INFO, "Error: AHRS data unavailable.")
    else
        local msg = string.format("Attitude -> roll: %.1f  pitch: %.1f  yaw: %.1f", math.deg(roll), math.deg(pitch), math.deg(yaw))
        gcs:send_text(MAV_SEVERITY_INFO, msg)
    end

    return getahrs, LOOP_DELAY_MS
end

-- Start the monitoring loop
return getahrs()
