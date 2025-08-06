--[[
    Script: Navigate to Target Location
    Description:
        Commands the vehicle to move toward a predefined GPS waypoint using relative altitude.
        Reports the distance to the target every second via GCS.
        Requires the vehicle to be armed and in GUIDED mode.
--]]

-- Constants
local MAV_SEVERITY_INFO = 7
local LOOP_DELAY_MS = 1000

-- Define and configure the target location
local targetLocation = Location()
targetLocation:relative_alt(true)                      -- Use altitude relative to home
targetLocation:lat(-353615139)                         -- Latitude (degrees * 1e7)
targetLocation:lng(1491614342)                         -- Longitude (degrees * 1e7)
targetLocation:alt(4500)                               -- Altitude in cm (45.0 m)

-- Periodically commands the vehicle to move to the target and reports distance
local function go_to()
    local distance = vehicle:get_wp_distance_m()
    if distance then
        local msg = string.format("Target distance: %.1f meters", distance)
        gcs:send_text(MAV_SEVERITY_INFO, msg)
    end

    vehicle:set_target_location(targetLocation)
    return go_to, LOOP_DELAY_MS
end

return go_to()
