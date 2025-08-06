--[[
    Script: Toggle Servo and Relay Outputs
    Description:
        Periodically toggles a servo output PWM between 1000 and 2000,
        and toggles a relay on/off on a specified relay instance.
        
    Notes:
        - Ensure SERVOx_FUNCTION is set to 0 for the servo channel before use.
        - SERVO_FUNCTION corresponds to servo function number (e.g., 94 for Script1).
        - RELAY_INSTANCE is the relay index (0-based).
        - Relay pins and servo functions must be properly configured in parameters.
        - Use "graph SERVO_OUTPUT_RAW.servox_raw" to observe servo output.
        -- module load graph
        -- Loaded module graph
--]]

-- Constants
local MAV_SEVERITY_DEBUG = 7
local LOOP_DELAY_IN_MS = 1000
local RELAY_INSTANCE = 0
local SERVO_FUNCTION = 94

-- State variable to toggle output
local flipflop = true

-- Servo channel index associated with SERVO_FUNCTION
local servo_channel

-- Function to toggle servo and relay outputs
function set_servo_relay()

    -- Check if servo channel exists
    if not servo_channel then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Servo channel not found for function " .. SERVO_FUNCTION)
        return set_servo_relay, LOOP_DELAY_IN_MS
    end

    -- Check if relay instance is enabled
    if not relay:enabled(RELAY_INSTANCE) then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Relay instance " .. RELAY_INSTANCE .. " is not enabled")
        return set_servo_relay, LOOP_DELAY_IN_MS
    end

    if flipflop then
        -- Set servo PWM to max (2000)
        SRV_Channels:set_output_pwm_chan(servo_channel, 2000)

        -- Turn relay ON
        relay:on(RELAY_INSTANCE)
    else
        -- Set servo PWM to min (1000)
        SRV_Channels:set_output_pwm_chan(servo_channel, 1000)

        -- Turn relay OFF
        relay:off(RELAY_INSTANCE)
    end

    -- Get current servo PWM output for reporting
    local servo_state = SRV_Channels:get_output_pwm(servo_channel)
    gcs:send_text(MAV_SEVERITY_DEBUG, "Servo current state: " .. servo_state)

    -- Get current relay state for reporting
    local relay_state = relay:get(RELAY_INSTANCE)
    gcs:send_text(MAV_SEVERITY_DEBUG, "Relay current state: " .. tostring(relay_state))

    -- Toggle flipflop state for next iteration
    flipflop = not flipflop

    -- Schedule the next update
    return set_servo_relay, LOOP_DELAY_IN_MS
end

-- Find the servo channel corresponding to the servo function number
servo_channel = SRV_Channels:find_channel(SERVO_FUNCTION)

-- Start the script
return set_servo_relay()
