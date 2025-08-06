--[[
    Script: Get and Set Home Position
    Description:
        Reads the current home position if set, logs it,
        then attempts to set a new home position.
--]]

local MAV_SEVERITY_DEBUG = 7
local LOOP_DELAY_IN_MS = 1000

function get_set_home()

    -- Check if home position is already set
    if not ahrs:home_is_set() then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Home position is not set yet.")
        return get_set_home, LOOP_DELAY_IN_MS
    end

    -- Retrieve current home position
    local home_position = ahrs:get_home()
    local home_latitude = home_position:lat() * 1e-7
    local home_longitude = home_position:lng() * 1e-7
    local home_altitude = home_position:alt() * 1e-2

    -- Log current home position
    gcs:send_text(MAV_SEVERITY_DEBUG, 
        string.format("Home position: latitude = %.7f, longitude = %.7f, altitude = %.2f", 
            home_latitude, home_longitude, home_altitude))

    -- Create a new home position (example coordinates)
    local new_home_position = Location()
    new_home_position:lat(-353612754)    -- Latitude in 1e-7 degrees
    new_home_position:lng(1491611647)    -- Longitude in 1e-7 degrees
    new_home_position:alt(58621)          -- Altitude in centimeters

    -- Attempt to set the new home position
    if ahrs:set_home(new_home_position) then
        gcs:send_text(MAV_SEVERITY_DEBUG, "Home position is set.")
    else
        gcs:send_text(MAV_SEVERITY_DEBUG, "Failed to set home position.")
    end

    -- Schedule the next call
    return get_set_home, LOOP_DELAY_IN_MS
end

-- Start the script
return get_set_home()
