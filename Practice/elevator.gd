extends Node3D

var in_elevator = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	in_elevator = true
	while in_elevator:
		$".".global_position.y += 0.05
		await get_tree().create_timer(0.01).timeout


func _on_area_3d_body_exited(body: Node3D) -> void:
	in_elevator = false
