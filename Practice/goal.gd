extends Area3D

@export var next_level = ""

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if next_level != "":
			var lvl = "res://" + next_level + ".tscn"
			#TODO: loading
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file(lvl)
		else:
			OS.alert("No Next Level!")
