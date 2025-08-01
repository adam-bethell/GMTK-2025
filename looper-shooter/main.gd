extends Node3D

enum action {MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, SHOOT_UP, SHOOT_DOWN, SHOOT_LEFT, SHOOT_RIGHT}
var action2vector = {
	action.MOVE_UP: Vector2i(0,1),
	action.MOVE_DOWN: Vector2i(0,-1),
	action.MOVE_LEFT: Vector2i(-1,0),
	action.MOVE_RIGHT: Vector2i(1,0)
}
var p1timeline = {}
var p2timeline = {}
var p1pos = Vector2i(1, 1)
var p2pos = Vector2i(8, 8)

var walls = [
	Vector2i(8, 1), Vector2i(9, 3), Vector2i(6, 3), 
	Vector2i(0, 6), Vector2i(1, 8), Vector2i(3, 6),
	Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(3, 2), Vector2i(3, 1),
	Vector2i(8, 6), Vector2i(7, 6), Vector2i(6, 6), Vector2i(6, 7), Vector2i(6, 8)
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$P1.position = Vector3(p1pos.y, 0.0, p1pos.x)
	$P2.position = Vector3(p2pos.y, 0.0, p2pos.x) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var action_pressed = null
	if Input.is_action_just_pressed("p1up"):
		action_pressed = action.MOVE_UP
	elif Input.is_action_just_pressed("p1down"):
		action_pressed = action.MOVE_DOWN
	elif Input.is_action_just_pressed("p1left"):
		action_pressed = action.MOVE_LEFT
	elif Input.is_action_just_pressed("p1right"):
		action_pressed = action.MOVE_RIGHT
	
	if not action_pressed == null:
		p1pos = move(p1pos, action_pressed)
		$P1.position = coord2pos(p1pos)
	
	action_pressed = null
	if Input.is_action_just_pressed("p2up"):
		action_pressed = action.MOVE_UP
	elif Input.is_action_just_pressed("p2down"):
		action_pressed = action.MOVE_DOWN
	elif Input.is_action_just_pressed("p2left"):
		action_pressed = action.MOVE_LEFT
	elif Input.is_action_just_pressed("p2right"):
		action_pressed = action.MOVE_RIGHT
		
	if not action_pressed == null:
		p2pos = move(p2pos, action_pressed)
		$P2.position = coord2pos(p2pos)
		
func move(p, a) -> Vector2i:
	var newPosition = p + action2vector[a]
	if isSpaceFree(newPosition):
		return newPosition
	return p
	
func isSpaceFree(p: Vector2i) -> bool:
	if p in walls:
		return false
	if p in [p1pos, p2pos]:
		return false
	if p.x < 0 or p.x > 9 or p.y < 0 or p.y > 9:
		return false
	return true
	
	
func coord2pos (v2: Vector2i) -> Vector3:
	return Vector3(v2.y, 0.0, v2.x)
