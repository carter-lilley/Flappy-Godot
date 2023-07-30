extends player_class

@onready var sprite : Sprite2D = $Sprite2D
@onready var screen_buffer: float = 20.0
# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var window_height : float

func _ready():
	#set window height
	window_height = get_viewport().get_visible_rect().size.y
	
func _process(delta):
	#...always lerp downwards 90 deg
	sprite.rotation = lerp_angle(sprite.rotation,deg_to_rad(90), TURN_SPEED * delta)
	#reload scene if outside the window + a small buffer
	if position.y > window_height + screen_buffer:
		get_tree().reload_current_scene()
	elif position.y < 0 - screen_buffer:
		get_tree().reload_current_scene()
	
func _unhandled_input(event):
	#this function is called when there is any input of any kind
	if event.is_pressed():
		Globals.stween_to(sprite, "rotation", deg_to_rad(0), .4, Tween.TRANS_BACK, Tween.EASE_OUT, false, false)
		velocity.y = JUMP_VELOCITY
		#add upward jump velocity and spin back upright
		
func _physics_process(delta):
	#...add gravity multiplied by the physics step (to keep it consistent)
	velocity.y += gravity * delta
	# move_and_slide moves in your inherant internal velocity for CharBody2Ds
	# move, and store any collisions in "col". If there is a collision, 
	# restart the scene
	var col = move_and_slide()
	if col:
		get_tree().reload_current_scene()

