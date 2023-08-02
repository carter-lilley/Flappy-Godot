extends Node2D

var timer

@onready var base_speed : float = 2.0
@onready var base_interval : float = 2.4

@onready var label = $"../Panel/Label"

@onready var scaling_factor : float = 1.0

func _ready():
	world_global.refresh_scores()
	timer = Globals.createTimer(base_interval/scaling_factor, true, _on_Timer_timeout, true)

func _process(delta):
	label.text = str(world_global.my_score)
	
func _on_Timer_timeout():
	timer = Globals.createTimer(base_interval/scaling_factor, true, _on_Timer_timeout, true)
	# Instantiate a new Line2D and add it as a child of the Node2D
	var wall = preload("res://prefabs/wall.tscn").instantiate()
	wall.transform.origin = Vector2(world_global.window_width,0)
	add_child(wall)
