--[[
    Script: GPS Location Reporter
    Description:
        Periodically reads GPS data and reports it to the GCS.
        Outputs latitude, longitude, and altitude above home in meters.
--]]

-- Constants
local MAV_SEVERITY_INFO = 7
local ALT_FRAME_ABOVE_HOME = 1
local LOOP_DELAY_MS = 1000

local function get_gps()
    local location = ahrs:get_location()

    if location then
        location:change_alt_frame(ALT_FRAME_ABOVE_HOME)

        local lat = location:lat() * 1e-7
        local lng = location:lng() * 1e-7
        local alt = location:alt() * 1e-2

        local msg = string.format(
            "Location -> Latitude: %.6f  Longitude: %.6f  Altitude: %.2f m",
            lat, lng, alt
        )
        gcs:send_text(MAV_SEVERITY_INFO, msg)
    else
        gcs:send_text(MAV_SEVERITY_INFO, "GPS location not available.")
    end

    return get_gps, LOOP_DELAY_MS
end

return get_gps()
