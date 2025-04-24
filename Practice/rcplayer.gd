extends VehicleBody3D

const MAX_STEER = 0.4
const MAX_RPM = 300
const MAX_TORQUE = 200
const HORSEPOWER = 100

var stutter_aud = preload("res://Practice/assets/race/car_sound_effects_pack/Car_Engine_Loop.ogg")
var start_aud = preload("res://Practice/assets/race/car_sound_effects_pack/Car_Acceleration.ogg")
var engine_aud = preload("res://Practice/assets/race/engine-loop/engine-loop-1.wav")
var aud_bool = false # controls startup sounds stopping
var t = true
var l = true

var laps = 1
var checkpoints = [false, false, false, false]

func reset_checkpoints():
	checkpoints = [false, false, false, false]

func do_lap():
	laps += 1
	reset_checkpoints()
	if laps > 3:
		await get_tree().create_timer(0.25).timeout
		OS.alert("You Win!") # TODO: Replace with level change
	else:
		$Label2.text = "Lap %d/3" % laps
	pass
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func calc_engine_force(accel, rpm):
	return accel * MAX_TORQUE * (1 - rpm / MAX_RPM)

func _physics_process(delta: float) -> void:
	steering = lerp(steering, 
				Input.get_axis("ui_right", "ui_left") * MAX_STEER, 
				delta * 5.0)
	var accel = Input.get_axis("ui_down", "ui_up") * HORSEPOWER
	$backLeft.engine_force = calc_engine_force(accel, abs($backLeft.get_rpm()))
	$backRight.engine_force = calc_engine_force(accel, abs($backRight.get_rpm()))

	var fwd_mps = abs((linear_velocity * transform.basis).z)
	$Label.text = "%d mph" % (fwd_mps * 3.6)
	
	$centerMass.global_position = $centerMass.global_position.lerp(
										global_position, delta * 20.0)
	$centerMass.transform = $centerMass.transform.interpolate_with(
										transform, delta * 5.0)
	$centerMass/Camera3D.look_at(global_position.lerp(global_position + linear_velocity,
									 delta * 5.0))
	check_and_right()
	
	#FOV
	var cam = $centerMass/Camera3D
	if (fwd_mps * 3.6) >= 35:
		if cam.fov <= 100:
			cam.fov += 0.5
			print(cam.fov)
	else:
		if cam.fov >= 75:
			cam.fov -= 0.5
	
	#Vroom Sound
	if accel != 0:
		var max_dB = 110
		var dB = clamp(max_dB * abs($backLeft.engine_force/MAX_RPM), -10, max_dB)
		$AudioStreamPlayer3D.volume_db = dB
	
		if t:
			$AudioStreamPlayer3D.stream = start_aud
			$AudioStreamPlayer3D.play()
			t = false
		if not $AudioStreamPlayer3D.is_playing() and l:
			$AudioStreamPlayer3D.stream = stutter_aud
			$AudioStreamPlayer3D.play()
			l = false
		if not $AudioStreamPlayer3D.playing:
			aud_bool = true # engine base sound starts
			if aud_bool:
				$AudioStreamPlayer3D.stream = engine_aud
				$AudioStreamPlayer3D.play() # change the stream to the vroom sound and play
	else :
		$AudioStreamPlayer3D.volume_db = 10  # default
		aud_bool = false
		t = true
		l = true

func check_and_right():
	if global_transform.basis.y.dot(Vector3.UP) < 0:
		var cur_rotation = self.rotation_degrees
		cur_rotation.x = 0 # Reset Pitch
		cur_rotation.z = 0 # Reset Roll
		self.rotation_degrees = cur_rotation
