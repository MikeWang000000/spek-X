#include <cmath>

#define __STDC_CONSTANT_MACROS
extern "C" {
#include <libavutil/version.h>
#if LIBAVUTIL_VERSION_INT >= AV_VERSION_INT(58, 18, 100)
#define USE_LIBAVUTIL_TX_API
#include <libavutil/tx.h>
#else
#include <libavcodec/avfft.h>
#endif
}

#include "spek-fft.h"

class FFTPlanImpl : public FFTPlan
{
public:
    FFTPlanImpl(int nbits);
    ~FFTPlanImpl() override;

    void execute() override;

private:
#ifdef USE_LIBAVUTIL_TX_API
    struct AVTXContext *cx;
    av_tx_fn tx_func;
#else
    struct RDFTContext *cx;
#endif
};

std::unique_ptr<FFTPlan> FFT::create(int nbits)
{
    return std::unique_ptr<FFTPlan>(new FFTPlanImpl(nbits));
}

FFTPlanImpl::FFTPlanImpl(int nbits) : FFTPlan(nbits)
{
#ifdef USE_LIBAVUTIL_TX_API
    const float scale = 1.f;
    av_tx_init(&this->cx, &this->tx_func, AV_TX_FLOAT_RDFT, 0, 1 << nbits, &scale, AV_TX_INPLACE);
#else
    this->cx = av_rdft_init(nbits, DFT_R2C);
#endif
}

FFTPlanImpl::~FFTPlanImpl()
{
#ifdef USE_LIBAVUTIL_TX_API
    av_tx_uninit(&this->cx);
#else
    av_rdft_end(this->cx);
#endif
}

void FFTPlanImpl::execute()
{
#ifdef USE_LIBAVUTIL_TX_API
    float *input = this->get_input();
    this->tx_func(this->cx, input, input, sizeof(float));
#else
    av_rdft_calc(this->cx, this->get_input());
#endif

    // Calculate magnitudes.
    int n = this->get_input_size();
    float n2 = n * n;
    this->set_output(0, 10.0f * log10f(this->get_input(0) * this->get_input(0) / n2));
    this->set_output(n / 2, 10.0f * log10f(this->get_input(1) * this->get_input(1) / n2));
    for (int i = 1; i < n / 2; i++) {
        float re = this->get_input(i * 2);
        float im = this->get_input(i * 2 + 1);
        this->set_output(i, 10.0f * log10f((re * re + im * im) / n2));
    }
}
