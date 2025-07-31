extends Node3D

var tilePrefab = preload("res://models/block.tscn")
var wallPrefab = preload("res://models/barrier.tscn")

var p1pos = null
var p2pos = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x := 10
	var y := 10

	for i in range(x):
		for j in range(y):
			var go: Node3D = tilePrefab.instantiate()
			$Tiles.add_child(go)
			go.position = Vector3(j, 0.0, i)
			
	var wallPositions = [Vector2i(2,2), Vector2i(2,3)]
	for pos in wallPositions:
		var go: Node3D = wallPrefab.instantiate()
		$Tiles.add_child(go)
		go.position = Vector3(pos.y, 0.0, pos.x)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
