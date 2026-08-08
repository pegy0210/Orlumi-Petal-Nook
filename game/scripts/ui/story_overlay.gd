extends Panel

signal sequence_finished(sequence_id: String)

@onready var story_label: Label = $Content/StoryLine
@onready var continue_button: Button = $Content/Continue

var _sequence_id: String = ""
var _lines: Array[String] = []
var _index: int = 0


func _ready() -> void:
	visible = false
	continue_button.pressed.connect(_advance)


func start_sequence(sequence_id: String, lines: Array[String]) -> void:
	if lines.is_empty():
		sequence_finished.emit(sequence_id)
		return
	_sequence_id = sequence_id
	_lines = lines.duplicate()
	_index = 0
	visible = true
	_refresh_line()


func is_sequence_active() -> bool:
	return visible and not _sequence_id.is_empty()


func _advance() -> void:
	if not is_sequence_active():
		return
	_index += 1
	if _index >= _lines.size():
		var completed_id := _sequence_id
		_sequence_id = ""
		_lines.clear()
		_index = 0
		visible = false
		sequence_finished.emit(completed_id)
		return
	_refresh_line()


func _refresh_line() -> void:
	story_label.text = _lines[_index]
