extends VBoxContainer

var SingleNeedWidget = preload("res://UI/single_need_widget.tscn")

var person : BasicPerson setget person_set
var _need_widgets = {}

# setgets
func person_set(new_person: BasicPerson):
	person = new_person
	_clean_widgets()
	_init_widgets()
	
# overriden methods
func _process(_delta):
	if person:
		for need in person.needs:
			_need_widgets[need.need_key].need_level = need.level

# aux methods
func _clean_widgets():
	for node in get_children():
		node.queue_free()
	_need_widgets = {}

func _init_widgets():
	for need in person.needs:
		var needWidget = SingleNeedWidget.instance()
		add_child(needWidget)
		
		needWidget.need_name = need.need_key
		_need_widgets[needWidget.need_name] = needWidget
