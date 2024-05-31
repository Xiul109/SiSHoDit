#include "ts_generator.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/curve.hpp>
#include <godot_cpp/classes/object.hpp>

#include "ts_postprocessing.hpp"

using namespace godot;

void TSGenerator::_bind_methods()
{
	ClassDB::bind_method(D_METHOD("init", "sample_rate", "ts_template"), &TSGenerator::init);
	ClassDB::bind_method(D_METHOD("generate", "duration"), &TSGenerator::generate);
}


TSGenerator::TSGenerator()
{
}

TSGenerator::~TSGenerator()
{
}

void TSGenerator::init (double sample_rate, Variant ts_template)
{
	this->sample_rate = sample_rate;
	this->ts_template = ts_template;

	Array segments = ts_template.get("segments");
	for(int i = 0; i < segments.size(); i++){
		Variant segment = segments[i];
		segment.set("duration", UtilityFunctions::max(segment.get("duration"), 1.0001/sample_rate));
	}
}

PackedFloat32Array TSGenerator::generate(double duration)
{
	auto values = PackedFloat32Array();
	int i = 0;
	int n = duration*sample_rate;
	double period = 1/sample_rate;
	values.resize(n);

	while(duration > 0.0){
		Variant segment = ts_template.call("get_segment", current_segment);
		double segment_duration = double(segment.get("duration"));

		double offset; int segment_n;
		if (current_segment >= int(ts_template.get("segments").call("size")) &&
			! ( bool(ts_template.get("loop")) || bool(ts_template.get("random")))){
			offset = 1.0;
			segment_n = duration*sample_rate+i;
		}else{
			offset = (time - cum_segment_durs)/segment_duration;
			segment_n = UtilityFunctions::minf(segment_duration, duration)*sample_rate+i;
		}

		if(segment_n == 0)
				break;

		while (i < segment_n){
			Ref<Curve> shape = Object::cast_to<Curve>(segment.get("shape"));
			double val = shape.is_null() ?  0.0 : shape->sample(offset);
			Variant postprocessings = ts_template.get("postprocessings");
			for (int a=0; a < int(postprocessings.call("size")); a++){
				bool valid, oob; // I don't know what to do with these checks
				val = Object::cast_to<TSPostprocessing>(postprocessings.get_indexed(a, valid, oob))->postprocess(val);
			}
			values[i] = val;
			time += period;
			offset = (time - cum_segment_durs)/segment_duration;
			i++;
		}
		if ((time - cum_segment_durs) >= segment_duration){
			current_segment++;
			cum_segment_durs += segment_duration;
		}
		duration -= segment_n * period;
	}

    return values;
}
