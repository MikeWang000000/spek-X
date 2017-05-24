#ifndef SPEK_FFT_H_
#define SPEK_FFT_H_

struct RDFTContext;

struct spek_fft_plan
{
    // Internal data.
    struct RDFTContext *cx;
    int n;

    // Exposed properties.
    float *input;
    float *output;
};

// Allocate buffers and create a new FFT plan.
struct spek_fft_plan * spek_fft_plan_new(int n);

// Execute the FFT on plan->input.
void spek_fft_execute(struct spek_fft_plan *p);

// Destroy the plan and de-allocate buffers.
void spek_fft_delete(struct spek_fft_plan *p);

#endif
