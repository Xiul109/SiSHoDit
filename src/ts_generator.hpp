#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "ts_template.hpp"
#include "ts_postprocessing.hpp"

using namespace godot;

class TSGenerator : public RefCounted
{
	GDCLASS(TSGenerator, RefCounted);

protected:
	static void _bind_methods();

	double time = 0;
	double sample_rate = 1.0;
	Ref<TSTemplate> ts_template;

	int current_segment = 0;
	double cum_segment_durs = 0.0;

public:
	TSGenerator();
	~TSGenerator();

	void init(double sample_rate, Ref<TSTemplate> ts_template);
	PackedFloat32Array generate(double duration);
};
