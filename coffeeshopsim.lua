--special characters:
--❎🅾️⬆️⬇️⬅️➡️
function _init()
	mode = 0
	debug = false --CHANGE THIS BEFORE RELEASE
end

function _update()
	if (mode == 0) then title()
	elseif (mode == 1) then menu()
	elseif (mode == 2) then credits()
	elseif (mode == 3) then game() end
end

function _draw()
	cls()
	palt(0, true)
	if (mode == 0) then draw_title()
	elseif (mode == 1) then draw_menu()
	elseif (mode == 2) then draw_credits()
	elseif (mode == 3) then draw_game() end
	
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
			setup_game()
			mode = 3
		elseif (cursor_index == 2) then --TO-DO: Add tutorial?
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
	print("v 0.2\n4-18-21\n\ncreated by\nchris 'turd boomerang'\narmstrong\n\n(❎)", 12, 16, 12)
end


bev_flavors = {"sugar", "cocoa", "maple", "caramel"}
bev_type = 
{
	{name = "water",
		ingredients = {water = 1}},
	{name = "coffee",
		ingredients = {coffee = 1}},
	{name = "red eye",
		ingredients = {coffee = 2, espresso = 1}},
	{name = "black eye",
		ingredients = {coffee = 1, espresso = 1}},
	{name = "americano",
		ingredients = {water = 2, espresso = 1}},
	{name = "macchiato",
		ingredients = {milk = 2, espresso = 1}},
	{name = "latte",
		ingredients = {milk = 3, espresso = 1}},
	{name = "chai latte",
		ingredients = {milk = 3, chai = 1}}
}

function create_new_drink()
	local drink = {}
	drink.ingredients = {
		water = 0,
		coffee = 0,
		espresso = 0,
		milk = 0,
		sugar = 0,
		cocoa = 0,
		caramel = 0,
		maple = 0,
		chai = 0
	}
	drink.fill_count = 0 --min 0, max 16
	drink.temp = 0 -- min 0, max 10
	
	return drink
end

function evaluate_drink(drink, recipe)
	
	local evaluation = {}
	--correct_flavor, correct_ingredients, correct_ratio, not_too_cold, not_too_empty
	
	if (recipe.has_flavor) then
		evaluation.correct_flavor = drink.ingredients[recipe.flavor] > 0
	else
		evaluation.correct_flavor = 
			((drink.ingredients.sugar == 0)
			and (drink.ingredients.cocoa == 0)
			and (drink.ingredients.caramel == 0)
			and (drink.ingredients.maple == 0))
	end
	
	
	evaluation.correct_ingredients = true
	--for each ingredient in the drink

	for i, v in pairs(drink.ingredients) do
		if (v > 0) then 
			local good_ingredient = false
			if (recipe.has_flavor) then
				if (recipe.flavor == i) then
					good_ingredient = true
				end
			end
			for ri, rr in pairs(recipe.type.ingredients) do
				if (ri == i) then
					good_ingredient = true
				end
			end
			if (not good_ingredient) then
				evaluation.correct_ingredients = false
			end
		end
	end
	
	evaluation.correct_ratio = true
	local ingredient_count = 0
	local ratio = 0
	local calculated_ratio = 0
	for i, c in pairs(recipe.type.ingredients) do
		if (ingredient_count == 0) then
			ratio = c
			calculated_ratio = drink.ingredients[i]
		else
			ratio = ratio/c
			calculated_ratio = calculated_ratio / drink.ingredients[i]
		end
		ingredient_count += 1
	end
	if (ingredient_count > 1) then
		if (abs(ratio - calculated_ratio) >= 0.2) then
			evaluation.correct_ratio = false
		end
	end
	
	evaluation.not_too_cold = (drink.temp > 0)
	evaluation.not_too_empty = (drink.fill_count > 14)
	
	evaluation.correct_count = (evaluation.correct_flavor and 1 or 0)
		+ (evaluation.correct_ingredients and 1 or 0)
		+ (evaluation.correct_ratio and 1 or 0)
		+ (evaluation.not_too_cold and 1 or 0)
		+ (evaluation.not_too_empty and 1 or 0)
	
	return evaluation
