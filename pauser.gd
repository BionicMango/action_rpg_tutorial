extends Node

# audio player children nodes
@onready var pause_audio_stream_player: AudioStreamPlayer = $PauseAudioStreamPlayer
@onready var unpause_audio_stream_player: AudioStreamPlayer = $UnpauseAudioStreamPlayer

# pause screen child node
@onready var pause_screen: Control = $PauseScreen

func _ready() -> void:
	pause_screen.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): # esc key
		# toggle
		get_tree().paused = not get_tree().paused # toggle
		# play appropriate sound effect (pause or unpause)
		if get_tree().paused:
			pause_audio_stream_player.play()
			pause_screen.show()
		else:
			unpause_audio_stream_player.play()
			pause_screen.hide()
