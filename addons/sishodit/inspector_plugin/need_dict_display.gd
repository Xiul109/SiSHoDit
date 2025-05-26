extends PanelContainer

var Entry = preload("res://addons/sishodit/inspector_plugin/need_dict_entry.gd")

var container = VBoxContainer.new()
var entries = {}

signal entry_updated(key, value)
signal entry_erased(key)

# Overriden methods
func _ready():
	add_child(container)


# Public methods
func add_entry(key, value):
	var entry = Entry.new(key, value)
	container.add_child(entry)
	entry.value_changed.connect(func(key, value): entry_updated.emit(key, value))
	entry.entry_erased.connect(func(key): entry_erased.emit(key))
	entries[key] = entry

func load_dict(dict):
	# Cleaning of previous entries if there is any
	for child in container.get_children():
		child.queue_free()
	entries.clear()
	# Adding new entries for each one in the dict
	for key in dict:
		add_entry(key, dict[key])
