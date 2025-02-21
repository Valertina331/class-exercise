extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var tilenumber: int

func _ready():
	animated_sprite_2d.frame = tilenumber
