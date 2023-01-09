@tool
extends EditorPlugin


const ExchangedResourcePicker = preload(
	"res://addons/imrp/src/scene/ImprovedResourcePicker.tscn"
)


func _enter_tree():
	var editor_tree = get_editor_interface().get_tree()
	editor_tree.connect("node_added",Callable(self,"_on_node_added"))


func _exit_tree():
	var editor_tree = get_editor_interface().get_tree()
	editor_tree.disconnect("node_added",Callable(self,"_on_node_added"))


func _on_node_added(node : Node):
	if node.name == 'EditorResourcePicker':
		var menu : PopupMenu = node.find_child("PopupMenu", true, false)
		menu.connect("about_to_popup",Callable(self,"_on_native_picker_show").bind(menu))


func _on_native_picker_show(native_picker: PopupMenu):
	var ex_picker = ExchangedResourcePicker.instantiate()
	
	get_editor_interface().get_editor_main_screen().add_child(ex_picker)
	ex_picker.decorate(native_picker)
	ex_picker.popup_centered()
