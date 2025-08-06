--[[
    Script: Parameter Get/Set Example
    Description:
        Demonstrates how to get and set a parameter from Lua in ArduPilot.
        It reads the value of the parameter SCR_USER1, sets it to 1,
        and prints both the old and new values to the GCS.
--]]

--- Reads and modifies the SCR_USER1 parameter.
-- Notifies the GCS of current and updated values.
function get_set_parameter()

    -- Create SCR_USER1 parameter object
    local SCR_USER1 = Parameter()
    if not SCR_USER1:init("SCR_USER1") then
        gcs:send_text(7, "Failed to initialize the parameter")
        return
    end

    -- Notify the user about the current parameter value
    gcs:send_text(7, "Value of SCR_USER1: " .. SCR_USER1:get())

    -- Set the parameter to 1
    local result = SCR_USER1:set(1)

    -- Notify the user about the result of the set operation
    gcs:send_text(7, "Parameter set operation result: " .. tostring(result))

    -- Notify the user about the updated parameter value
    gcs:send_text(7, "Value of SCR_USER1: " .. SCR_USER1:get())

    -- No repeat loop in this example
    -- return get_set_parameter, 1000
end

-- Start the script
return get_set_parameter()
