--[[
Copyright 2016, Crank Software Inc.
All Rights Reserved.
For more information email info@cranksoftware.com
** FOR DEMO PURPOSES ONLY **
]]--

require "contacts"

local gPreviousIndex = 0
local gIndex = 0


function CBLoadList(mapargs) 
	local data = {}
	
	table.sort(address_book, 
			function(e1, e2)
    			return e1.last_name < e2.last_name
  			end
		)
	
	for i=1, table.maxn(address_book) do
		data["table_layer.contact_list.txt."..i..".1"] = address_book[i].first_name.." "..address_book[i].last_name
		data["table_layer.contact_list.img."..i..".1"] = "images/cell_1.png"
		if (address_book[i].fav == 1)  then
			data["table_layer.contact_list.fav_alpha."..i..".1"] = 255
		else
			data["table_layer.contact_list.fav_alpha."..i..".1"] = 0
		end
	end
	gre.set_data(data)
	
	data = {}
	data["rows"] = table.maxn(address_book) 
	gre.set_table_attrs("table_layer.contact_list", data)
end

function CBContactPress(mapargs) 
	local data = {}
	
	if (mapargs.context_screen ==  "address_book_screen") then
		gre.send_event("CONTACT_SCREEN")
	end
	
	gIndex = mapargs.context_row
	
	data["table_layer.contact_list.img."..gPreviousIndex..".1"] = "images/cell_1.png"
	data["table_layer.contact_list.img."..gIndex..".1"] = "images/cell_highlight-2.png"
	gPreviousIndex = gIndex
	
	data["contact_select_layer.contact_name.text"] = address_book[gIndex].first_name.." "..address_book[gIndex].last_name
	data["contact_select_layer.home.text"] = address_book[gIndex].home
	data["contact_select_layer.mobile.text"] = address_book[gIndex].mobile
	data["contact_select_layer.office.text"] = address_book[gIndex].office
	data["contact_select_layer.email.text"] = address_book[gIndex].email
	data["contact_select_layer.address.text"] = address_book[gIndex].address
	data["contact_select_layer.profile_pic.img"] = address_book[gIndex].image
	LoadContact(address_book[gIndex], gIndex)
	gre.set_data(data)
end

function CBFavToggle(mapargs)
	local data = {}
	
	if (address_book[gIndex].fav == 0)  then
		address_book[gIndex].fav = 1
		data["table_layer.contact_list.fav_alpha."..gIndex..".1"] = 255
	else
		address_book[gIndex].fav = 0
		data["table_layer.contact_list.fav_alpha."..gIndex..".1"] = 0
	end
	gre.set_data(data)	
end

function CBRemoveContact(mapargs)
	local data = {}
	table.remove(address_book, gIndex)
	CBLoadList()
end

function CBDeletePress(mapargs) 
	local data = {}
	data["delete_contact_layer.delete_name.text"] = address_book[gIndex].first_name.." "..address_book[gIndex].last_name
	gre.set_data(data)
	gre.send_event("DELETE_SCREEN")
end
