--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local gToggleState = {} -- table used to track state for all toggles
local gCur5dayToggle = false
local gCur5dayAnimationActive = false

--This is used to properly scale the toggle animation no matter the size of
--the application.  The ratio is based off of the initial development size of 800x480.

local ORIG_SLIDER_WIDTH = 140
local ORIG_SLIDER_HEIGHT = 58


function CBToggleControl(mapargs) 
	local animationStep = {}
	local data = gre.get_data("fan_layer.slider_ac_control.grd_width", "fan_layer.slider_ac_control.grd_height")
  local newControlWidth = data["fan_layer.slider_ac_control.grd_width"]
  local newControlHeight = data["fan_layer.slider_ac_control.grd_height"]
  local scaleW = newControlWidth/ORIG_SLIDER_WIDTH
  local scaleH = newControlHeight/ORIG_SLIDER_HEIGHT
  
	if (gToggleState[mapargs.context_control] == nil) then
	  -- if it doesn't exisit yet create the toggle and set it to off
		gToggleState[mapargs.context_control] = 0
	end
	
	local id = gre.animation_create(60, 1)
	animationStep["rate"] = "linear"
	animationStep["duration"] = 250
	animationStep["key"] = mapargs.context_control..".x_off"

	if (gToggleState[mapargs.context_control] == 0) then
		gToggleState[mapargs.context_control] = 1
		animationStep["from"] = 0
		animationStep["to"] = 62 * scaleW
	else
		gToggleState[mapargs.context_control] = 0
		animationStep["from"] = 62 * scaleW
		animationStep["to"] = 0
	end
	
	gre.animation_add_step(id, animationStep)
	gre.animation_trigger(id)
	
	if (mapargs.context_control == "settings_layer.degrees_toggle") then
		ChangeDegrees(gToggleState[mapargs.context_control])
	end
end

function CBShow5dayComplete()
  gCur5dayToggle = true
  gCur5dayAnimationActive = false
end

function CBHideMonToFriComplete()
  gCur5dayToggle = false
  gCur5dayAnimationActive = false
end

function CBToggleCur5day()
  if (gCur5dayToggle == false) then
    if (gCur5dayAnimationActive == false) then
      gCur5dayAnimationActive = true
      gre.send_event("run_show_5day")
    end
  else
    if (gCur5dayAnimationActive == false) then
      gCur5dayAnimationActive = true
      gre.send_event("run_hide_mon_to_fri")
    end
  end
end