end
function generate_recipe()
	local recipe = {}
	recipe.type = rnd(bev_type)
	
	if (recipe.type.name != "water") then
		recipe.flavor = rnd(bev_flavors)
		recipe.has_flavor = true
	else
		recipe.has_flavor = false
	end
	recipe.text = recipe.type.name.."\n"
	
	local name_str = ""
	local ratio_str = ""
	local ingredient_count = 0
	
	for name, ratio in pairs(recipe.type.ingredients) do
		if (ingredient_count > 0) then
			name_str = name_str..":"
			ratio_str = ratio_str..":"
		end
		ingredient_count += 1
		name_str = name_str..name
		ratio_str = ratio_str..ratio
	end
	
	if (ingredient_count > 1) then
		recipe.text = recipe.text.." "..ratio_str.." "..name_str.."\n"
	end
	
	if (recipe.has_flavor) then
		recipe.text = recipe.text.." with "..recipe.flavor
	end
	
	return recipe;
end

function create_new_window()
	local new_window = {}
	new_window.arrival_countdown = 60
	new_window.customer_index = flr(rnd(4))
	new_window.active_recipe = false
	new_window.recipe_one = generate_recipe()
	new_window.recipe_two = generate_recipe()
	
	new_window.eval_one = {}
	new_window.evaluated_left = false
	new_window.eval_two = {}
	new_window.evaluated_right = false
	new_window.calculated_drinks = false
	
	new_window.update = function()
		window.arrival_countdown -=1
		if ((player.x >= 7*8)
		and (player.x < 9*8)
		and (player.y >= 12.5*8)) then
			if (left_drink.fill_count > 0) then
				window.eval_one = evaluate_drink(left_drink, window.recipe_one)
				left_drink = create_new_drink()
				window.evaluated_left = true
			end
			if (right_drink.fill_count > 0) then
				window.eval_two = evaluate_drink(right_drink, window.recipe_two)
				right_drink = create_new_drink()
				window.evaluated_right = true
			end
			
			if ((window.evaluated_right)
			and (window.evaluated_left)
			and (not window.calculated_drinks))
			then
				window.calculated_drinks = true
				local total_correct_count = window.eval_one.correct_count + window.eval_two.correct_count
				
				player.tips += total_correct_count*0.1
				player.tips = round(player.tips, 2)
				if (total_correct_count < 6) then
					player.complaints += 1
				end
			end
		end
	end
	
	new_window.draw = function()
		spr(38 + 2*(window.customer_index%2) + 16*flr(window.customer_index/2), 56, 116)
		spr(39 + 2*(window.customer_index%2) + 16*flr(window.customer_index/2), 64, 116)
		
		if (window.arrival_countdown > 0) then
			if (window.arrival_countdown > 5) then
				rectfill(56, 116, 72, 124, 13)
			else
				rectfill(56 ,116, 64-8*(1-window.arrival_countdown/5), 124, 13)
				rectfill(64+8*(1-window.arrival_countdown/5),116, 72, 124, 13)
			end
		else
			rect(20, 56, 108, 104, 5)
			line(60, 104, 64, 110, 5)
			line(64, 104, 5)
			
			print("i want a "..window.recipe_one.text.." (🅾️)", 24, 60, 5)
			print("and a "..window.recipe_two.text.." (❎)", 24, 84, 5)
		end
	end
	
	return new_window
end

