extends Node2D

#signal population_update

var pollution = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pollution_calc_timer_timeout():
	# calc pollution increase
	var num_humans = $Humans.get_child_count()

	pollution += num_humans * 0.1

	$UI/PollutionLabel.text = "Pollution: " + str(pollution)

	#emit_signal("population_update", polution)
