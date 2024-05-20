#include "ts_template.hpp"

#include <godot_cpp/variant/utility_functions.hpp>

void TSTemplate::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_segments", "new_segments"), &TSTemplate::set_segments);
    ClassDB::bind_method(D_METHOD("get_segments"), &TSTemplate::get_segments);
    auto segments_info = make_property_info(Variant::ARRAY, "segments", PROPERTY_HINT_ARRAY_TYPE,
                                            vformat("%s/%s:%s", Variant::OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "TSTemplateSegment"));
    ADD_PROPERTY(segments_info, "set_segments", "get_segments");

    ClassDB::bind_method(D_METHOD("set_postprocessings", "new_new_postprocessings"), &TSTemplate::set_postprocessings);
    ClassDB::bind_method(D_METHOD("get_postprocessings"), &TSTemplate::get_postprocessings);
    auto postproc_info = make_property_info(Variant::ARRAY, "postprocessings", PROPERTY_HINT_ARRAY_TYPE,
                                            vformat("%s/%s:%s", Variant::OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "TSPostprocessing"));    
    ADD_PROPERTY(postproc_info,"set_postprocessings", "get_postprocessings");

    ADD_GROUP("Advanced chosing", "");
    ClassDB::bind_method(D_METHOD("set_random", "new_random"), &TSTemplate::set_random);
    ClassDB::bind_method(D_METHOD("is_random"), &TSTemplate::is_random);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "random"), "set_random", "is_random");

    ClassDB::bind_method(D_METHOD("set_loop", "new_loop"), &TSTemplate::set_loop);
    ClassDB::bind_method(D_METHOD("is_loop"), &TSTemplate::is_loop);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "loop"), "set_loop", "is_loop");

    ClassDB::bind_method(D_METHOD("get_segment", "i"), &TSTemplate::get_segment);
}

TSTemplate::TSTemplate()
{
}

TSTemplate::~TSTemplate()
{
}

Ref<TSTemplateSegment> TSTemplate::get_segment(int i)
{
    if(segments.size() == 0){
        UtilityFunctions::push_error("Segments array is empty");
        return Ref<TSTemplateSegment>();
    }

    if(random) {
        if (_last_random_i != i){
            _last_random_i = i;
            _last_random_segment_i = UtilityFunctions::randi_range(0, segments.size()-1);
        }
        i = _last_random_segment_i;
    } 
    else{
        i = UtilityFunctions::max(0, i);
        if(loop)
            i = i%segments.size();
        else
            i = UtilityFunctions::min(i, segments.size()-1);
    }
        
    return Object::cast_to<TSTemplateSegment>(segments[i]);
}

TypedArray<TSTemplateSegment> TSTemplate::get_segments() const
{
    return segments;
}

void TSTemplate::set_segments(TypedArray<TSTemplateSegment> new_segments)
{
    segments = new_segments;
}

TypedArray<TSPostprocessing> TSTemplate::get_postprocessings() const
{
    return postprocessings;
}

void TSTemplate::set_postprocessings(TypedArray<TSPostprocessing> new_postprocessings)
{
    postprocessings = new_postprocessings;
}

bool TSTemplate::is_random() const
{
    return random;
}

void TSTemplate::set_random(bool new_random)
{
    random = new_random;
}

bool TSTemplate::is_loop() const
{
    return loop;
}

void TSTemplate::set_loop(bool new_loop)
{
    loop = new_loop;
}
