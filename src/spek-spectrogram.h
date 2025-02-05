#pragma once

#include <memory>

#include <wx/wx.h>

#include "spek-palette.h"
#include "spek-pipeline.h"

class Audio;
class FFT;
class SpekHaveSampleEvent;
struct spek_pipeline;

class SpekSpectrogram : public wxWindow
{
public:
    SpekSpectrogram(wxFrame *parent);
    ~SpekSpectrogram();
    void open(const wxString& path, const wxString& pngpath);
    void save(const wxString& path);

private:
    void on_char(wxKeyEvent& evt);
    void on_paint(wxPaintEvent& evt);
    void on_size(wxSizeEvent& evt);
    void on_have_sample(wxEvent& evt);
    void render(wxDC& dc);

    void start();
    void stop();

    void create_palette();

    static const int MIN_RANGE;
    static const int MAX_RANGE;
    static const int URANGE;
    static const int LRANGE;
    static const int FFT_BITS;
    static const int MIN_FFT_BITS;
    static const int MAX_FFT_BITS;
    static const int LPAD;
    static const int TPAD;
    static const int RPAD;
    static const int BPAD;
    static const int GAP;
    static const int RULER;

    std::unique_ptr<Audio> audio;
    std::unique_ptr<FFT> fft;
    spek_pipeline *pipeline;
    int streams;
    int stream;
    int channels;
    int channel;
    enum window_function window_function;
    wxString path;
    wxString pngpath;
    wxString desc;
    double duration;
    int sample_rate;
    enum palette palette;
    wxImage palette_image;
    wxImage image;
    int prev_width;
    int fft_bits;
    int urange;
    int lrange;

    DECLARE_EVENT_TABLE()
};
