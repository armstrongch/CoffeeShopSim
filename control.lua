control = {}

function setup_control()
	
	control.tips = 0
	control.complaints = 0
	
	control.minute_hand = 0
	control.second_hand = 0
	
	control.player_commute_location_x = 1
	control.player_commute_location_y = 0
	
	control.car_commute_location_x = 1
	control.car_commute_location_y = 0
	
	control.hungry = true
	control.gas = 30
	control.max_gas = 50
	
	control.tile_map = {
	{"r","r","r","r","r","r","r","r","r","r","r","r","r","r","r","r"},
	{"r","h","u","x","r","x","u","x","u","x","r","x","u","x","u","r"},
	{"r","u","u","u","r","u","u","u","u","u","r","u","x","u","f","r"},
	{"r","x","u","x","r","x","u","x","u","x","r","r","r","r","r","r"},
	{"r","r","r","r","r","r","r","r","r","r","r","x","u","x","u","r"},
	{"r","x","u","u","r","x","u","x","u","x","r","u","u","u","u","r"},
	{"r","u","u","x","r","u","u","u","u","u","r","u","x","u","x","r"},
	{"r","x","u","u","r","x","u","x","r","r","r","r","r","r","r","r"},
	{"r","u","u","x","r","u","u","u","r","x","u","x","u","u","x","r"},
	{"r","x","u","u","r","x","u","x","r","u","u","u","x","u","u","r"},
	{"r","r","r","r","r","r","r","r","r","x","u","x","r","r","r","r"},
	{"r","x","u","u","u","x","r","u","u","u","u","u","r","w","u","r"},
	{"r","u","u","x","u","u","r","x","u","x","u","x","r","u","u","r"},
	{"r","r","r","r","u","x","r","r","r","r","r","r","r","x","u","r"},
	{"x","u","g","r","x","u","u","x","u","x","r","x","u","u","u","r"},
	{"u","x","u","r","r","r","r","r","r","r","r","r","r","r","r","r"}
}
end

function update_control()
	
end