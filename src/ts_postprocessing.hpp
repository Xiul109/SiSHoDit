#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class TSPostprocessing : public Resource
{
	GDCLASS(TSPostprocessing, Resource);

protected:
	static void _bind_methods();

	float time = 0;
	float sample_rate = 0;
	

public:
	TSPostprocessing();
	~TSPostprocessing();

	double postprocess(double x) const;
};
