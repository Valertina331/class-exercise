extends Control


signal pressed()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var tilenumber: int


func _ready():
	tilenumber = randi_range(0,14)
	animated_sprite_2d.frame = tilenumber
	


func _on_button_pressed():
	print("This tile frame icon is #:" + str(tilenumber))
	emit_signal("pressed")
