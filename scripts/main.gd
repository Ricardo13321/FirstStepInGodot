extends Node

@export var mob_scene: PackedScene
var Pause = true 
# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()
	$UserInterface/Node/Menu.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Pause == true) and Input.is_action_just_pressed("Pause_Enter"):
		$UserInterface/Node/Menu.show()
		get_tree().paused = true
	pass
		
func _unhandled_input(event):
	if event.is_action_pressed("jump") and $UserInterface/Retry.visible:
		#This restarts the current scene.
		get_tree().reload_current_scene()

func _on_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Esta linha significa que quando o inimigo emitir o sinal squashed, o nó ScoreLabel o receberá e chamará a função _on_mob_squashed().
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	pass # Replace with function body.


func _on_player_hit():
	Pause = false
	$MobTimer.stop()
	$UserInterface/Retry.show()
	pass # Replace with function body.
	


func _on_button_pressed():
	get_tree().paused = false
	$UserInterface/Node/Menu.hide()
	$MobTimer.start()
	pass # Replace with function body.


func _on_button_2_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	pass # Replace with function body.
