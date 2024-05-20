#include "ts_template_segment.hpp"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TSTemplateSegment::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_shape", "new_shape"), &TSTemplateSegment::set_shape);
    ClassDB::bind_method(D_METHOD("get_shape"), &TSTemplateSegment::get_shape);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "shape", PROPERTY_HINT_RESOURCE_TYPE, "Curve"), "set_shape", "get_shape");

    ClassDB::bind_method(D_METHOD("set_duration", "new_dur"), &TSTemplateSegment::set_duration);
    ClassDB::bind_method(D_METHOD("get_duration"), &TSTemplateSegment::get_duration);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "duration"), "set_duration", "get_duration");
}

TSTemplateSegment::TSTemplateSegment()
{
}

TSTemplateSegment::~TSTemplateSegment()
{
}

Ref<Curve> TSTemplateSegment::get_shape() const
{
    return shape;
}

void TSTemplateSegment::set_shape(Ref<Curve> new_shape)
{
    shape = new_shape;
}

double TSTemplateSegment::get_duration() const
{
    return duration;
}

void TSTemplateSegment::set_duration(double new_dur)
{
    duration = new_dur;
}
