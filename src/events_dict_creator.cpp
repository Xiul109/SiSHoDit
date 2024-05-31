#include "events_dict_creator.hpp"
#include "godot_cpp/variant/dictionary.hpp"
#include "godot_cpp/variant/packed_float32_array.hpp"
#include "godot_cpp/variant/string.hpp"
#include "godot_cpp/variant/typed_array.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>


using namespace godot;

void EventsDictCreator::_bind_methods()
{
	ClassDB::bind_static_method("EventsDictCreator",
								D_METHOD("create_dict", "from", "type", "values", "period", "init_time"),
								&EventsDictCreator::create_dict);
}



TypedArray<Dictionary> EventsDictCreator::create_dict(String from, String type,
													  PackedFloat32Array values,
													  float period, float init_time){
	TypedArray<Dictionary> events = TypedArray<Dictionary>();
	for (float value: values) {
		Dictionary dict = Dictionary();
		dict["from"] = from;
		dict["type"] = type;
		dict["value"] = value;
		dict["time"] = init_time += period;
		events.append(dict);
	}

	return events;
}
