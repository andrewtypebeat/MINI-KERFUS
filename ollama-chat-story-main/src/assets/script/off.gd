extends Node

@onready var serial = $Serial

func _ready():
	var button = Button.new()
	button.text = "OFF"
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	print("OFF")
	serial.SendToArduino("LED_OFF")
