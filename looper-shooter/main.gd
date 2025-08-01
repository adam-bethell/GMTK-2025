extends Node3D

enum Phase {NULL, PRE, LOOP, POST}
enum Round {NULL, MOVE, SHOOT}
enum Action {MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, SHOOT_UP, SHOOT_DOWN, SHOOT_LEFT, SHOOT_RIGHT}
var action2vector = {
	Action.MOVE_UP: Vector2i(0,1),
	Action.MOVE_DOWN: Vector2i(0,-1),
	Action.MOVE_LEFT: Vector2i(-1,0),
	Action.MOVE_RIGHT: Vector2i(1,0)
}
var p1timeline = {}
var p2timeline = {}
var p1pos: Vector2i = Vector2i(1, 1)
var p2pos: Vector2i = Vector2i(8, 8)
var p1actions: int = 0
var p2actions: int = 0

const loopTime: float = 5.0
const preTime: float = 1.0
const postTime: float = 1.0

var phase: Phase = Phase.NULL
var round: Round = Round.NULL
var roundNumber: int = 1

var walls = [
	Vector2i(8, 1), Vector2i(9, 3), Vector2i(6, 3), 
	Vector2i(0, 6), Vector2i(1, 8), Vector2i(3, 6),
	Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(3, 2), Vector2i(3, 1),
	Vector2i(8, 6), Vector2i(7, 6), Vector2i(6, 6), Vector2i(6, 7), Vector2i(6, 8)
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	
func init() -> void:
	phase = Phase.NULL
	round = Round.NULL
	roundNumber = 1
	$Clock.setPause(false)
	$Clock.reset()
	$P1.position = Vector3(p1pos.y, 0.0, p1pos.x)
	$P2.position = Vector3(p2pos.y, 0.0, p2pos.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if round == Round.MOVE:
		var action_pressed = null
		if Input.is_action_just_pressed("p1up"):
			action_pressed = Action.MOVE_UP
		elif Input.is_action_just_pressed("p1down"):
			action_pressed = Action.MOVE_DOWN
		elif Input.is_action_just_pressed("p1left"):
			action_pressed = Action.MOVE_LEFT
		elif Input.is_action_just_pressed("p1right"):
			action_pressed = Action.MOVE_RIGHT
		
		if not action_pressed == null:
			p1pos = move(p1pos, action_pressed)
			$P1.position = coord2pos(p1pos)
		
		action_pressed = null
		if Input.is_action_just_pressed("p2up"):
			action_pressed = Action.MOVE_UP
		elif Input.is_action_just_pressed("p2down"):
			action_pressed = Action.MOVE_DOWN
		elif Input.is_action_just_pressed("p2left"):
			action_pressed = Action.MOVE_LEFT
		elif Input.is_action_just_pressed("p2right"):
			action_pressed = Action.MOVE_RIGHT
			
		if not action_pressed == null:
			p2pos = move(p2pos, action_pressed)
			$P2.position = coord2pos(p2pos)
	elif round == Round.SHOOT:
		pass
		
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
