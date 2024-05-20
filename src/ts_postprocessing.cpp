#include "ts_postprocessing.hpp"

void TSPostprocessing::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("postprocess", "x"), &TSPostprocessing::postprocess);
}

TSPostprocessing::TSPostprocessing()
{
}

TSPostprocessing::~TSPostprocessing()
{
}

double TSPostprocessing::postprocess(double x) const
{
    return x;
}
