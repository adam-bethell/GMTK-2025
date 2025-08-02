extends Node3D

enum Phase {NULL, PRE, LOOP, POST, WON}
enum Round {NULL, MOVE, SHOOT}
enum Action {MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, SHOOT_UP, SHOOT_DOWN, SHOOT_LEFT, SHOOT_RIGHT}
var action2vector = {
	Action.MOVE_UP: Vector2i(0,1),
	Action.MOVE_DOWN: Vector2i(0,-1),
	Action.MOVE_LEFT: Vector2i(-1,0),
	Action.MOVE_RIGHT: Vector2i(1,0),
	Action.SHOOT_UP: Vector2i(0,1),
	Action.SHOOT_DOWN: Vector2i(0,-1),
	Action.SHOOT_LEFT: Vector2i(-1,0),
	Action.SHOOT_RIGHT: Vector2i(1,0)
}
var p1timeline = []
var p1tlDone = []
var p2timeline = []
var p2tlDone = []
var p1index: int = 0
var p2index: int = 0
const p1posStart = Vector2i(1, 1)
var p1pos: Vector2i = Vector2i(1, 1)
const p2posStart = Vector2i(8, 8)
var p2pos: Vector2i = Vector2i(8, 8)
var p1actions: int = 0
var p2actions: int = 0

const loopTime: float = 5.0
const preTime: float = 1.0
const postTime: float = 1.008
const winTime: float = 1.008

var phase: Phase = Phase.NULL
var round: Round = Round.NULL
var roundNumber: int = 1

var walls = [
	Vector2i(8, 1), Vector2i(9, 3), Vector2i(6, 3), 
	Vector2i(0, 6), Vector2i(1, 8), Vector2i(3, 6),
	Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(3, 2), Vector2i(3, 1),
	Vector2i(8, 6), Vector2i(7, 6), Vector2i(6, 6), Vector2i(6, 7), Vector2i(6, 8)
	]

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()
	
func init() -> void:
	phase = Phase.NULL
	round = Round.NULL
	p1actions = 0
	p2actions = 0
	roundNumber = 1
	$Clock.setPause(false)
	$Clock.setTime(0 - preTime)
	for n in $Clock/ActionsContainer.get_children():
		$Clock/ActionsContainer.remove_child(n)
		n.queue_free()
		
	p1pos = p1posStart
	p2pos = p2posStart
	$P1.position = Vector3(p1posStart.y, 0.0, p1posStart.x)
	$P2.position = Vector3(p2posStart.y, 0.0, p2posStart.x)
	p1timeline.clear()
	p2timeline.clear()
	phase = Phase.NULL
	round = Round.NULL
	p1tlDone.clear()
	p2tlDone.clear()
	$Music.restart()
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phase == Phase.NULL:
		#print("Update: phase is null")
		
		$Clock.setPause(false)
		$Clock.setTime(0 - preTime)
		p1pos = p1posStart
		p2pos = p2posStart
		$P1.position = Vector3(p1posStart.y, 0.0, p1posStart.x)
		$P2.position = Vector3(p2posStart.y, 0.0, p2posStart.x)
		p1index = 0
		p2index = 0
		p1actions = 0
		p2actions = 0
		phase = Phase.PRE
	
	if phase == Phase.PRE:
		if round == Round.NULL:
			#print("Update: phase is PRE and round is MOVE")
			if rng.randf() < 0.5:
				round = Round.MOVE
				p1actions = 5
				p2actions = 5
				$Clock/RoundLabel.setText("Round %d\n5 x MOVE" % roundNumber)
			else:
				round = Round.SHOOT
				p1actions = 1
				p2actions = 1
				$Clock/RoundLabel.setText("Round %d\n1 x SHOOT" % roundNumber)
			
			$Clock/RoundLabel.visible = true
			
		if $Clock.time >= 0:
			#print("Update: setting phase to LOOP")
			phase = Phase.LOOP
			$Clock/RoundLabel.visible = false
			
	if phase == Phase.LOOP:
		#print("LOOP")
		if $Clock.time > loopTime:
			phase = Phase.POST
			p1actions = 0
			p2actions = 0
		
		runActionsFromTimeline()
		
		if round == Round.SHOOT:
			var action_pressed = null
			if Input.is_action_just_pressed("p1up"):
				action_pressed = Action.SHOOT_UP
			elif Input.is_action_just_pressed("p1down"):
				action_pressed = Action.SHOOT_DOWN
			elif Input.is_action_just_pressed("p1left"):
				action_pressed = Action.SHOOT_LEFT
			elif Input.is_action_just_pressed("p1right"):
				action_pressed = Action.SHOOT_RIGHT
				
			if not action_pressed == null and p1actions > 0:
				p1timeline.push_back([$Clock.time, Round.SHOOT, action_pressed])
				p1tlDone.push_back(p1timeline.size() - 1)
				$Clock.placeAction(1)
				p1actions -= 1
				shoot(p1pos, action_pressed)
				$Audio1Laser.play()
			
			action_pressed = null
			if Input.is_action_just_pressed("p2up"):
				action_pressed = Action.SHOOT_UP
			elif Input.is_action_just_pressed("p2down"):
				action_pressed = Action.SHOOT_DOWN
			elif Input.is_action_just_pressed("p2left"):
				action_pressed = Action.SHOOT_LEFT
			elif Input.is_action_just_pressed("p2right"):
				action_pressed = Action.SHOOT_RIGHT
				
			if not action_pressed == null and p2actions > 0:
				p2timeline.push_back([$Clock.time, Round.SHOOT, action_pressed])
				p2tlDone.push_back(p2timeline.size() - 1)
				$Clock.placeAction(2)
				p2actions -= 1
				shoot(p2pos, action_pressed)
				$Audio2Laser.play()
			
		elif round == Round.MOVE:
			var action_pressed = null
			if Input.is_action_just_pressed("p1up"):
				action_pressed = Action.MOVE_UP
			elif Input.is_action_just_pressed("p1down"):
				action_pressed = Action.MOVE_DOWN
			elif Input.is_action_just_pressed("p1left"):
				action_pressed = Action.MOVE_LEFT
			elif Input.is_action_just_pressed("p1right"):
				action_pressed = Action.MOVE_RIGHT
		
			if not action_pressed == null and p1actions > 0:
				#print("p1 move")
				p1pos = move(p1pos, action_pressed)
				$Audio1Step.play()
				p1timeline.push_back([$Clock.time, Round.MOVE, action_pressed])
				p1tlDone.push_back(p1timeline.size() - 1)
				$Clock.placeAction(1)
				$P1.position = coord2pos(p1pos)
				p1actions -= 1
			
			action_pressed = null
			if Input.is_action_just_pressed("p2up"):
				action_pressed = Action.MOVE_UP
			elif Input.is_action_just_pressed("p2down"):
				action_pressed = Action.MOVE_DOWN
			elif Input.is_action_just_pressed("p2left"):
				action_pressed = Action.MOVE_LEFT
			elif Input.is_action_just_pressed("p2right"):
				action_pressed = Action.MOVE_RIGHT
				
			if not action_pressed == null and p2actions > 0:
				p2pos = move(p2pos, action_pressed)
				$Audio2Step.play()
				p2timeline.push_back([$Clock.time, Round.MOVE, action_pressed])
				p2tlDone.push_back(p2timeline.size() - 1)
				$Clock.placeAction(2)
				$P2.position = coord2pos(p2pos)
				p2actions -= 1
				
		elif round == Round.SHOOT:
			pass
			
	if phase == Phase.POST:
		if $Clock.time > loopTime + postTime:
			phase = Phase.NULL
			round = Round.NULL
			p1tlDone.clear()
			p2tlDone.clear()
			roundNumber += 1
			
	if phase == Phase.WON:
		if $Clock.time > loopTime + winTime:
			init()
			phase = Phase.NULL
			round = Round.NULL
			p1tlDone.clear()
			p2tlDone.clear()
		
