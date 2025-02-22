extends Control


signal pressed()
signal tile_swapped(new_x, new_y)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var tilenumber: int
var tile_position = Vector2()


func _ready():
	tilenumber = randi_range(0,14)
	animated_sprite_2d.frame = tilenumber
	


func _on_button_pressed():
	print("This tile frame icon is #:" + str(tilenumber))
	emit_signal("pressed")
	emit_signal("tile_selected", tile_position.x, tile_position.y)

func set_tile_position(x, y):
	tile_position = Vector2(x, y)

#tile dropping animation
func move_tween(target_x, target_y):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(target_x, target_y), 0.3) \
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	self.position = Vector2(target_x, target_y)
