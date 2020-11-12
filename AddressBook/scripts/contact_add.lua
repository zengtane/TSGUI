--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

local gBlankEntry = {
		first_name = "",
		last_name = "",
		address = "",
		email = "",
		office = "",
		mobile = "",
		home = "",
		image = "images/profile_pic.png",
		fav = 0
}

local gEntryOrder = {
	{
		display = "FIRST NAME",
		var = "input_layer.first_name.text",
		name = "first_name",
		y = 14
	},
	{
		display = "LAST NAME",
		var = "input_layer.last_name.text",
		name = "last_name",
		y = 34	
	},
	{
		display = "HOME",
		var = "input_layer.home_entry.text",
		name = "home",
		y = 53
	},
	{
		display = "MOBILE",
		var = "input_layer.mobile_entry.text",
		name = "mobile",
		y = 73
	},
	{
		display = "OFFICE",
		var = "input_layer.office_entry.text",
		name = "office",
		y = 93
	},
	{
		display = "EMAIL",
		var = "input_layer.email_entry.text",
		name = "email",
		y = 113
	},
	{
		display = "ADDRESS",
		var = "input_layer.address_entry.text",
		name = "address",
		y = 133
	},
}

local gCurrentEntry = {}
local gContactIndex = 0
local gEntryIndex = 1
local EDIT_LABEL = "input_layer.field_title2.text"


function LoadContact(contact, index)
  gCurrentEntry = contact
  gContactIndex = index
end

function LoadEntry(index)
	local data = {}
	data[EDIT_LABEL] = gEntryOrder[index].display
	data["input_layer.input_field1.text"] = gCurrentEntry[gEntryOrder[index].name]
	data["input_layer.selection_arrow1.grd_y"] = gEntryOrder[index].y 
	gre.set_data(data)
end

function CBPreviousEntry(mapargs)
	local data = {}
	data[gEntryOrder[gEntryIndex].var] = gCurrentEntry[gEntryOrder[gEntryIndex].name]
	gre.set_data(data)

	gEntryIndex = gEntryIndex - 1
	if (gEntryIndex < 1) then
		gEntryIndex = 1
	end
	LoadEntry(gEntryIndex)
end

function CBNextEntry(mapargs)
	local data = {}
	data[gEntryOrder[gEntryIndex].var] = gCurrentEntry[gEntryOrder[gEntryIndex].name]
	gre.set_data(data)
	gEntryIndex = gEntryIndex + 1
	if (gEntryIndex > table.maxn(gEntryOrder)) then
		gEntryIndex = table.maxn(gEntryOrder)
	end
	LoadEntry(gEntryIndex)
end

function CBEntrySubmit(mapargs)
  table.remove(address_book, gContactIndex)
  table.insert(address_book, gCurrentEntry)
  CBLoadList()
end

function ShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if (orig_type == 'table') then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function CBSetupNewEntry(mapargs)
  gCurrentEntry = ShallowCopy(gBlankEntry)
	local data = {}
	for i=1, table.maxn(gEntryOrder) do
		data[gEntryOrder[i].var] = ""
	end
	gre.set_data(data)
	
	gEntryIndex = 1
	LoadEntry(gEntryIndex)
end

function CBSetupEditEntry(mapargs)
  local data = {}
    for i=1, table.maxn(gEntryOrder) do
      local variable = gEntryOrder[i].name
      data[gEntryOrder[i].var] = gCurrentEntry[variable]
    end
  gre.set_data(data)
  gEntryIndex = 1
  LoadEntry(gEntryIndex)
end

function CBInputKeyEvent(mapargs)
	local data = {}

	key = mapargs.context_control..".text"
	data = gre.get_data(key)

	if (mapargs.context_event_data.code == 8) then
		-- backspace
		local len = string.len(data[key])
		len = len - 1
		local new = string.format("%s", string.sub(data[key],1,len))
		data[key] = new
		gre.set_data(data)
	elseif (mapargs.context_event_data.code == 13) then
		-- enter
		data[gEntryOrder[gEntryIndex].var] = gCurrentEntry[gEntryOrder[gEntryIndex].name]
		gre.set_data(data)
		gCurrentEntry[gEntryOrder[gEntryIndex].name] = data[key]
		CBNextEntry()
	else	
		data[key] = data[key]..string.char(mapargs.context_event_data.code)
		gre.set_data(data)
	end
	if (mapargs.context_event_data.code ~= 13) then
	  gCurrentEntry[gEntryOrder[gEntryIndex].name] = data[key]
	end
end
