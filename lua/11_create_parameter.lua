--[[
    Script: Create and Use Custom Parameters
    Description:
        Demonstrates how to define a custom parameter table and add parameters
        using the ArduPilot Lua scripting API. The script creates three parameters
        with the prefix "ASD_", modifies one of them, and logs the results to GCS.
--]]

function create_parameter()
    -- Unique identifier for the custom parameter table (must be 0–255 and not in use)
    local TABLE_KEY = 42

    -- Attempt to register a parameter table with prefix "ASD_" and 3 entries
    if not param:add_table(TABLE_KEY, "ASD_", 3) then
        gcs:send_text(7, "Unable to add ASD_ table")
        return
    end
    gcs:send_text(7, "Successfully added ASD_ table")

    -- Add ASD_PARM_1 with default value 1.0
    if not param:add_param(TABLE_KEY, 1, "PARM_1", 1.0) then
        gcs:send_text(7, "Unable to add ASD_PARM_1")
        return
    end
    gcs:send_text(7, "Added ASD_PARM_1")

    -- Add ASD_PARM_2 with default value 2.0
    if not param:add_param(TABLE_KEY, 2, "PARM_2", 2.0) then
        gcs:send_text(7, "Unable to add ASD_PARM_2")
        return
    end
    gcs:send_text(7, "Added ASD_PARM_2")

    -- Add ASD_PARM_3 with default value 3.0
    if not param:add_param(TABLE_KEY, 3, "PARM_3", 3.0) then
        gcs:send_text(7, "Unable to add ASD_PARM_3")
        return
    end
    gcs:send_text(7, "Added ASD_PARM_3")

    -- Create a Parameter object for ASD_PARM_1
    local ASD_PARM_1 = Parameter()
    if not ASD_PARM_1:init("ASD_PARM_1") then
        gcs:send_text(7, "Failed to initialize ASD_PARM_1")
        return
    end

    -- Print current value of ASD_PARM_1
    gcs:send_text(7, "Current value of ASD_PARM_1: " .. ASD_PARM_1:get())

    -- Update the value of ASD_PARM_1 to 1.5
    local result = ASD_PARM_1:set(1.5)
    gcs:send_text(7, "Set operation result: " .. tostring(result))

    -- Print updated value
    gcs:send_text(7, "Updated value of ASD_PARM_1: " .. ASD_PARM_1:get())

    -- Optionally schedule this function to run again
    -- return create_parameter, 1000
end

-- Execute the parameter creation function
return create_parameter()
