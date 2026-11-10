class_name SoftwarePlayer
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -200.0
const VELOCITY_CUTOFF = 20.0

# Define se o Software está atualmente sob o controlo do jogador
var is_active: bool = false

func _physics_process(delta: float) -> void:
	# Aplica a gravidade para garantir que o personagem cai no chão
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Se o Software não estiver ativo, ignora os inputs de movimento
	if not is_active:
		move_and_slide()
		return

	# Pular (utilizando a tecla configurada para o software_jump)
	if Input.is_action_just_pressed("software_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimentação horizontal pelas setas
	var direction := Input.get_axis("software_left", "software_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, VELOCITY_CUTOFF)
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCITY_CUTOFF)

	move_and_slide()
