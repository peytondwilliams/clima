extends Area2D

const DAMAGE = 35
const SPEED = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position += (Vector2(0, -1)).rotated(rotation) * SPEED * delta
	pass


func _on_despawn_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("human"):
		body.receive_damage(DAMAGE)
		queue_free()
