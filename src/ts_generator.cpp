#include "ts_generator.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#include "ts_template_segment.hpp"

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

void TSGenerator::init (double sample_rate, Ref<TSTemplate> ts_template)
{
	this->sample_rate = sample_rate;
	this->ts_template = ts_template;

	auto segments = ts_template->get_segments();
	for(int i = 0; i < segments.size(); i++){
		Ref<TSTemplateSegment> segment = Object::cast_to<TSTemplateSegment>(segments[i]);
		segment->set_duration(UtilityFunctions::max(segment->get_duration(), 1.0001/sample_rate));
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
		auto segment = ts_template->get_segment(i);
		double offset = (time - cum_segment_durs)/segment->get_duration();
		int segment_n = UtilityFunctions::minf(segment->get_duration(), duration)*sample_rate+i;
		while (i < segment_n){
			double val = segment->get_shape().is_null() ?  0 : segment->get_shape()->sample(offset);
			auto postprocessings = ts_template->get_postprocessings();
			for (int a=0; a<postprocessings.size(); a++)
				val = Object::cast_to<TSPostprocessing>(postprocessings[a])->postprocess(val);
			values[i] = val;
			time += period;
			offset = (time - cum_segment_durs)/segment->get_duration();
			i++;
		}
		if ((time - cum_segment_durs) >= segment->get_duration()){
			current_segment++;
			cum_segment_durs += segment->get_duration();
		}
		duration -= segment->get_duration();
	}
	
    return values;
}
