--[[
    Finaly found out how to read fixture-attributes from a cue! See main function for comments. Still dont know a way to change them unless you use MA-commands
--]]

local function dump_table(t)
    local function parse_table(t, t_copy, indent)
        local t_copy = t_copy or {}
        local indent = indent or 0

        for key, value in pairs(t) do
            local keytype = type(key)

            if type(value) == "table" then
                local entry = {}
                table.insert(t_copy, {indent, key, entry, keytype})
                parse_table(value, entry, indent+1)
            else
                table.insert(t_copy, {indent, key, value, keytype})
            end
        end

        return t_copy
    end
    local table = parse_table(t)

    local function print_table(t)
        for _, value in ipairs(t) do
            local indent = string.rep("    ", value[1])
            if type(value[3]) == "table" then
                Printf(indent..tostring(value[2].." = { (keytype: "..value[4]..")"))
                print_table(value[3])
                Printf(indent.."}")
            else
                Printf(indent..tostring(value[2])..", "..tostring(value[3]).." (keytype: "..value[4]..")")
            end
        end
    end
    print_table(table)
end

local function main(screens, args)
    -- Get cue handle
    local cue = DataPool()[6][1][3]
    -- Get cuepart-handle
    local cuepart = cue[1]
    -- GetPresetData() on a cue returns nil
    local cue_preset_data = GetPresetData(cue)
    if cue_preset_data == nil then
        Printf("Cue preset data is nil")
    end
    -- GetPresetData() on a cuepart gives you a nested lua table
    local cuepart_preset_data = GetPresetData(cuepart)
    if cuepart_preset_data == nil then
        Printf("Cuepart preset data is nil")
    end

    -- So, appareantly cueparts can be retrieved as presets with GetPresetData. There is no Dump-method built in, so this plugin has its own method to dump lua-tables
    dump_table(cuepart_preset_data)
end

return main