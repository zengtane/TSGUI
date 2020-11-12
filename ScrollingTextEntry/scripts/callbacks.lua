--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local gDelKey = 8
local gEnterKey = 13
local gCtrlKey = 2
local gNote = "Textfield_layer.notetext"
local gKeyPressTimeoutId
local gSI

require("text_scroll")

function CBInit(mapargs)
  local data = gre.get_data(gNote..".font", gNote..".font_size")
  gSI = ScrollInfo.create(gNote, data[gNote..".font"], data[gNote..".font_size"], true, nil, nil, nil, nil, 3)
  gSI:init(true)
end

function CBKeyPress(mapargs)
  local keyPressed = mapargs.context_event_data.code
  local modifier = mapargs.context_event_data.modifiers
  local data = {}
  local text = gre.get_data(gNote..".text")[gNote..".text"]
  
  if (modifier ~= gCtrlKey) then
  if (keyPressed == gDelKey) then
    data[gNote..".text"] = string.sub(text,1,-2)
  elseif (keyPressed == gEnterKey) then
    data[gNote..".text"] = string.format("%s\n",text)
  else
    if pcall(function() string.char(keyPressed) end) then
      data[gNote..".text"] = string.format("%s%s",text,string.char(keyPressed))
    else
      -- This is where we could implement some extra logic for special keys
    end
  end
  end
  gre.set_data(data)

  if(gKeyPressTimeoutId ~= nil)then
    gre.timer_clear_timeout(id)
    gKeyPressTimeoutId = nil
  end

  local cb = function()
    if(gSI == nil) then
      print("No Scroll Info for " .. tostring(gNote))
      return
    end
    gSI:init(false)
    gSI:scrollArea(1)
    CBUpdateScrollBar()
  end
  gKeyPressTimeoutId = gre.timer_set_timeout(cb,50)
end

function CBScrollText(mapargs)
  if(gSI == nil) then
    return
  end
  gSI:scroll(mapargs.direction)
  CBUpdateScrollBar()
end

function CBUpdateScrollBar(mapargs)
  if(gSI == nil) then
    print("No Scroll Info for " .. tostring(gNote))
    return
  end

  local data= {}
  local scrollBarMarkerY
  local scrollBarMarkerPercent = 0
  local maxOffset = gSI:getValue("max_y")
  local offsetSize = gSI:getValue("line_height")
  local currentOffset = math.abs(gre.get_data(gNote..".texty")[gNote..".texty"])
  local noteArea = gre.get_control_attrs(gNote,"height")
  local offsetDelta = maxOffset - noteArea.height
  local scrollTicks = math.max(1, math.floor(offsetDelta / offsetSize))
  local scrollBarControlHeight = gre.get_control_attrs("Textfield_layer.ScrollBar.background","height")["height"]
  local scrollBarButtonControlHeight = gre.get_control_attrs("Textfield_layer.ScrollBar.upButton","height")["height"]
  local scrollBarMarkerControlHeight =  gre.get_control_attrs("Textfield_layer.ScrollBar.marker","height")["height"]

  for i = scrollTicks,0,-1 do
    if(currentOffset >= i*offsetSize) then
      scrollBarMarkerPercent = (i * offsetSize)/(scrollTicks * offsetSize)
      break
    end
  end

  scrollBarMarkerY = ((scrollBarControlHeight - (scrollBarMarkerControlHeight + scrollBarButtonControlHeight * 2)) * scrollBarMarkerPercent) + scrollBarButtonControlHeight
  data["y"] = scrollBarMarkerY
  gre.set_control_attrs("Textfield_layer.ScrollBar.marker",data)
end

local gPressed = false
local gScrollBarY = "Textfield_layer.ScrollBar.grd_y"
local gScrollBarHeight = "Textfield_layer.ScrollBar.background.grd_height"
local gScrollButtonHeight  = "Textfield_layer.ScrollBar.downButton.grd_height"
local gScrollHandleHeight = "Textfield_layer.ScrollBar.marker.grd_height"
local gScrollHandleY = "Textfield_layer.ScrollBar.marker.grd_y"
local gScrollPress = 0
local gScroll

function CBScrollDrag(mapargs)
  local y
  local scrollPercent
  local yDelta
  gScroll = gre.get_data(gScrollBarY, gScrollBarHeight, gScrollButtonHeight, gScrollHandleHeight, gScrollHandleY)

  if(mapargs.context_event == "gre.press") then
    gPressed = true
    gScrollPress = mapargs.context_event_data.y
  elseif(mapargs.context_event == "gre.motion") then
    if(gPressed) then
      if(gSI:getValue("target_height") > gSI:getValue("max_y")) then
        return
      end
      yDelta = mapargs.context_event_data.y - gScrollPress
      gScrollPress = mapargs.context_event_data.y
      y = gScroll[gScrollHandleY] + yDelta

      if(y <= (gScroll[gScrollButtonHeight])) then
        y = gScroll[gScrollButtonHeight]
        scrollPercent = 0
      elseif(y >= (gScroll[gScrollBarHeight] - gScroll[gScrollButtonHeight] - gScroll[gScrollHandleHeight])) then
        y = gScroll[gScrollBarHeight] - gScroll[gScrollButtonHeight] - gScroll[gScrollHandleHeight]
        scrollPercent = 1
      else
        scrollPercent = y / (gScroll[gScrollBarHeight] - (gScroll[gScrollButtonHeight] * 2) - gScroll[gScrollHandleHeight])
      end
      gre.set_value(gScrollHandleY,y)
      gSI:scrollArea(scrollPercent)
    end
  elseif(mapargs.context_event == "gre.release" or mapargs.context_event == "gre.outbound") then
    gPressed = false
    gScrollPress = 0
  end
end
