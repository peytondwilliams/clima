extends CharacterBody2D

const bullet = preload("res://player/bullet.tscn")

func _physics_process(delta):

	if $TargetArea.has_overlapping_bodies():
		var closest_target = null
		var closest_dist = 10000

		var bodies = $TargetArea.get_overlapping_bodies()

		for human in bodies:
			if closest_target == null or position.distance_to(human.position) < closest_dist:
				closest_target = human
				closest_dist = position.distance_to(human.position)

		var new_bullet = bullet.instantiate()
		get_parent().add_child(new_bullet)

		#spawn bullet, fire towards body


	pass

	#move_and_slide()