func runActionsFromTimeline() -> void:
	for i in p1timeline.size():
		if not i in p1tlDone:
			var action = p1timeline[i]
			if action[0] <= $Clock.time:
				if action[1] == Round.MOVE:
					p1pos = move(p1pos, action[2])
					$Audio1Step.play()
					$P1.position = coord2pos(p1pos)
					p1tlDone.push_back(i)
				elif action[1] == Round.SHOOT:
					shoot(p1pos, action[2])
					$Audio1Laser.play()
					p1tlDone.push_back(i)
					
	
	for i in p2timeline.size():
		if not i in p2tlDone:
			var action = p2timeline[i]
			if action[0] <= $Clock.time:
				if action[1] == Round.MOVE:
					p2pos = move(p2pos, action[2])
					$Audio2Step.play()
					$P2.position = coord2pos(p2pos)
					p2tlDone.push_back(i)
				elif action[1] == Round.SHOOT:
					shoot(p2pos, action[2])
					$Audio2Laser.play()
					p2tlDone.push_back(i)

func move(p, a) -> Vector2i:
	var newPosition = p + action2vector[a]
	if isSpaceFree(newPosition):
		return newPosition
	return p
	
func shoot(pos: Vector2i, action: Action) -> void:
	print("shooting")
	var dir: Vector2i = action2vector[action]
	var searching: bool = true
	var toAnimate = []
	while searching:
		pos += dir
		if pos in [p1pos, p2pos]:
			if pos == p1pos:
				$P1/explosion.emitting = true
				roundWon(1)
			else:
				$P2/explosion.emitting = true
				roundWon(2)
		elif not isSpaceFree(pos):
			searching = false
		else:
			toAnimate.push_back(pos)
			
	$Lazer.showLazer(toAnimate, dir)
	
	
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
	
func roundWon(p: int) -> void:
	$Scoreboard.addPoint(p)
	phase = Phase.WON
	p1actions = 0
	p2actions = 0
	if p == 1:
		$Audio1Win.play()
	else:
		$Audio2Win.play()
