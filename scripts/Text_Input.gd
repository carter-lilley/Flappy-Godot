extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	set_caret_column(len(text))
	caret_blink = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
