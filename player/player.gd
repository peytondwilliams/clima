extends Node2D

const CAMERA_SPEED = 1500

var select_units = []

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

	if Input.is_action_just_pressed("action_leftclick"):
		select_units = []

		$Selector.position = mouse_loc
		$Selector.visible = true
	elif Input.is_action_just_released("action_leftclick"):
		$Selector.visible = false

		var bodies = $Selector.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("robot"):
				select_units.append(body)

	if Input.is_action_pressed("action_leftclick"):
		$Selector.scale = mouse_loc - $Selector.position


