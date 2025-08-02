extends Node3D
	
var laser = preload("res://prefabs/Lazer.tscn")
	
func showLazer(list, dir) -> void:
	var rotate: float = 0.0
	if dir.x != 0:
		rotate = PI / 2.0
	
	for pos in list:
		var go: Node3D = laser.instantiate()
		add_child(go)
		go.position = Vector3(pos.y, 0.0, pos.x)
		go.rotate_y(rotate)
