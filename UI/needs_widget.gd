extends VBoxContainer

var SingleNeedWidget = preload("res://UI/single_need_widget.tscn")

var agent : Agent : set = agent_set
var _need_widgets = {}

# setgets
func agent_set(new_agent: Agent):
	agent = new_agent
	_clean_widgets()
	_init_widgets()
	
# overriden methods
func _process(_delta):
	if agent == null:
		return
	for need in agent.needs:
		_need_widgets[need.need_key].need_level = need.level

# aux methods
func _clean_widgets():
	for node in get_children():
		node.queue_free()
	_need_widgets = {}

func _init_widgets():
	for need in agent.needs:
		var needWidget = SingleNeedWidget.instantiate()
		add_child(needWidget)
		
		needWidget.need_name = need.need_key
		_need_widgets[needWidget.need_name] = needWidget
