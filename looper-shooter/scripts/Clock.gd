extends Node

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
	$Label.text = "%.3f" % time
	$Head.position.x = 1152 * (time / 5.0)
