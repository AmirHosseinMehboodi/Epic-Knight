class_name Main extends Node2D

@onready var _pause_menu := $InterfaceLayer/PauseMenu as PauseMenu
@onready var _player_id_ui : PlayerIdDialog = $InterfaceLayer/PlayerIdDialog

var player_id: String = ""

func _ready() -> void:
	# Optional: load previous to prefill the box (we still *show* the dialog).
	load_if_any()
	_player_id_ui.submitted.connect(_on_player_id_submitted)

	# Always open on start
	_player_id_ui.open("")

func _unhandled_input(event: InputEvent) -> void:
	# While the ID dialog is visible, ignore pause toggling
	if _player_id_ui.visible:
		return

	if event.is_action_pressed(&"toggle_pause"):
		var tree := get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().root.set_input_as_handled()

func _on_player_id_submitted(id: String) -> void:
	player_id = id
	save_player_id()
	# continue game flow as normal (game is unpaused by the dialog)

func load_if_any() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		player_id = str(cfg.get_value("player", "id", ""))

func save_player_id() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("player", "id", player_id)
	cfg.save("user://settings.cfg")

# Call this on “reset game”
func show_id_screen_again() -> void:
	_player_id_ui.open(player_id)  # or "" to force retyping
