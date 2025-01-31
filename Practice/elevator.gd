extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	for num in range(50):
		$".".global_position.y += 7
		await get_tree().create_timer(0.25).timeout
