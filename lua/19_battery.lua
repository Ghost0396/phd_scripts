--[[
    Script: Get Battery Data
    Description:
        Reads voltage, estimated resting voltage, current, and consumed capacity from battery sensor,
        then sends the information to the Ground Control Station (GCS).
--]]

-- Function to get battery data and send to GCS
function get_battery()
    -- Battery instance 0 is the main battery
    local voltage = battery:voltage(0)                                     -- Voltage in volts
    local voltage_resting_estimated = battery:voltage_resting_estimate(0)  -- Estimated resting voltage in volts
    local current_amps = battery:current_amps(0)                           -- Instantaneous current in amps
    local consumed_mah = battery:consumed_mah(0)                           -- Consumed capacity in milliamp-hours

    -- Send battery data to GCS (using severity 7 for debug/info)
    gcs:send_text(7, "Voltage: " .. voltage .. " V")
    gcs:send_text(7, "Resting voltage (estimated): " .. voltage_resting_estimated .. " V")
    gcs:send_text(7, "Instantaneous current: " .. current_amps .. " A")
    gcs:send_text(7, "Consumed capacity: " .. consumed_mah .. " mAh")

    -- Schedule next battery check in 1000 ms (1 second)
    return get_battery, 1000
end

-- Start the script
return get_battery()
