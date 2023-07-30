extends Node2D

var timer

@onready var base_speed : float = 2.0
@onready var base_interval : float = 2.4

@onready var label = $"../Panel/Label"
@onready var score: int = 0

@onready var scaling_factor : float = 1.0


func _ready():
	timer = Globals.createTimer(base_interval/scaling_factor, true, _on_Timer_timeout, true)

func _process(delta):
	label.text = str(score)
	
func _on_Timer_timeout():
	timer = Globals.createTimer(base_interval/scaling_factor, true, _on_Timer_timeout, true)
	# Instantiate a new Line2D and add it as a child of the Node2D
	var scene = preload("res://prefabs/wall.tscn").instantiate()
	add_child(scene)
