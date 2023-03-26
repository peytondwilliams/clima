extends Node2D

signal build_unit(unit_name)

const CAMERA_SPEED = 1500

const MOVE_OFFSET = [Vector2(0, 0), Vector2(-64, 0), Vector2(-64, -64), Vector2(0, -64), Vector2(64, -64), Vector2(64, 0), Vector2(64, -64), Vector2(0, -64), Vector2(-64, -64)]

var select_units = []

var build_select = ""



var button_pressing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var view_size: Vector2 = get_viewport_rect().size / $Camera2D.zoom.x
	var mouse_loc: Vector2 = get_local_mouse_position()
	var border_width = view_size.x * 0.07
	var view_bound_x: float = (view_size.x / 2) - border_width
	var view_bound_y: float = (view_size.y / 2) - border_width

	if (abs(mouse_loc.x) > view_bound_x or
			abs(mouse_loc.y) > view_bound_y):

		var move_dir: Vector2 = mouse_loc.normalized()
		var move_strength: float = 1

		if (abs(mouse_loc.x) > view_bound_x):
			move_strength = max(move_strength, min(abs(mouse_loc.x) - view_bound_x, border_width) / border_width * CAMERA_SPEED)
		if (abs(mouse_loc.y) > view_bound_y):
			move_strength = max(move_strength, min(abs(mouse_loc.y) - view_bound_y, border_width) / border_width * CAMERA_SPEED)

		position += move_dir * move_strength * delta
		var pos_x = clamp(position.x, -1000, 1000)
		var pos_y = clamp(position.y, -1000, 1000)

		position = Vector2(pos_x, pos_y)

	if Input.is_action_just_pressed("action_leftclick"):
		for body in select_units:
			if is_instance_valid(body):
				body.deselected()

		select_units = []

		if not button_pressing:
			$BaseUI.visible = false

		$Selector.position = mouse_loc
		$Selector.visible = true
	elif Input.is_action_just_released("action_leftclick"):
		$Selector.visible = false

		var bodies = $Selector.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("robot"):
				select_units.append(body)
				body.selected()


		if bodies.size() == 1 and bodies[0] is TileMap and $Selector.scale.x + $Selector.scale.y < 20:

			if build_select == "Base":
				$BaseUI.visible = true

	if Input.is_action_pressed("action_leftclick"):
		$Selector.scale = mouse_loc - $Selector.position

	if Input.is_action_just_pressed("action_rightclick"):

		var move_offset_i = 0
		for unit in select_units:
			if is_instance_valid(unit):
				unit.move_command(get_global_mouse_position() + MOVE_OFFSET[move_offset_i % 9])
				move_offset_i += 1


func _handle_build_select(b_name):
	build_select = b_name



func _on_tank_button_button_down():
	button_pressing = true


func _on_tank_button_button_up():
	button_pressing = false
	build_unit.emit("tank")


func _on_scrapper_button_button_down():
	button_pressing = true


func _on_scrapper_button_button_up():
	button_pressing = false
	build_unit.emit("scrapper")
