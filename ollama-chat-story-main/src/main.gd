extends Node2D

# Aquí guardaremos el historial de la conversación
var conversation_history: Array = []

func _ready():
	%Api_access.connectToHost()

func _on_api_access_connection_success():
	$%SENDBUTTON.disabled = false

func _on_sendbutton_pressed():
	if not %RESPONSE.text.is_empty():
		%RESPONSE.text += "\n\n"
	
	var user_message: String = %MESSAGE.text
	if user_message.is_empty():
		return
		
	# 1. Mostramos lo que escribió el usuario en pantalla
	%RESPONSE.text += "You: " + user_message + "\n"
	
	# 2. Agregamos el mensaje del usuario al historial
	conversation_history.append({
		"role": "user",
		"content": user_message
	})
	
	# 3. Cambiamos el path a /api/chat
	var path: String = "/api/chat"
	var messageDict: Dictionary = {
		"model": "MINIKERFUS",
		"messages": conversation_history # <--- Enviamos todo el historial aquí
	}
	
	# Limpiamos la caja de texto para el próximo mensaje
	%MESSAGE.text = ""
	
	%Api_access.sendPostRequest(messageDict, path)

# Variable temporal para ir acumulando la respuesta actual del asistente
var current_assistant_response: String = ""

func _on_api_access_chunk_received(chunk):
	var chunkDict: Dictionary = JSON.parse_string(chunk)
	
	# En /api/chat, el texto viene dentro de message -> content
	if chunkDict.has("message") and chunkDict["message"].has("content"):
		var text_piece = chunkDict["message"]["content"]
		current_assistant_response += text_piece
		%RESPONSE.text += text_piece
		
	# Si Ollama nos indica que terminó la respuesta (done: true)
	if chunkDict.get("done", false):
		# Agregamos la respuesta completa del asistente al historial
		conversation_history.append({
			"role": "assistant",
			"content": current_assistant_response
		})
		# Reiniciamos la variable para el siguiente turno
		current_assistant_response = ""
