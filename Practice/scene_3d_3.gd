extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_ball"):
		$KickBall.global_position = Vector3(-0.56,0.663,5.023)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $KickBall:
		
		$CSGPolygon3D3.queue_free()
