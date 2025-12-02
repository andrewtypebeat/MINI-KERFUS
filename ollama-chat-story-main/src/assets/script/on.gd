extends Node

@onready var serial = $Serial

func _ready():
	var button = Button.new()
	button.text = "ON"
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	print("ON")
	serial.SendToArduino("LED_ON")
