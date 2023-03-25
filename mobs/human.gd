extends CharacterBody2D

signal die

var health = 100

func _physics_process(delta):
	pass
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	##	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()

func receive_damage(damage):
	health -= damage
	if health <= 0:
		die.emit()
		self.queue_free()
