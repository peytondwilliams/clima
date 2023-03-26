extends Node

const LEVEL1 = preload("res://levels/level_1.tscn")

var level = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_endgame(win_state):
	$GameOverMenu.visible = true
	$MusicPlayer.play()

	level.queue_free()
	#$StartMenu.visible = true

	$GameOverMenu.visible = true

	if win_state: #win
		$GameOverMenu/Label.text = "You win!"

	else: #lose
		$GameOverMenu/Label.text = "You lose"


func _on_start_button_pressed():
	level = LEVEL1.instantiate()
	add_child(level)

	level.endgame.connect(_on_endgame)

	$StartMenu.visible = false
	$MusicPlayer.stop()



func _on_back_button_pressed():
	$InstructMenu.visible = false
	$StartMenu.visible = true


func _on_instruct_button_pressed():
	$InstructMenu.visible = true
	$StartMenu.visible = false


func _on_game_over_back_button_pressed():
	$GameOverMenu.visible = false
	$StartMenu.visible = true
