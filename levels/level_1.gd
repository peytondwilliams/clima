extends Node2D

const TANK_SCENE = preload("res://player/robot_harvester.tscn")

#signal population_updatec
const POLLUTION_BAR_MAX_SIZE = 1125
const BASE_LOC = Vector2(224, -32)

var tankBuildQueue = 0


var spawn_loc = BASE_LOC + Vector2(-64, 0)

var pollution = 1
var scrap_count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if $Humans.get_child_count() == 0 and $Pollutors.get_child_count() == 0:
		#win!
		pass

func update_pollution_bar():
	$UI/PollutionBack/PollutionBar.size.x = POLLUTION_BAR_MAX_SIZE * (pollution / 100)
	if pollution >= 100:
		#lose game!
		pass

func update_build_queue():
	$UI/TankClockBack/TankClockLabel.text = "Build Queue: " + str(tankBuildQueue)

func update_scrap_count():
	$UI/ScrapBack/ScrapLabel.text = "Scrap: " + str(scrap_count)

func _on_pollution_calc_timer_timeout():
	# calc pollution increase
	var num_humans = $Humans.get_child_count()
	var num_robots = $Robots.get_child_count()
	var num_pollutors = $Pollutors.get_child_count()
	var num_scrappers = $Scrappers.get_child_count()
	pollution += num_humans * 0.03
	pollution += num_robots * 0.05
	pollution += num_pollutors * 0.2

	scrap_count += num_scrappers

	update_pollution_bar()
	update_scrap_count()
	#emit_signal("population_update", polution)


func _on_player_build_unit(unit_name):
	if unit_name == "tank" and scrap_count >= 2:
		if $TankBuildTimer.is_stopped():
			$TankBuildTimer.start()
		tankBuildQueue += 1
		scrap_count -= 2

		update_build_queue()
		update_scrap_count()



func _on_tank_build_timer_timeout():
		pollution += 2
		update_pollution_bar()

		var tank = TANK_SCENE.instantiate()
		$Robots.add_child(tank)
		tank.position = spawn_loc

		spawn_loc += Vector2(0, 64)

		tankBuildQueue -= 1
		if tankBuildQueue > 0:
			$TankBuildTimer.start()

		update_build_queue()


func _on_pollutor_human_spawn(human, coords):
	$Humans.add_child(human)
	human.position = coords
