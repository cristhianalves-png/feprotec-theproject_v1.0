extends RigidBody2D

# informações do nó
@export var cable_type: int = 1

# marcador pro nó seguir
var marker_node: Node2D = null

# um nó que está dentro da area
var node = null


# setta um marcador
func set_follower(follower: Node2D) -> void:
	marker_node = follower

# segue o marcador
func follow() -> void:
	if marker_node != null:
		global_position = marker_node.global_position

# conecta/desconecta de um plug, travando ele no ar ou destravando e ativando a colisão
func plug(plug_in: bool) -> void:
	if plug_in == true:
		# Só valida o node se estivermos a tentar CONECTAR
		if node == null:
			return
		global_position = node.get_child(2).global_position
		# Limpa o marcador para o cabo soltar-se da mão do player ao encaixar
		marker_node = null

	freeze = plug_in
	$CollisionShape.disabled = !plug_in

# o mesmo do player
func _physics_process(_delta: float) -> void:
	if marker_node != null:
		follow()


func _on_pickup_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()

	if !parent.has_method("get_object_type"):
		return

	if parent.get_object_type() == "PLUG":
		node = parent

func _on_pickup_area_exited(_area: Area2D) -> void:
	node = null
