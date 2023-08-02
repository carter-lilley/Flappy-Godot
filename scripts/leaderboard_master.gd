extends Control

signal submitted

@onready var score_names = $CenterContainer/Panel_Rows/List_Main/List_Container/Score_Name_Panel/Score_Name
@onready var score_nums = $CenterContainer/Panel_Rows/List_Main/List_Container/Score_Num_Panel/Score_Num
@onready var text_input = $CenterContainer/Panel_Rows/Input_Main/HBoxContainer/Text_Input
@onready var button = $CenterContainer/Panel_Rows/Input_Main/HBoxContainer/Button

var textbox_pos

func _ready():
	textbox_pos = text_input.position
	self.z_index = 1
	position = Vector2(0,world_global.window_height)
	Globals.stween_to(self, "position", Vector2.ZERO, .6, Tween.TRANS_BACK, Tween.EASE_OUT, false, false)
	
	if world_global.player_name:
		text_input.text = world_global.player_name
	
	var name_arr: PackedStringArray 
	for i in len(world_global.score_arr):
		var curr_name = world_global.score_arr[i].player_name
		name_arr.append(curr_name)
	var name_string: String = "\n".join(name_arr)
	score_names.text = name_string
	
	var score_arr: PackedStringArray 
	for i in len(world_global.score_arr):
		var curr_score = world_global.score_arr[i].score
		score_arr.append(str(curr_score))
	var score_str: String = "\n".join(score_arr)
	score_nums.text = score_str

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_down():
	submit()
	pass # Replace with function body.

func submit():
	if !world_global.profanity_filter(text_input.text):
		print("Profanity check...PASSED")
		world_global.player_name = text_input.text
		world_global.submit_score(world_global.player_name,world_global.my_score)
		emit_signal("submitted")
	else:
		text_input.position = textbox_pos
		Globals.stween_shake(text_input, 8, .3, Tween.TRANS_CUBIC, Tween.EASE_OUT_IN)
		print("Profanity check...FAILED")
