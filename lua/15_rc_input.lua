--[[
    Script: Read RC Inputs from Channels 6 and 7
    Description:
        Periodically reads PWM values from RC channels 6 and 7 and logs them
        to the Ground Control Station (GCS) every second.
--]]

-- Constants
local MAV_SEVERITY_DEBUG = 7
local LOOP_DELAY_IN_MS = 1000

-- Function to safely read PWM value from a given RC channel
function read_channel(channel)
    local channel_value = rc:get_pwm(channel)
    if not channel_value then
        return 0  -- Return 0 if channel is unavailable
    end
    return channel_value
end

-- Main function to read RC inputs and log their values
function read_rc()
    local channel_6 = read_channel(6)
    local channel_7 = read_channel(7)

    gcs:send_text(MAV_SEVERITY_DEBUG, "RC input: channel 6 = " .. channel_6 .. ", channel 7 = " .. channel_7)

    -- Schedule next read after LOOP_DELAY_IN_MS milliseconds
    return read_rc, LOOP_DELAY_IN_MS
end

-- Start the script
return read_rc()
