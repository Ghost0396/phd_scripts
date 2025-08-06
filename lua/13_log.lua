--[[
    Script: Write Custom Log Data to On-Board Logger
    Description:
        Logs latitude, longitude, and altitude to the on-board dataflash log
        under a custom log message type "ASD1".
        
    References:
        - AP_Logger: https://github.com/ArduPilot/ardupilot/blob/master/libraries/AP_Logger/README.md
        - mavlogdump.py tool: https://github.com/ArduPilot/pymavlink/blob/master/tools/mavlogdump.py
        - Example usage: mavlogdump.py 00000001.BIN --types=ASD1
--]]

-- Global data storage
local my_data = {}

-- Function to write data to the on-board logger
function save_to_log()
    -- Arguments: log type "ASD1", field names, format string ("f" = float), and data values
    logger:write("ASD1", "latitude,longitude,altitude", "fffi", my_data[1], my_data[2], my_data[3], my_data[4])
end

-- Main update function, called periodically
function update()
    -- Get current vehicle location
    local current_location = ahrs:get_location()

    if current_location then
        -- Convert location to degrees/meters
        my_data[1] = current_location:lat() * 1e-7
        my_data[2] = current_location:lng() * 1e-7
        my_data[3] = current_location:alt() * 1e-2
        my_data[4] = 4
        -- Log the data
        save_to_log()
    end

    -- Schedule next update in 1000 milliseconds (1 second)
    return update, 1000
end

-- Start the logging script
return update()
