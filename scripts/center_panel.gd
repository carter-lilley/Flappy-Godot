extends Panel

# Sloppy way to center the label in the viewport
func _ready():
	self.z_index = 1
	self.position.x = world_global.window_width/2
