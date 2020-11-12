--[[
Copyright 2016 Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local dragging = false
local lastIcon = nil
local patternPolyLine = ""
local patternCombination = ""
local lastPatternCombination
local locked = true

--- @param gre#context mapargs
function CBCustomGesture(mapargs) 
  if(locked == false) then
    return
  end

  if(mapargs.context_event == "gre.press") then
    dragging = true
    return
  end
  
  if(dragging ~= true) then
    return
  end
  
  if(mapargs.context_event == "gre.release" or mapargs.context_event == "gre.outbound") then
    dragging = false
    StopPatternLine()
    return
  end
  
  gre.set_value(mapargs.context_control..".alpha",255)
  DrawPatternLine(mapargs.context_control)
end

--- @param patternIcon path to the icon we are connecting
--  DrawPatternLine is executed to update the visual state of the pattern being drawn
function DrawPatternLine(patternIcon)
  if(patternIcon == lastIcon) then
    return
  end
  
  lastIcon = patternIcon
  local iconAttributes = gre.get_control_attrs(lastIcon,"x","y","width","height")
  local xVal = iconAttributes.x + (iconAttributes.width / 2)
  local yVal = iconAttributes.y + (iconAttributes.height / 2)
  patternPolyLine = patternPolyLine..gre.poly_string({{x=xVal,y=yVal}})
  patternCombination =  patternCombination .. gre.get_value(lastIcon..".id")
  gre.set_value("lock_layer.pattern_group.pattern_line.points",patternPolyLine)
end

--- StopPatternLine is called to stop drawing the pattern and do some logic to validate the pattern aginst previous patterns
function StopPatternLine()
  local data = {}
  if(patternCombination == lastPatternCombination) then
    data["lock_layer.icn_lock.image"] = "images/icn_unlock.png"
    locked = false
    lastPatternCombination = ""
    data["lock_layer.Swipe_pattern_to_unlock.text"] = "Press the lock to reset"
    data["lock_layer.pattern_group.grd_hidden"] = 1
  else
    lastPatternCombination = patternCombination
  end
  lastIcon = nil
  patternPolyLine = ""
  patternCombination = ""
  data["lock_layer.pattern_group.pattern_line.points"] = patternPolyLine
  
  for i=1, 9 do
    data[string.format("lock_layer.pattern_group.%d_control.alpha",i)] = 0
  end
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBSwipeGestures(mapargs)
  local x = "window_layer.Crank_Logo_Swipe.grd_x"
  local y = "window_layer.Crank_Logo_Swipe.grd_y"
  local data = gre.get_data(x, y)
  data[x] = data[x] + mapargs.context_event_data.x_move
  data[y] = data[y] + mapargs.context_event_data.y_move

  if(data[x] < 71)then
    data[x] = 71
  elseif(data[x] > 353)then
    data[x] = 353
  end
  
  if(data[y] < 22) then
    data[y] = 22
  elseif(data[y] > 255) then
    data[y] = 255
  end
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBRotateGesture(mapargs) 
  local data = gre.get_data("window_layer.Crank_Logo_Rotate.angle")
  local shift = tonumber(mapargs.context_event_data.value)
  local angle = tonumber(data["window_layer.Crank_Logo_Rotate.angle"])
  local newangle = angle + shift
  data["window_layer.Crank_Logo_Rotate.angle"] = newangle
  gre.set_data(data)
end

--- @param gre#context mapargs
function CBPinchGesture(mapargs)
  local xScale = "window_layer.Crank_Logo_Scale.wScale"
  local yScale = "window_layer.Crank_Logo_Scale.hScale"
  local data = gre.get_data(xScale, yScale)
  local shift = tonumber(mapargs.context_event_data.value)
  
  data[xScale] = data[xScale] * shift
  data[yScale] = data[yScale] * shift
  if data[xScale] > 358 * 1.75 then
    data[xScale] = 358 * 1.75
  end
  if(data[xScale] < 358 * 0.5) then
    data[xScale] = 358 * 0.5
  end
  if data[yScale] > 72 * 1.75 then
    data[yScale] = 72 * 1.75
  end
  if data[yScale] < 72 * 0.5 then
    data[yScale] = 72 * 0.5
  end
  gre.set_data(data);
end


--- @param gre#context mapargs
function CBLockPattern(mapargs) 
  if(locked == true) then
    return
  end
  local data = {}
  locked = true
  data["lock_layer.icn_lock.image"] = "images/icn_lock.png"
  data["lock_layer.Swipe_pattern_to_unlock.text"] = "Swipe the same pattern twice to unlock"
  data["lock_layer.pattern_group.grd_hidden"] = 0
  gre.set_data(data)
end
