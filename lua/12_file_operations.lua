--[[
    Script: Read and Write Location Data to File
    Description:
        This script logs the current location (latitude, longitude, altitude) of the vehicle
        to a CSV file on the SD card once per second. It also provides a function to process
        existing lines in the file if needed (commented out).
--]]

local ALT_FRAME_ABOVE_HOME = 1
local FILE_PATH = "/scripts/LOCATION_DATA.csv"

local file
local location_data = {}

-- Split a comma-separated string into a table
function split_with_comma(str)
    local fields = {}
    for field in str:gmatch("([^,]+)") do
        fields[#fields + 1] = field
    end
    return fields
end

-- Read all lines from a file
function lines_from(file_path)
    local lines = {}
    for line in io.lines(file_path) do
        lines[#lines + 1] = line
    end
    return lines
end

-- Save a single line of location data to the file
function save_to_file()
    if not file then
        gcs:send_text(7, "Unable to open file: " .. FILE_PATH)
        return
    end

    -- Format: timestamp, lat, lng, alt
    local line = string.format("%d, %.7f, %.7f, %.2f\n",
        millis(),
        location_data[1],
        location_data[2],
        location_data[3]
    )

    file:write(line)
    file:flush()
end

-- Main function to read location and write to file
function read_write()
    local current_location = ahrs:get_location()

    if current_location and current_location:change_alt_frame(ALT_FRAME_ABOVE_HOME) then
        -- Convert coordinates to degrees and meters
        location_data[1] = current_location:lat() * 1e-7
        location_data[2] = current_location:lng() * 1e-7
        location_data[3] = current_location:alt() * 1e-2

        -- Save to file
        save_to_file()
    end

    -- Schedule the function to run again in 1000ms (1 second)
    return read_write, 1000
end

-- Open the file in append mode
file = io.open(FILE_PATH, "a")
if not file then
    gcs:send_text(7, "Unable to open file: " .. FILE_PATH)
end

-- Optional: Read and print first line of existing data
--[[
local first_line = lines_from(FILE_PATH)[1]
if first_line then
    local values = split_with_comma(first_line)
    local time_stamp = tonumber(values[1])
    local latitude = tonumber(values[2])
    local longitude = tonumber(values[3])
    local altitude = tonumber(values[4])

    gcs:send_text(7, "Time: " .. time_stamp ..
                      " Lat: " .. latitude ..
                      " Lng: " .. longitude ..
                      " Alt: " .. altitude)
end
]]

-- Start the script
return read_write()
