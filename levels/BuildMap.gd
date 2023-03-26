extends TileMap

signal select_building(b_name)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action_leftclick"):
		var tile_coord = local_to_map(get_local_mouse_position())
		var tile_data = get_cell_tile_data(0, tile_coord)
		if tile_data:
			select_building.emit(tile_data.get_custom_data("Build"))

