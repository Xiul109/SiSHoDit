#pragma once

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/core/class_db.hpp>

#include "ts_template_segment.hpp"
#include "ts_postprocessing.hpp"

using namespace godot;

class TSTemplate : public Resource{
    GDCLASS(TSTemplate, Resource);
protected:
    static void _bind_methods();

    TypedArray<TSTemplateSegment> segments;
    TypedArray<TSPostprocessing> postprocessings;

    bool random = false;
    bool loop = false;

    int _last_random_i = -1;
    int _last_random_segment_i = 0;

public:
	TSTemplate();
    ~TSTemplate();

    Ref<TSTemplateSegment> get_segment(int i);

    // Getters + setters
    TypedArray<TSTemplateSegment> get_segments() const;
    void set_segments(TypedArray<TSTemplateSegment> new_segments);

    TypedArray<TSPostprocessing> get_postprocessings() const;
    void set_postprocessings(TypedArray<TSPostprocessing> new_postprocessings);

    bool is_random() const;
    void set_random(bool new_random);
    
    bool is_loop() const;
    void set_loop(bool new_loop);
};
