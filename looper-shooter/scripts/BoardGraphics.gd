extends Node3D

var tilePrefab = preload("res://models/block.tscn")
var wallPrefab = preload("res://models/barrier.tscn")
var blockPrefab = preload("res://models/pillar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createBoard()
	
func createBoard() -> void:
	for i in range(10):
		for j in range(10):
			var go: Node3D = tilePrefab.instantiate()
			add_child(go)
			go.position = Vector3(j, 0.0, i)
			
	var go: Node3D = wallPrefab.instantiate()
	add_child(go)
	go.position = Vector3(2.0, 0.0, 2.0)
	go.rotation_degrees = Vector3(0.0, 270.0, 0.0) 
	go = wallPrefab.instantiate()
	add_child(go)
	go.position = Vector3(7.0, 0.0, 7.0)
	go.rotation_degrees = Vector3(0.0, 90.0, 0.0)
	
	var positions = [Vector2i(8, 1), Vector2i(9, 3), Vector2i(6, 3), Vector2i(0, 6), Vector2i(1, 8), Vector2i(3, 6)]
	for pos in positions:
		go = blockPrefab.instantiate()
		add_child(go)
		go.position = Vector3(pos.y, 0.0, pos.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
