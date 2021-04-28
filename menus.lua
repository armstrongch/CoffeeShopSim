--special characters:
--❎🅾️⬆️⬇️⬅️➡️
function _init()
	mode = 0
	setup_control()
	debug = false --CHANGE THIS BEFORE RELEASE
end

function _update()
	update_control()
	if (mode == 0) then title()
	elseif (mode == 1) then menu()
	elseif (mode == 2) then credits()
	elseif (mode == 3) then shop()
	elseif (mode == 4) then commute() end
end

function _draw()
	cls()
	palt(0, true)
	if (mode == 0) then draw_title()
	elseif (mode == 1) then draw_menu()
	elseif (mode == 2) then draw_credits()
	elseif (mode == 3) then draw_shop()
	elseif (mode == 4) then draw_commute() end
	
	if (debug) then
		if (mode == 3) then 
			local eval = evaluate_drink(left_drink, window.recipe_one)
			
			print("flavor: "..tostring(eval.correct_flavor).."\ningre: "..tostring(eval.correct_ingredients).."\nratio: "..tostring(eval.correct_ratio).."\ntemp: "..tostring(eval.not_too_cold).."\nfull: "..tostring(eval.not_too_empty), 4, 4, 0)
		end
	end
end

function title()
	if (btnp(5)) then
		setup_menu()
		--Don't play song unless we are moving from title to menu
		if (mode == 0) then play_song(0) end
		mode = 1
	end	
end

function draw_title()
	rectfill(0, 0, 127, 127, 12)
	local title = "game name"
	local credit = "a game by chris 'tb' armstrong"
	local instruction = "press ❎ to continue"
	print(title, hcenter(title), 32, 7)
	print(credit, hcenter(credit), 48, 7)
	print(instruction, hcenter(instruction), 64, 7)
end

function setup_menu()
	menu_options = {"new game", "how to play", "credits"}
	cursor_index = 1
	cursor_counter = 0
	max_cursor_counter = 15
end

function menu()
	if (btnp(2)) then
		cursor_index -= 1
		cursor_counter = 0
		if (cursor_index < 1) then cursor_index = count(menu_options) end
	end
	if (btnp(3)) then
		cursor_index += 1
		cursor_counter = 0
		if (cursor_index > count(menu_options)) then cursor_index = 1 end
	end
	
	cursor_counter += 1
	if (cursor_counter >= max_cursor_counter) then cursor_counter = 0 end
	
	if (btnp(5)) then
		if (cursor_index == 1) then
			setup_control()
			setup_commute()
			mode = 4
		elseif (cursor_index == 2) then
		elseif (cursor_index == 3) then mode = 2 end
	end
end

function draw_menu()
	rectfill(0, 0, 127, 127, 12)
	for i=1, count(menu_options) do
		print(menu_options[i], 24, 16+i*16, 7)
	end
	if (cursor_counter <= max_cursor_counter/2) then
		print("❎", 12, 16+cursor_index*16, 7)
	end
end

function credits()
	title() --same behavior as title screen: z+x brings up the main menu
end

function draw_credits()
	rectfill(0, 0, 127, 127, 7)
	print("v 0.3\n4-24-21\n\ncreated by\nchris 'turd boomerang'\narmstrong\n\nmusic by\ndj redbeard\n\n(❎)", 12, 16, 12)
end

function hcenter(s)
	--from pico8 fandom wiki
	return 64 - #s*2
end

function round(num, numDecimalPlaces)
	--from lua-users.org/wiki/SimpleRound
	local mult = 10^(numDecimalPlaces or 0)
	return flr(num * mult + 0.5) / mult
end