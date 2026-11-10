extends Node2D

@onready var hardware = $Hardware
@onready var software = $Software

func _ready() -> void:
	hardware.is_active = true
	software.is_active = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_character"):
		var hw_active = hardware.is_active
		hardware.is_active = not hw_active
		software.is_active = hw_active
		print("Trocou! Hardware ativo: ", hardware.is_active, " | Software ativo: ", software.is_active)
