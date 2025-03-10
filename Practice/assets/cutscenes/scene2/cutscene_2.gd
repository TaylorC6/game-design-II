extends Node3D

@onready var animation_player: AnimationPlayer = $AuxScene/AnimationPlayer
@onready var animation_playerMain: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_playerMain.Stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
