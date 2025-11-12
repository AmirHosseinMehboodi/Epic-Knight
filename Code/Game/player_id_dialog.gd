class_name PlayerIdDialog
extends Control

@export var fade_in_duration: float = 0.25
@export var fade_out_duration: float = 0.20
@onready var theme1: AudioStreamPlayer2D = $"../../theme"
@onready var center_cont  : CenterContainer = $ColorRect/CenterContainer
@onready var line_edit    : LineEdit        = center_cont.get_node(^"Panel/VBoxContainer/LineEdit")
@onready var start_button : Button          = center_cont.get_node(^"Panel/VBoxContainer/StartButton")
@onready var error_label  : Label           = center_cont.get_node(^"Panel/VBoxContainer/ErrorLabel")
@onready var check_box: CheckBox = center_cont.get_node(^"Panel/VBoxContainer/CheckBox")
@onready var canvas_layer: CanvasLayer = $"../../CanvasLayer"

signal submitted(id: String)

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	line_edit.text_submitted.connect(_on_text_entered)
	line_edit.text_changed.connect(_clear_error)   # hide error while typing
	start_button.pressed.connect(_submit)

func open(prefill: String = "") -> void:
	show()
	get_tree().paused = true
	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	line_edit.text = prefill
	error_label.visible = false                   # reset state
	await get_tree().process_frame
	line_edit.grab_focus()
	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 1.0, fade_in_duration)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 1.0, fade_in_duration)

func close() -> void:
	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 0.0, fade_out_duration)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 0.5, fade_out_duration)
	t.tween_callback(hide)
	get_tree().paused = false

func _on_text_entered(text: String) -> void:
	line_edit.text = text
	_submit()

func _submit() -> void:
	var id := line_edit.text.strip_edges()
	if id.is_empty():
		_show_error("Please enter an ID")
		return

	submitted.emit(id)
	get_tree().paused = false
	hide()
	theme1.play()
	if check_box.button_pressed == true:
		canvas_layer.visible = true
	else:
		canvas_layer.visible = false
		

func _show_error(msg: String) -> void:
	error_label.text = msg
	error_label.visible = true
	# optional: a tiny shake on the LineEdit
	var t := create_tween()
	var orig := line_edit.position
	t.tween_property(line_edit, "position:x", orig.x + 6.0, 0.06).set_trans(Tween.TRANS_SINE)
	t.tween_property(line_edit, "position:x", orig.x - 6.0, 0.10)
	t.tween_property(line_edit, "position:x", orig.x, 0.06)
	line_edit.grab_focus()

func _clear_error(_t: String) -> void:
	if error_label.visible:
		error_label.visible = false
