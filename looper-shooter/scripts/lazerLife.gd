extends Node3D

var lifespan = 0.1
var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > lifespan:
		$MeshInstance3D.visible = false
		queue_free()
