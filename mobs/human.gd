extends CharacterBody2D

signal die

const HUMAN_BULLET = preload("res://mobs/human_bullet.tscn")

var health = 100
var dying = false

func _physics_process(delta):

	if not dying and $ShootTimer.is_stopped() and $TargetArea.has_overlapping_bodies():
		var closest_target = null
		var closest_dist = 10000

		var bodies = $TargetArea.get_overlapping_bodies()

		for robot in bodies:

			if robot.is_in_group("robot") and (closest_target == null or position.distance_to(robot.position) < closest_dist):
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

func receive_damage(damage):
	health -= damage
	if not dying and health <= 0:
		die.emit()
		dying = true
		$AudioDeath.play()
		$AnimationPlayer.play("death")


func _on_audio_death_finished():
	self.queue_free()
