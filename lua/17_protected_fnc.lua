--[[
    Script: Demonstrate protected function calls using pcall
    Description:
        Uses pcall to safely call a function that may cause a runtime error.
        pcall returns a status boolean and either the function result or an error message.
--]]

-- Function that intentionally causes an error by adding a number and a string
function add()
    return 1 + "a"  -- causes a runtime error
    -- return 1 + 2
end

-- Function that calls 'add' safely using pcall
function protected_call()
    local success, result = pcall(add)
    if success then
        gcs:send_text(7, "Success, result: " .. tostring(result))
    else
        gcs:send_text(7, "Caught error: " .. tostring(result))
    end
    gcs:send_text(7, "Called the function")
end

-- Start the script by calling protected_call
return protected_call()
