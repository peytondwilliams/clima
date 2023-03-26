extends CharacterBody2D

signal die

const HUMAN_BULLET = preload("res://mobs/human_bullet.tscn")
const SPEED = 3000

var health = 100
var dying = false

func _physics_process(delta):

	if not dying and $ShootTimer.is_stopped() and $TargetArea.has_overlapping_bodies():
		var closest_target = null
		var closest_dist = 10000

		var bodies = $TargetArea.get_overlapping_bodies()

		for robot in bodies:

			if (robot.is_in_group("robot") or robot.is_in_group("scrapper")) and (closest_target == null or position.distance_to(robot.position) < closest_dist):
				closest_target = robot
				closest_dist = position.distance_to(robot.position)

		if closest_target != null:

			$AnimatedSprite2D.play("shooting")
			$ShootTimer.start()

			var new_bullet = HUMAN_BULLET.instantiate()
			get_parent().add_child(new_bullet)

			new_bullet.position = position
			new_bullet.rotation = position.angle_to_point(closest_target.position) + PI/2
			rotation = new_bullet.rotation - PI/2

	if not $NavigationAgent2D.is_navigation_finished():

		var init_velocity = SPEED * delta * Vector2.from_angle(position.angle_to_point($NavigationAgent2D.get_next_path_position()))
		rotation = init_velocity.angle()
		$NavigationAgent2D.set_velocity(init_velocity)
		velocity = init_velocity
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func receive_damage(damage):
	health -= damage
	if not dying and health <= 0:
		die.emit()
		dying = true
		$AudioDeath.play()
		$AnimationPlayer.play("death")


func attack_scrapper(location):
	$NavigationAgent2D.set_target_position(location)


func _on_audio_death_finished():
	self.queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
