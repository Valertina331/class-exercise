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
			var tile = tileplacement(row, col)
			grid[row].append(tile)
			%GridContainer.add_child(tile)
			

func tileplacement(x,y):
	var tile = TILE_SCENE.instantiate()
	tile.connect("pressed", Callable(self, "_on_tile_pressed").bind(x, y))
	
	print(x,y)
	return tile

func _on_tile_pressed(row, col):
	print("Clicked tile at: ", row, col)
	
	
func swap_tiles(row1, col1, row2, col2):
	var temp = grid[row1][col1]
	grid[row1][col1] = grid[row2][col2]
	grid[row2][col2] = temp
	var pos1 = grid[row1][col1].position
	var pos2 = grid[row2][col2].position
	grid[row1][col1].position = pos2
	grid[row2][col2].position = pos1
