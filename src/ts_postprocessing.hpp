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

	virtual double postprocess(double x) const;
};

// Inherited Classes
class TSPPAbsolute : public TSPostprocessing
{
	GDCLASS(TSPPAbsolute, TSPostprocessing);

protected:
	static void _bind_methods();

public:
	TSPPAbsolute();
	~TSPPAbsolute();

	double postprocess(double x) const;
};

class TSPPScaler : public TSPostprocessing
{
	GDCLASS(TSPPScaler, TSPostprocessing);

protected:
	static void _bind_methods();

	double scaling_factor = 1;

public:
	TSPPScaler();
	~TSPPScaler();

	double get_scaling_factor() const;
	void set_scaling_factor(double sf);

	double postprocess(double x) const;
};

class TSPPGaussianNoise : public TSPostprocessing
{
	GDCLASS(TSPPGaussianNoise, TSPostprocessing);

protected:
	static void _bind_methods();

	double std = 0.0;

public:
	TSPPGaussianNoise();
	~TSPPGaussianNoise();

	double get_std() const;
	void set_std(double deviation);

	double postprocess(double x) const;
};
