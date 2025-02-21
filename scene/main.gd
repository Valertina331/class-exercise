extends Control

const GRID_SIZE = 8
const TILE_SCENE = preload("res://scene/Tile.tscn")

var grid = []

func _ready():
	generate_grid()

func generate_grid():
	for row in range(GRID_SIZE):
		grid.append([])
		for col in range(GRID_SIZE):
			var tile = TILE_SCENE.instantiate()
			tile.set_type(randi() % 5)  # 随机类型
			tile.connect("pressed", Callable(self, "_on_tile_pressed").bind(row, col))
			grid[row].append(tile)
			$GridContainer.add_child(tile)

func _on_tile_pressed(row, col):
	print("Clicked tile at: ", row, col)
