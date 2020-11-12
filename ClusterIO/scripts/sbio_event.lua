--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

function CBUpdateEvent(mapargs)
	local ev = mapargs.context_event_data
	local data  = {}

	local speed_rot = (ev["speed"] * (214/200)) - 107
	local rpm_rot = (ev["rpm"] / 10000) * 49
	
	data["speedometer.pointer_speedometer.rot"] = speed_rot 
	data["speedometer_content.speed.text"] = tostring(ev["speed"])
	data["tach_exterior.pointer_tach_exterior.rot"] = rpm_rot
	
	gre.set_data(data)
end


