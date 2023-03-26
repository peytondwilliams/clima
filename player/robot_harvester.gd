extends CharacterBody2D

const bullet = preload("res://player/bullet.tscn")

const SPEED = 4000
const ROT_SPEED = PI

var health = 100

var target_point = Vector2.ONE

var dying = false

func move_command(location):
	$NavigationAgent2D.set_target_position(location)

func _physics_process(delta):

	if not dying and $ShootTimer.is_stopped() and $TargetArea.has_overlapping_bodies():
		var closest_target = null
		var closest_dist = 10000

		var bodies = $TargetArea.get_overlapping_bodies()

		for human in bodies:

			if human.is_in_group("human") and (closest_target == null or position.distance_to(human.position) < closest_dist):
				closest_target = human
				closest_dist = position.distance_to(human.position)

		if closest_target != null:
			$ShootTimer.start()

			var new_bullet = bullet.instantiate()
			get_parent().add_child(new_bullet)

			new_bullet.position = position
			new_bullet.rotation = position.angle_to_point(closest_target.position) + PI/2

	if not $NavigationAgent2D.is_navigation_finished():

		var init_velocity = SPEED * delta * Vector2.from_angle(position.angle_to_point($NavigationAgent2D.get_next_path_position()))
		rotation = init_velocity.angle() + PI/2
		$NavigationAgent2D.set_velocity(init_velocity)
		velocity = init_velocity
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func receive_damage(damage):
	health -= damage
	if not dying and health <= 0:
		dying = true
		$DeathPlayer.play()
		$AnimationPlayer.play("death")


func selected():
	$AnimatedSprite2D.material.set_shader_parameter("width", 1)
	pass

func deselected():
	$AnimatedSprite2D.material.set_shader_parameter("width", 0)
	pass

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	print(safe_velocity)
	velocity = safe_velocity


func _on_navigation_agent_2d_navigation_finished():
	velocity = Vector2.ZERO


func _on_animation_player_animation_finished(anim_name):
	queue_free()
