#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/classes/curve.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

class TSTemplateSegment : public Resource{
    GDCLASS(TSTemplateSegment, Resource);
protected:
    static void _bind_methods();

    Ref<Curve> shape;
    double duration;

public:
	TSTemplateSegment();
    ~TSTemplateSegment();

    Ref<Curve> get_shape() const;
    void set_shape(Ref<Curve> new_shape);

    double get_duration() const;
    void set_duration(double new_dur);
};