function setup_game()
	right_drink = create_new_drink()
	left_drink = create_new_drink()
	window = create_new_window()
	
	player = {}
	player.x = 12*8
	player.y = 5*8
	player.walkspeed = 1
	player.walk_animation_counter = -1
	player.max_walk_animation_counter = 9
	player.flip_horizontal = false
	player.selected_ingredient = ""
	player.selected_temp = 0
	player.tips = 0
	player.complaints = 0
	player.filling_left = false
	player.filling_right = false
	player.update = function()
		--move
		if (btn(0)) then
			player.x -= player.walkspeed
			player.flip_horizontal = true
		elseif (btn(1)) then
			player.x += player.walkspeed
			player.flip_horizontal = false
		end
		if (btn(2)) then player.y -= player.walkspeed
		elseif (btn(3)) then player.y += player.walkspeed end
		--don't move outside the room
		if (player.x < 16) then player.x = 16
		elseif (player.x > 104) then player.x = 104 end
		if (player.y < 16) then player.y = 16
		elseif (player.y > 104) then player.y = 104 end
		--animate walk cycle
		if not (btn(0) or btn(1) or btn(2) or btn(3)) then
			player.walk_animation_counter = -1
		else
			player.walk_animation_counter += 1;
			if (player.walk_animation_counter > player.max_walk_animation_counter) then
				player.walk_animation_counter = 0
			end
		end
		
		if (abs(player.y-24) <= 4) then
			if (abs(player.x-24) <= 4) then
				player.selected_ingredient = "water"
				player.selected_temp = 3
			elseif (abs(player.x-40) <= 4) then
				player.selected_ingredient = "coffee"
				player.selected_temp = 8
			elseif (abs(player.x-56) <= 4) then 
				player.selected_ingredient = "espresso" 
				player.selected_temp = 10
			elseif (abs(player.x-72) <= 4) then
				player.selected_ingredient = "milk"
				player.selected_temp = 0
			elseif (abs(player.x-88) <= 4) then
				player.selected_ingredient = "sugar"
				player.selected_temp = 5
			else player.selected_ingredient = "" end
		elseif (abs(player.y-40) <= 4) then
			if (abs(player.x-32) <= 4) then
				player.selected_ingredient = "cocoa"
				player.selected_temp = 5
			elseif (abs(player.x-48) <= 4) then
				player.selected_ingredient = "caramel"
				player.selected_temp = 5
			elseif (abs(player.x-64) <= 4) then
				player.selected_ingredient = "maple"
				player.selected_temp = 3
			elseif (abs(player.x-80) <= 4) then
				player.selected_ingredient = "chai"
				player.selected_temp = 5
			else player.selected_ingredient = "" end
		else
			player.selected_ingredient = ""
		end
		
		if (player.selected_ingredient != "") then
			if ((btn(4)) and (left_drink.fill_count < 16)) then
				left_drink.ingredients[player.selected_ingredient] += 0.2
				left_drink.temp = (left_drink.temp*left_drink.fill_count + player.selected_temp*0.2) / (left_drink.fill_count+0.2)
				left_drink.fill_count += 0.2
				player.filling_left = true
			else
				player.filling_left = false
			end
			if ((btn(5)) and (right_drink.fill_count < 16))  then
				right_drink.ingredients[player.selected_ingredient] += 0.2
				right_drink.temp = (right_drink.temp*right_drink.fill_count + player.selected_temp*0.2) / (right_drink.fill_count+0.2)
				right_drink.fill_count += 0.2
				player.filling_right = true
			else
				player.filling_right = false
			end
		else
			player.filling_right = false
			player.filling_left = false
		end
		
		left_drink.temp -= 0.02
		right_drink.temp -= 0.02
		if (left_drink.temp < 0) then left_drink.temp = 0 end
		if (right_drink.temp < 0) then right_drink.temp = 0 end
		
		if ((window.calculated_drinks) and btnp(5)) then
			window = create_new_window()
		end
	end
	
	player.draw = function()
		if (player.walk_animation_counter == -1) then
			spr(2, player.x, player.y, 1, 1, player.flip_horizontal, false)
		elseif (player.walk_animation_counter > player.max_walk_animation_counter/2) then
			spr(16, player.x, player.y, 1, 1, player.flip_horizontal, false)
		else
			spr(17, player.x, player.y, 1, 1, player.flip_horizontal, false)
		end
	end
end

function game()
	player.update()
	window.update()
end

