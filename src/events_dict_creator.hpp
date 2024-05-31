#pragma once

#include "godot_cpp/variant/array.hpp"
#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class EventsDictCreator : public Object
{
	GDCLASS(EventsDictCreator, Object);
protected:
	static void _bind_methods();

public:
	static TypedArray<Dictionary> create_dict(String from, String type,
											  PackedFloat32Array values, float period, float offset);
};
