extends Node2D
var angle := 0
@onready var serial = $SerialReader

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		angle = clamp(angle + 1, 0, 180)
		serial.SetServoAngle(angle)

	if Input.is_action_pressed("ui_left"):
		angle = clamp(angle - 1, 0, 180)
		serial.SetServoAngle(angle)
