extends StaticBody2D

const HUMAN_PRE = preload("res://mobs/human.tscn")

signal human_spawn(human, coords)

var health = 300

var dying = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$AnimatedSmoke.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func receive_damage(damage):
	health -= damage
	if not dying and health <= 0:
		dying = true
		$AudioDeath.play()
		$AnimationPlayer.play("death")



func _on_spawn_timer_timeout():
	var human = HUMAN_PRE.instantiate()

	var rand_offset = Vector2(randf_range(-192, 192), randf_range(-192, 192))
	human.position = position + rand_offset

	human_spawn.emit(human, human.position)



func _on_animation_player_animation_finished(anim_name):
	queue_free()
