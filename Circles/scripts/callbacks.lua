--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

function CBUpdateIncrementCircleText(mapargs) 
  local data = {}
  data = gre.get_data("circle1.blue_fill.var")

  local val = data["circle1.blue_fill.var"]+90
  local percent = val/360
  local circle1_value = percent*100
  
  gre.set_data({["circ1_value"] = tostring(string.format("%d", circle1_value))})
end

function CBUpdateCircularFillText(mapargs) 
  local data = {}
  data = gre.get_data("circle2.orange_fill.var")

  local val = data["circle2.orange_fill.var"]+90
  local percent = val/360
  local circle2_value = percent*100
  
  gre.set_data({["circ2_value"] = tostring(string.format("%d", circle2_value))})
end

function CBUpdateDashedLineText(mapargs) 
  local data = {}
  data = gre.get_data("circle3.circle3_fill.var")

  local val = data["circle3.circle3_fill.var"]+90
  local percent = val/360
  local circle3_value = percent*100
  
  gre.set_data({["circ_3_value"] = tostring(string.format("%d", circle3_value))})
end

function CBUpdateBlackFadeText(mapargs) 
  local data = {}
  data = gre.get_data("black_fade.circle_blue.var")

  local val = data["black_fade.circle_blue.var"]+90
  local percent = val/360
  local circle6_value = percent*100
  
  gre.set_data({["circ_6_value"] = tostring(string.format("%d", circle6_value))})
end

function CBUpdateGaugeText(mapargs) 
  local data = {}
  data = gre.get_data("circle7.circ7_fill.var")

  local val = data["circle7.circ7_fill.var"]+225
  local percent = val/135+2
  local circle7_value = percent*100
  
  gre.set_data({["circ_7_value"] = tostring(string.format("%d", circle7_value))})
end
