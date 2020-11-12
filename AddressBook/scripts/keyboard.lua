--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local gShifted = 0

function SplitString(inputstr, sep)
    if (sep == nil) then
      sep = "%s"
    end
    
    local t = {}
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
    end
    return t
end

function TriggerKey(code)
	local data = {}
	local len = string.len(code)
	local i = 1

	while (i <= len) do
		data["code"] = string.byte(code, i)
		data["modifiers"] = 0
		gre.send_event_data("gre.keydown", "4u1 code 4u1 modifiers", data)
		i = i + 1
	end
end

function TriggerRaw(code)
	local data = {}
	data["code"] = code
	data["modifiers"] = 0
	gre.send_event_data("gre.keydown", "4u1 code 4u1 modifiers", data)
end

function KeyboardShift(layer)
	local data = {}
	local image
	
	if (gShifted == 1) then
		image = "images/btn1_up.png"
		gShifted = 0
	else 
		image = "images/btn1_down.png"
		gShifted = 1
	end

	data[layer..".shift_R.image"] = image
	data[layer..".shift_L.image"] = image
	gre.set_data(data)
end

function CBKeyboardPress(mapargs)
	local data = {}

	if (mapargs.context_control == nil) then
		return
	end
	
	data = SplitString(mapargs.context_control, ".")
	local key_name = data[2]
	data = {}
	data = gre.get_data(mapargs.context_control..".char")
	local char = data[mapargs.context_control..".char"] 

	if (key_name == "backspace") then
		TriggerRaw(8)
		return
	elseif (key_name == "space") then
		TriggerRaw(32)
		return		
	elseif (key_name == "enter") or (key_name == "Enter") then
		TriggerRaw(13)
		return
	elseif (key_name == "abc" or key_name == "123") then
		return
	elseif (key_name == "shift_R" or key_name == "shift_L") then
		KeyboardShift(mapargs.context_layer)
		return
	else	
		if (gShifted ~= 1) then
			val = string.lower(char)
		else 	
			val = char
		end
	end
	
	TriggerKey(val)
end

function CBHasFocus(mapargs)
	local data = {}
	data[mapargs.context_control..".alpha"] = 255
	gre.set_data(data)
end

function CBLostFocus(mapargs)
	local data = {}
	data[mapargs.context_control..".alpha"] = 0
	gre.set_data(data)
end
