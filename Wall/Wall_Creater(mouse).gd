extends Node2D

var wall_node = load("res://Wall/DrawingWall.tscn")
var walls = []

export (int) var wallWidth = 5
export (int) var wallLimit = 10
export (int) var wallLengthLimit = 150
export (int) var WallCreatingTime = 1.5

var isClicked = false
var isCreated = false
var isPossibleToMakeWall = true

var startPoint = Vector2()
var endPoint = Vector2()

var wall_timer
var wallCreatingTimer
var progressValue = 0

func _ready():
	wall_timer = get_tree().get_root().find_node("IngameGUI")
	wallCreatingTimer = create_timer("wallCreatingTimer",WallCreatingTime)

func create_timer (item_func, item_time) -> Timer:
	var timer = Timer.new()    
	add_child (timer)
	timer.set_wait_time (item_time)
	timer.connect("timeout", self, item_func)
	return timer
	
func wallCreatingTimer():
	isPossibleToMakeWall = true

func _input(event):
	if isPossibleToMakeWall:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if  !isClicked  and event.pressed == true:
				isClicked = true
				startPoint = get_global_mouse_position()
				print("left click press")
			elif isClicked and event.pressed == false:
				wallCreatingTimer.start()
				isPossibleToMakeWall = false
				isClicked = false
				isCreated = false
				endPoint = get_global_mouse_position()
				walls[-1].enable_collision()
				print("left click unpress")

func _process(_delta):
	if isPossibleToMakeWall:
		progressValue = 0
	else:
		if wall_timer != null:
			print("not null")
			wall_timer.fillTimer(progressValue)
			if(wallLimit > walls.size()):
				progressValue += 1/WallCreatingTime * 100 * _delta
		else:
			print("null")
			
	
	
	var tempWall
	if(isClicked and !isCreated and walls.size() < wallLimit):
		print("create wall")
		tempWall = wall_node.instance()
		add_child(tempWall)
		walls.append(tempWall)
		isCreated = true
	
	if(isClicked and isCreated):
		endPoint = get_global_mouse_position()
		if((endPoint-startPoint).length() > wallLengthLimit):
			endPoint = startPoint + (endPoint-startPoint).normalized() * wallLengthLimit
		walls[-1].update_points(startPoint, endPoint, wallWidth)

