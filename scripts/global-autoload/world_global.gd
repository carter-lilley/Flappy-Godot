extends Node

var paused: bool = false
var window_width : float
var window_height : float
var player_name : String

var leaderboard : Dictionary
var score_arr : Array

var my_score: int = 0
var num_scores: int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	window_height = get_viewport().get_visible_rect().size.y
	window_width = get_viewport().get_visible_rect().size.x
	print ("Game Started. Resolution...", window_width, "x", window_height)
	
	SilentWolf.configure({
	"api_key": "yHsQArV8lg8C6ie2PKfZs5awbGvvoZqJ94dY7nbM",
	"game_id": "Flappy_Godot",
	"game_version": "1.0.4",
	"log_level": 0
  })

func reset():
	if !paused:
		if my_score > 0 and my_score >= score_arr[len(score_arr)-1].score:
			print("Beat lowest score: ", score_arr[len(score_arr)-1].score)
			var leaderboard = preload("res://prefabs/game_leaderboard.tscn").instantiate()
			add_child(leaderboard)
			paused = true
			await leaderboard.submitted
			leaderboard.queue_free()
			paused = false
			get_tree().reload_current_scene()
			my_score = 0
		else:
			get_tree().reload_current_scene()
			my_score = 0

func get_high_scores(num_scores : int) -> Dictionary:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(num_scores).sw_get_scores_complete
	return sw_result

func submit_score(player_name:String,score:float) -> Dictionary:
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	return sw_result

func refresh_scores():
	print("Scores Refreshed")
	leaderboard = await get_high_scores(num_scores)
	score_arr = leaderboard.scores

# Load the wordlist file and store its content in an array
func profanity_filter(input: String):
	var file = FileAccess.open("res://settings/naughty_words.txt", FileAccess.READ)
	var raw_text: String = file.get_as_text()
	var wordlist_array: PackedStringArray = raw_text.split("\n")
	for i in len(wordlist_array):
		wordlist_array[i] = wordlist_array[i].to_lower()
	return input.to_lower() in wordlist_array

#func get_score_pos(score_ID : int) -> float:
#	var sw_result: Dictionary = await SilentWolf.Scores.get_score_position(score_ID).sw_position_received
#	var pos = SilentWolf.Scores.position
#	return pos
#
#func get_scores_around(score_ID : int, num_scores : int) -> Array:
#	var sw_result: Dictionary = await SilentWolf.Scores.get_scores_around(score_ID,num_scores).sw_scores_around_received
