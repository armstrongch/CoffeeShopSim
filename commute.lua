--r = road
--h = home
--x = not_your_house
--g = gas
--f = food
--w = work
--u = unmowed grass

function setup_commute()
	show_commute_ui = true
	show_commute_dialog = false
	commute_dialog_action = "none"
end

function commute()
	if (btnp(5)) then show_commute_ui = not show_commute_ui end
	
	local successful_move = false
	local move_x_change = 0
	local move_y_change = 0
	
	local target_location = ""
	
	if (btnp(0)) then
		if (control.player_commute_location_x > 0) then
			target_location = control.tile_map[control.player_commute_location_y+1][control.player_commute_location_x+1 - 1]
			move_x_change = -1
		end
	elseif (btnp(1)) then
		if (control.player_commute_location_x < 15) then
			target_location = control.tile_map[control.player_commute_location_y+1][control.player_commute_location_x+1 + 1]
			move_x_change = 1
		end
	elseif (btnp(2)) then
		if (control.player_commute_location_y > 0) then
			target_location = control.tile_map[control.player_commute_location_y+1 - 1][control.player_commute_location_x+1]
			move_y_change = -1
		end
	elseif (btnp(3)) then
		if (control.player_commute_location_y < 15) then
			target_location = control.tile_map[control.player_commute_location_y+1 + 1][control.player_commute_location_x+1]
			move_y_change = 1
		end
	end
	
	if (target_location == "r") then
		--if we're in the car and we have enough gas, move the car
		if ((control.gas > 0)
		and (control.car_commute_location_x == control.player_commute_location_x)
		and (control.car_commute_location_y == control.player_commute_location_y))
		then
			control.gas -= 1
			control.car_commute_location_x += move_x_change
			control.car_commute_location_y += move_y_change
			control.minute_hand -= 1
		end
		--move the player
		control.player_commute_location_x += move_x_change
		control.player_commute_location_y += move_y_change
		control.minute_hand += 2
		
		show_commute_dialog = false
		commute_dialog_action = "none"
		
	elseif (target_location == "h") then
		show_commute_dialog = true
		show_commute_ui = true
		commute_dialog_text = "go home\n? (🅾️)"
		commute_dialog_action = "home"
	elseif (target_location == "g") then
		show_commute_dialog = true
		show_commute_ui = true
		commute_dialog_text = "get gas\n? (🅾️)"
		commute_dialog_action = "gas"
	elseif (target_location == "f") then
		show_commute_dialog = true
		show_commute_ui = true
		commute_dialog_text = "buy\nfood\n? (🅾️)"
		commute_dialog_action = "food"
	elseif (target_location == "w") then
		show_commute_dialog = true
		show_commute_ui = true
		commute_dialog_text = "work a\nshift\n? (🅾️)"
		commute_dialog_action = "work"
	elseif (target_location == "u") then
		show_commute_dialog = true
		show_commute_ui = true
		commute_dialog_text = "mow the\nlawn\n? (🅾️)"
		commute_dialog_action = "grass"
	end
end

function draw_commute()
	
	rectfill(0,0,127,127,3)
	
	local houseCounter = 0
	for tile_y=1,16 do
		for tile_x=1,16 do
			local tile_char = control.tile_map[tile_y][tile_x]
			
			if (tile_char == "h") then spr(30,(tile_x-1)*8,(tile_y-1)*8)
			elseif (tile_char == "g") then spr(47,(tile_x-1)*8,(tile_y-1)*8)
			elseif (tile_char == "f") then spr(61,(tile_x-1)*8,(tile_y-1)*8)
			elseif (tile_char == "w") then spr(62,(tile_x-1)*8,(tile_y-1)*8)
			elseif (tile_char == "u") then spr(31,(tile_x-1)*8,(tile_y-1)*8)
			elseif (tile_char == "x") then
				if (houseCounter == 0) then spr(13,(tile_x-1)*8,(tile_y-1)*8)
				elseif(houseCounter == 1) then spr(14,(tile_x-1)*8,(tile_y-1)*8)
				elseif (houseCounter == 2) then spr(15,(tile_x-1)*8,(tile_y-1)*8)
				elseif (houseCounter == 3) then
					spr(29,(tile_x-1)*8,(tile_y-1)*8)
					houseCounter = -1
				end
				houseCounter += 1
			elseif (tile_char == "r") then
				rectfill((tile_x-1)*8, (tile_y-1)*8, (tile_x-1)*8+7, (tile_y-1)*8+7, 5)
				
				if (tile_x > 1) then
					if (control.tile_map[tile_y][tile_x-1] == "r") then
						spr(46,(tile_x-1)*8,(tile_y-1)*8)
					end
				end
				if (tile_x < 16) then
					if (control.tile_map[tile_y][tile_x+1] == "r") then
						spr(46,(tile_x-1)*8,(tile_y-1)*8, 1, 1, true, false)
					end
				end
				
				if (tile_y > 1) then
					if (control.tile_map[tile_y-1][tile_x] == "r") then
						spr(45,(tile_x-1)*8,(tile_y-1)*8)
					end
				end
				if (tile_y < 16) then
					if (control.tile_map[tile_y+1][tile_x] == "r") then
						spr(45,(tile_x-1)*8,(tile_y-1)*8, 1, 1, false, true)
					end
				end
			end
		end
	end
	
	if ((control.player_commute_location_x != control.car_commute_location_x)
	or (control.player_commute_location_y != control.car_commute_location_y))
	then
		spr(60,
			control.player_commute_location_x*8,
			control.player_commute_location_y*8)
	end
	spr(63,
		control.car_commute_location_x*8,
		control.car_commute_location_y*8)
		
	if (show_commute_ui) then
		local ui_x = 4
		if (control.player_commute_location_x <=8) then ui_x = 92 end	
		rectfill(ui_x, 4, ui_x+31, 123, 1)
		rectfill(ui_x+1, 5, ui_x+30, 106, 7)
		print("hide:\n(❎)", ui_x+2, 6, 1)
		print("cash:\n$"..control.tips, ui_x+2, 22, 3)
		print("hungry?", ui_x+2, 38, 4)
		if (control.hungry) then
			print("yes", ui_x+2, 44, 4)
		else
			print("no", ui_x+2, 44, 4)
		end
		print("gas:", ui_x+2, 54, 8)
		rect(ui_x+2, 60, ui_x+29, 65, 1)
		rectfill(ui_x+3, 61, ui_x+3+(25*control.gas/control.max_gas), 64, 8)
		
		spr(35, ui_x+8, 108, 1,1,false,false)
		spr(35, ui_x+16, 108, 1,1,true,false)
		spr(35, ui_x+8, 116, 1,1,false,true)
		spr(35, ui_x+16, 116, 1,1,true,true)
		
		line(ui_x+16, 116,
			ui_x+16 - sin(0.5-control.minute_hand/60)*4,
			116 + cos(0.5-control.minute_hand/60)*4, 2)
		
		line(ui_x+16, 116,
			ui_x+16 - sin(0.5-control.second_hand/60)*6,
			116 + cos(0.5-control.second_hand/60)*6, 2)
			
		if (show_commute_dialog) then
			print(commute_dialog_text,ui_x+2, 70, 1)
		end
	end
end

