extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",_on_goal_area_entered)

func _on_goal_area_entered(body:Node2D):
	queue_free()
