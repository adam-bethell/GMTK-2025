extends Node

var p1mark = preload("res://prefabs/p_1_mark.tscn")
var p2mark = preload("res://prefabs/p_2_mark.tscn")

var time: float = 0.0
var paused: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not paused:
		time += delta
		_updateLabel()

func setTime(newTime: float) -> void:
	time = newTime
	_updateLabel()

func reset() -> void:
	time = 0.0
	_updateLabel()

func setPause(p: bool) -> void:
	paused = p
	
func _updateLabel() -> void:
	$Label.setTime(time)
	$Head.position.x = 1152 * (time / 5.0)
	
func placeAction(p: int) -> void:
	var go: ColorRect = null
	if p == 1:
		go = p1mark.instantiate()
	elif p == 2:
		go = p2mark.instantiate()
		
	$ActionsContainer.add_child(go)
	go.position.x = $Head.position.x
	
