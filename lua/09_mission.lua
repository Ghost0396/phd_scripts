--[[
    Script: Multi-location Mission
    Description:
        This Lua script guides an ArduPilot vehicle through a predefined list of GPS waypoints
        using GUIDED mode and relative altitude. After visiting all waypoints, it returns to launch (RTL).
        It requires the vehicle to be in GUIDED mode and armed.
--]]

-- Constants
local COPTER_MODES = { [0] = "STABILIZE", [15] = "GUIDED", [9] = "LAND" }
local COPTER_MODE_STABILIZE = 0
local COPTER_MODE_GUIDED = 15
local COPTER_MODE_RTL = 11

local ALT_FRAME_ABOVE_HOME = 1
local TAKEOFF_ALTITUDE = 30
local TARGET_DECISION_DISTANCE = 5
local LOOP_DELAY = 1000
local SEVERITY = 7

-- Mission state
local navigation_index = 1

-- List of waypoints: {latitude, longitude, altitude (meters)}
local target_locations = {
    { -35.36573684, 149.16312254, 30.0 },
    { -35.36135212, 149.16115359, 45.0 },
    { -35.36022811, 149.16580334, 20.0 },
    { -35.36565041, 149.16683329, 35.0 }
}

--- Creates a Location object from latitude, longitude, and altitude.
-- @param lat number: Latitude in degrees
-- @param lng number: Longitude in degrees
-- @param alt number: Altitude in meters (relative to home)
-- @return Location_ud: Location object
function createLocation(lat, lng, alt)
    local location = Location()
    location:relative_alt(true)
    location:lat(math.floor(lat * 1e7))
    location:lng(math.floor(lng * 1e7))
    location:alt(math.floor(alt * 1e2))
    return location
end

--- Entry point of the mission. Logs start message.
-- @return function, number: Next function and delay
function multi_location_mission()
    gcs:send_text(SEVERITY, "Starting the mission")
    return change_flight_mode, LOOP_DELAY
end

--- Ensures vehicle is in GUIDED mode.
-- @return function, number: Next function and delay
function change_flight_mode()
    local mode_number = vehicle:get_mode()
    local mode_name = COPTER_MODES[mode_number] or "UNKNOWN"

    gcs:send_text(SEVERITY, "Flight mode: " .. mode_name)

    if mode_number ~= COPTER_MODE_GUIDED then
        vehicle:set_mode(COPTER_MODE_GUIDED)
        return change_flight_mode, LOOP_DELAY
    end

    return arm_vehicle, LOOP_DELAY
end

--- Arms the vehicle once pre-arm checks pass.
-- @return function, number: Next function and delay
function arm_vehicle()
    local is_armable = arming:pre_arm_checks()
    local is_armed = arming:is_armed()

    if not is_armed and is_armable then
        gcs:send_text(SEVERITY, "Arming the vehicle...")
        arming:arm()
    end

    if not is_armed then
        return arm_vehicle, LOOP_DELAY
    end

    gcs:send_text(SEVERITY, "Armed the vehicle")
    return do_navigation, LOOP_DELAY
end

--- Sends the vehicle to each waypoint in sequence.
-- Logs current waypoint index and distance.
-- @return function, number: Next function and delay
function do_navigation()
    local waypoint = target_locations[navigation_index]
    local target_location = createLocation(waypoint[1], waypoint[2], waypoint[3])
    vehicle:set_target_location(target_location)

    local current_location = ahrs:get_location()
    local target_distance = current_location:get_distance(target_location)

    gcs:send_text(SEVERITY, "Waypoint " .. navigation_index .. " distance: " .. math.floor(target_distance))

    if target_distance < TARGET_DECISION_DISTANCE then
        gcs:send_text(SEVERITY, "Reached waypoint: " .. navigation_index)
        navigation_index = navigation_index + 1
    end

    if navigation_index > #target_locations then
        gcs:send_text(SEVERITY, "Mission complete")
        return return_to_launch, LOOP_DELAY
    end

    return do_navigation, LOOP_DELAY
end

--- Switches the vehicle to RTL and monitors return progress.
-- @return function, number: Next function and delay
function return_to_launch()
    local mode_number = vehicle:get_mode()
    local mode_name = COPTER_MODES[mode_number] or "UNKNOWN"

    local home_location = ahrs:get_home()
    local current_location = ahrs:get_location()
    local home_distance = current_location:get_distance(home_location)

    gcs:send_text(SEVERITY, "Returning home, mode: " .. mode_name .. ", distance: " .. math.floor(home_distance) .. "m")

    if mode_number ~= COPTER_MODE_RTL then
        vehicle:set_mode(COPTER_MODE_RTL)
    end

    if home_distance < TARGET_DECISION_DISTANCE then
        gcs:send_text(SEVERITY, "Reached home")
        return wait_disarm, LOOP_DELAY
    end

    return return_to_launch, LOOP_DELAY
end

--- Waits for the vehicle to land and disarm, then ends the mission.
-- @return function, number: Next function and delay
function wait_disarm()
    local is_armed = arming:is_armed()
    local is_landing = vehicle:is_landing()

    local current_location = ahrs:get_location()
    current_location:change_alt_frame(ALT_FRAME_ABOVE_HOME)
    local current_altitude = current_location:alt() * 1e-2

    gcs:send_text(SEVERITY, "Final stage, armed: " .. tostring(is_armed) ..
        ", landing: " .. tostring(is_landing) ..
        ", altitude: " .. math.floor(current_altitude) .. "m")

    return wait_disarm, LOOP_DELAY
end

-- Start the mission
return multi_location_mission()
