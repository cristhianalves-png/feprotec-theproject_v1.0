class_name HardwarePlayer
extends CharacterBody2D

# variaveis de movimento
const SPEED = 200.0
const JUMP_VELOCITY = -200.0
const VELOCITY_CUTOFF = 20.0

# nó que pode ser interagido no dado momento
var current_interactable
var is_active: bool = true

# setta o current_interactable
func _on_interaction_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	current_interactable = area.get_parent()

func _on_interaction_area_exited(_area: Area2D) -> void:
	current_interactable = null

# controla o movimento
func movement() -> void:
	# pular
	if Input.is_action_just_pressed("hardware_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# andar e parar de andar
	var direction := Input.get_axis("hardware_left", "hardware_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, VELOCITY_CUTOFF)
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCITY_CUTOFF)

# interagir com o current_interactable, executando uma função dependendo do tipo de objeto.
func interact() -> void:
	if Input.is_action_just_pressed("hardware_interact") and current_interactable != null:
		match current_interactable.get_groups():
			"CABLE":
				pick_cable()
			"PLUG":
				plug_cable()
			"PC":
				pass

# pega um cabo
func pick_cable() -> void:
	current_interactable.plug(false)
	current_interactable.set_follower($PickupMarker)

func plug_cable() -> void:
	current_interactable.plug(true)

# roda todas as funções que precisam ser verificadas o tempo todo (inputs)
func _physics_process(delta: float) -> void:
	# Se o Hardware não estiver ativo, ignora os controlos
	if not is_active:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	# setta gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	movement()
	interact()
	move_and_slide()
