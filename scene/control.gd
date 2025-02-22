extends Control

const GRID_SIZE = 8
const TILE_SIZE = 40
const TILE_SCENE = preload("res://scene/Tile.tscn")

var grid = []
var selected_tile = null #first tile selected

func _ready():
	generate_grid()
	
func generate_grid():
	for row in range(GRID_SIZE):
		grid.append([])
		for col in range(GRID_SIZE):
			var tile = tileplacement(row, col)
			grid[row].append(tile)
			%GridContainer.add_child(tile)
			tile.set_position(Vector2(row * TILE_SIZE, col * TILE_SIZE))
			

func tileplacement(x,y):
	var tile = TILE_SCENE.instantiate()
	tile.connect("pressed", Callable(self, "_on_tile_selected").bind(x, y))
	
	print("x is ", x,", y is ", y)
	return tile

func _on_tile_pressed(row, col):
	print("Clicked tile at: ", row, col)
	
func _on_tile_selected(x, y):
	print(selected_tile, " is selected")
	if selected_tile == null:
		#record the first selected tile
		selected_tile = Vector2(x, y)
	else:
		if is_adjacent(selected_tile, Vector2(x, y)):
			print("Tiles are adjacent.")
			swap_tiles(selected_tile.x, selected_tile.y, x, y)
			if not check_match():
				#cancel swap
				swap_tiles(x, y, selected_tile.x, selected_tile.y)
				print("Not matched.")
		print("Tiles are not adjacent.")
		selected_tile = null

func is_adjacent(pos1, pos2):
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y) == 1
	
func swap_tiles(row1, col1, row2, col2):
	print("swaping...")
	var temp = grid[row1][col1]
	grid[row1][col1] = grid[row2][col2]
	grid[row2][col2] = temp
	#var pos1 = grid[row1][col1].position
	#var pos2 = grid[row2][col2].position
	#grid[row1][col1].position = pos2
	#grid[row2][col2].position = pos1
	grid[row1][col1].set_position(Vector2(row1 * TILE_SIZE, col1 * TILE_SIZE))
	grid[row2][col2].set_position(Vector2(row2 * TILE_SIZE, col2 * TILE_SIZE))

func check_match():
	var matched_tiles = []
	
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE - 2):
			if grid[row][col] != null and grid[row][col + 1] != null and grid[row][col + 2] != null:
				if grid[row][col].tilenumber == grid[row][col + 1].tilenumber and grid[row][col].tilenumber == grid[row][col + 2].tilenumber:
					matched_tiles.append([row, col])
					matched_tiles.append([row, col + 1])
					matched_tiles.append([row, col + 2])
				
				#remove_tiles([[row, col], [row, col + 1], [row, col + 2]])
				#return true
				
	for col in range(GRID_SIZE):
		for row in range(GRID_SIZE - 2):
			if grid[row][col] != null and grid[row + 1][col] != null and grid[row + 2][col] != null:
				if grid[row][col].tilenumber == grid[row + 1][col].tilenumber and grid[row][col].tilenumber == grid[row + 2][col].tilenumber:
					matched_tiles.append([row, col])
					matched_tiles.append([row + 1, col])
					matched_tiles.append([row + 2, col])
				
				#remove_tiles([[row, col], [row + 1, col], [row + 2, col]])
				#return true
				
	#if there is a match
	if matched_tiles.size() > 0:
		remove_tiles(matched_tiles)
		return true 
	return false

func remove_tiles(tiles):
	print("Matched!")
	for tile in tiles:
		var x = tile[0]
		var y = tile[1]
		if grid[x][y] != null:
			grid[x][y].queue_free()
			#grid[x][y] = tileplacement(x, y)
			grid[x][y] = null
			await get_tree().process_frame
	
	apply_gravity()
	refill_grid()
	
func apply_gravity():
	#make the rest of the tile fall to the bottom
	for x in range(GRID_SIZE): 
		var new_column = []
		for y in range(GRID_SIZE):  
			if grid[x][y] != null: 
				#store null tiles
				new_column.append(grid[x][y])

		#put the null tiles to the top and other to the bottom
		while new_column.size() < GRID_SIZE:
			new_column.insert(0, null) 

		for y in range(GRID_SIZE):
			grid[x][y] = new_column[y]
			if grid[x][y] != null:
				grid[x][y].set_position(Vector2(x * TILE_SIZE, y * TILE_SIZE))

func refill_grid():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			if grid[row][col] == null:
				var tile = tileplacement(row, col)
				grid[row][col] = tile
				%GridContainer.add_child(tile)
				
				tile.position = Vector2(row * TILE_SIZE, -TILE_SIZE)
				tile.move_tween(row * TILE_SIZE, col * TILE_SIZE)
