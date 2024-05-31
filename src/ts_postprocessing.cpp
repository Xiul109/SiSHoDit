#include "ts_postprocessing.hpp"
#include "godot_cpp/core/object.hpp"
#include <godot_cpp/variant/utility_functions.hpp>

void TSPostprocessing::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("postprocess", "x"), &TSPostprocessing::postprocess);
}

TSPostprocessing::TSPostprocessing(){}
TSPostprocessing::~TSPostprocessing(){}

double TSPostprocessing::postprocess(double x) const
{
    return x;
}

// Inherited Classes
/// Abs
TSPPAbsolute::TSPPAbsolute(){}
TSPPAbsolute::~TSPPAbsolute(){}

void TSPPAbsolute::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("postprocess", "x"), &TSPPAbsolute::postprocess);
}

double TSPPAbsolute::postprocess(double x) const
{
    return UtilityFunctions::absf(x);
}


/// Scaler
TSPPScaler::TSPPScaler(){}
TSPPScaler::~TSPPScaler(){}

void TSPPScaler::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("postprocess", "x"), &TSPPScaler::postprocess);
    ClassDB::bind_method(D_METHOD("get_scaling_factor"), &TSPPScaler::get_scaling_factor);
    ClassDB::bind_method(D_METHOD("set_scaling_factor", "scaling_factor"), &TSPPScaler::set_scaling_factor);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "scaling_factor"), "set_scaling_factor", "get_scaling_factor");
}

double TSPPScaler::get_scaling_factor() const{ return scaling_factor;}
void TSPPScaler::set_scaling_factor(double sf){ scaling_factor = sf;}

double TSPPScaler::postprocess(double x) const
{
    return x*scaling_factor;
}

/// Gaussian Noise
TSPPGaussianNoise::TSPPGaussianNoise(){}
TSPPGaussianNoise::~TSPPGaussianNoise(){}

void TSPPGaussianNoise::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("postprocess", "x"), &TSPPGaussianNoise::postprocess);
    ClassDB::bind_method(D_METHOD("get_std"), &TSPPGaussianNoise::get_std);
    ClassDB::bind_method(D_METHOD("set_std", "scaling_factor"), &TSPPGaussianNoise::set_std);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "std"), "set_std", "get_std");
}

double TSPPGaussianNoise::get_std() const { return std;}
void TSPPGaussianNoise::set_std(double deviation) { std = deviation;}

double TSPPGaussianNoise::postprocess(double x) const
{
    return x + UtilityFunctions::randfn(0, std);
}
