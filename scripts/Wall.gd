extends wall_class

@onready var Goal = $Goal
@onready var wall_handler = $".."

@onready var smoothing = $Smoothing2D

var movement_vec: Vector2 = Vector2.ZERO
var mesh_origin: Node2D

func _physics_process(delta):
	#every frame, update the speed based on the scaling factor (number of goals passed through)
	#and move this object to the left at its adjusted speed
	var curr_speed = (wall_handler.base_speed*wall_handler.scaling_factor)
	movement_vec = Vector2(curr_speed,0)
	position -= movement_vec

func _ready():
	smoothing.teleport()
	Goal.connect("body_entered",_on_goal_area_entered)
#	self.set_position(Vector2(world_global.window_width,0))
	#then, choose a random point vertically in the windows height range
	var gap_point = randf_range(gap_size,world_global.window_height-gap_size)
	#create the top and bottom lines with a break of "gap_size" pixels
	#...which begins from the randomly assigned "gap_point"
	var top = Line2D.new()
	var bot = Line2D.new()

	# Define the points of the line
	var top_points = [
		Vector2(0, 0),
		Vector2(0, gap_point)
	]
	var bot_points = [
		Vector2(0, gap_point+gap_size), 
		Vector2(0, world_global.window_height)
	]
	#set the point arrays, width, and color of the lines
	top.points = top_points
	bot.points = bot_points
	top.width = wall_width
	bot.width = wall_width
	top.default_color = Color.LIGHT_STEEL_BLUE
	bot.default_color = Color.LIGHT_STEEL_BLUE
	#add the points under a "mesh_origin" object, so i can move them as one during interpolation
	mesh_origin = Node2D.new()
	mesh_origin.add_child(top)
	mesh_origin.add_child(bot)
	smoothing.add_child(mesh_origin)
	#do the same thing again to draw and add its collision objects
	add_collision(top_points,bot_points)

func add_collision(_top_points : Array, _bot_points : Array):
	
	var top_col = CollisionPolygon2D.new()
	var bot_col = CollisionPolygon2D.new()
	var gap_col = CollisionPolygon2D.new()
	
	# Define points for the collision polygon to form an area around the lines
	var top_col_pnts = [
		Vector2(_top_points[0].x -wall_width/2, _top_points[0].y),
		Vector2(_top_points[0].x +wall_width/2, _top_points[0].y),
		Vector2(_top_points[1].x +wall_width/2, _top_points[1].y),
		Vector2(_top_points[1].x -wall_width/2, _top_points[1].y)
	]
	var bot_col_pnts = [
		Vector2(_bot_points[0].x -wall_width/2, _bot_points[0].y),
		Vector2(_bot_points[0].x +wall_width/2, _bot_points[0].y),
		Vector2(_bot_points[1].x +wall_width/2, _bot_points[1].y),
		Vector2(_bot_points[1].x -wall_width/2, _bot_points[1].y)
	]
	var gap_col_pnts = [
		Vector2(_top_points[1].x +wall_width/2, _top_points[1].y),
		Vector2(_top_points[1].x -wall_width/2, _top_points[1].y),
		Vector2(_bot_points[0].x -wall_width/2, _bot_points[0].y),
		Vector2(_bot_points[0].x +wall_width/2, _bot_points[0].y)
	]
	
	# Set points for the collision polygon
	top_col.polygon = top_col_pnts
	bot_col.polygon = bot_col_pnts
	gap_col.polygon = gap_col_pnts
	
	var top_col_obj = StaticBody2D.new()
	var bot_col_obj = StaticBody2D.new()
	# Add CollisionPolygon2D node as a child of the Node2D
	add_child(top_col_obj)
	add_child(bot_col_obj)
	Goal.add_child(gap_col)
	top_col_obj.add_child(top_col)
	bot_col_obj.add_child(bot_col)

func _on_goal_area_entered(body:Node2D):
	world_global.my_score += 1
	wall_handler.scaling_factor += .08
	var new_time = wall_handler.base_interval / wall_handler.scaling_factor
	wall_handler.timer.wait_time = new_time