function draw_game()
	rectfill(0, 0, 127, 127, 7)
	
	rectfill(116, 52-right_drink.fill_count, 124, 52, 1) --rightDrink
	rectfill(4, 52-left_drink.fill_count, 12, 52, 1) --leftDrink
	
	if (player.filling_right) then
		rectfill(120, 32, 120, 52, 1) --rightDrink
	end
	if (player.filling_left) then
		rectfill(7, 32, 7, 52, 1) --leftDrink
	end
	
	map(0, 0, 0, 0)
	
	--draw mirrored coffee hand
	if (not window.evaluated_left) then
		spr(11, 8, 32, 1, 1, true, false)
		spr(27, 8, 40, 1, 1, true, false)
		spr(43, 8, 48, 1, 1, true, false)
		spr(12, 0, 32, 1, 1, true, false)
		spr(28, 0, 40, 1, 1, true, false)
		spr(44, 0, 48, 1, 1, true, false)
		
		--themometer
		spr(32, 4, 72)
		rectfill(6, 60, 9, 72, 7)
		rectfill(7, 72-left_drink["temp"], 8, 72, 8)
		
		print("🅾️", 4, 24, 7)
	else
		spr(1, 8, 32, 1, 1, true, false)
		spr(1, 8, 40, 1, 1, true, false)
		spr(1, 8, 48, 1, 1, true, false)
		spr(1, 0, 32, 1, 1, true, false)
		spr(1, 0, 40, 1, 1, true, false)
		spr(1, 0, 48, 1, 1, true, false)
	end
	
	if (window.evaluated_right) then
		spr(1, 112, 32, 1, 1, true, false)
		spr(1, 112, 40, 1, 1, true, false)
		spr(1, 112, 48, 1, 1, true, false)
		spr(1, 120, 32, 1, 1, true, false)
		spr(1, 120, 40, 1, 1, true, false)
		spr(1, 120, 48, 1, 1, true, false)
	else
		--themometer
		spr(32, 116, 72)
		rectfill(118, 60, 121, 72, 7)
		rectfill(119, 72-right_drink["temp"], 120, 72, 8)
		
		print("❎", 118, 24, 7)
	end

	window.draw()
	player.draw()
	
	print(player.selected_ingredient, hcenter(player.selected_ingredient), 9, 7)
	
	rectfill(2,116,28,124,7)
	print("$"..tostring(player.tips), 3, 118, 11)
	rectfill(96,116,126,124,7)
	spr(34,100,118)
	print(tostring(player.complaints), 113, 118, 8)
	
	if (window.calculated_drinks) then
		rectfill(16,16,112,112,7)
		print("drinks: ", 20, 20, 5)
		print(window.recipe_one.type.name.." / "..window.recipe_two.type.name, 20, 28, 5)
		
		print("flavor: ", 20, 44, 5)
		spr(34 - (window.eval_one.correct_flavor and 1 or 0),80,44)
		spr(34 - (window.eval_two.correct_flavor and 1 or 0),92,44)
		print("ingredients: ", 20, 52, 5)
		spr(34 - (window.eval_one.correct_ingredients and 1 or 0),80,52)
		spr(34 - (window.eval_two.correct_ingredients and 1 or 0),92,52)
		print("ratio: ", 20, 60, 5)
		spr(34 - (window.eval_one.correct_ratio and 1 or 0),80,60)
		spr(34 - (window.eval_two.correct_ratio and 1 or 0),92,60)
		print("temperature: ", 20, 68, 5)
		spr(34 - (window.eval_one.not_too_cold and 1 or 0),80,68)
		spr(34 - (window.eval_two.not_too_cold and 1 or 0),92,68)
		print("fill: ", 20, 76, 5)
		spr(34 - (window.eval_one.not_too_empty and 1 or 0),80,76)
		spr(34 - (window.eval_two.not_too_empty and 1 or 0),92,76)
		
		print("tip: $"..round((window.eval_one.correct_count + window.eval_two.correct_count)*0.1, 2), 20, 88, 5)
		
		if (window.eval_one.correct_count + window.eval_two.correct_count < 6) then
			print("too many mistakes!", 20, 96, 5)
		else
			print("nice job!", 20, 96, 5)
		end
		
		print("❎ to continue", 20, 104, 5)
	end
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