extends Panel

var window_width : float

# Called when the node enters the scene tree for the first time.
func _ready():
	window_width = get_viewport().get_visible_rect().size.x
	self.position.x = window_width/2
