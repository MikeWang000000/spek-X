#include <wx/cmdline.h>
#include <wx/log.h>
#include <wx/socket.h>

#include "spek-artwork.h"
#include "spek-platform.h"
#include "spek-preferences.h"

#include "spek-window.h"

class Spek: public wxApp
{
public:
    Spek() : wxApp(), window(NULL), quit(false) {}

protected:
    virtual bool OnInit();
    virtual int OnRun();
#ifdef OS_OSX
    virtual void MacOpenFiles(const wxArrayString& files);
#endif

private:
    SpekWindow *window;
    wxString path;
    wxString pngpath;
#ifdef OS_OSX
    bool cmdcall = false;
#endif
    bool quit;
};

IMPLEMENT_APP(Spek)

bool Spek::OnInit()
{
    wxLog::SetLogLevel(wxLOG_Error);
    wxInitAllImageHandlers();
    wxSocketBase::Initialize();

    spek_artwork_init();
    spek_platform_init();

    SpekPreferences& prefs = SpekPreferences::get();
    prefs.init();
    long width = prefs.get_window_width();
    long height = prefs.get_window_height();

    static const wxCmdLineEntryDesc desc[] = {{
            wxCMD_LINE_SWITCH,
            "h",
            "help",
            "Show this help message",
            wxCMD_LINE_VAL_NONE,
            wxCMD_LINE_OPTION_HELP,
        }, {
            wxCMD_LINE_SWITCH,
            "V",
            "version",
            "Display the version and exit",
            wxCMD_LINE_VAL_NONE,
            wxCMD_LINE_PARAM_OPTIONAL,
        }, {
            wxCMD_LINE_PARAM,
            NULL,
            NULL,
            "FILE",
            wxCMD_LINE_VAL_STRING,
            wxCMD_LINE_PARAM_OPTIONAL,
        }, {
            wxCMD_LINE_PARAM,
            NULL,
            NULL,
            "PNG",
            wxCMD_LINE_VAL_STRING,
            wxCMD_LINE_PARAM_OPTIONAL
        },{
            wxCMD_LINE_PARAM,
            NULL,
            NULL,
            "WIDTH",
            wxCMD_LINE_VAL_NUMBER,
            wxCMD_LINE_PARAM_OPTIONAL
        },{
            wxCMD_LINE_PARAM,
            NULL,
            NULL,
            "HEIGHT",
            wxCMD_LINE_VAL_NUMBER,
            wxCMD_LINE_PARAM_OPTIONAL
        },
        wxCMD_LINE_DESC_END,
    };

    wxCmdLineParser parser(desc, argc, argv);
    int ret = parser.Parse(true);
    if (ret == 1) {
        return false;
    }
    if (ret == -1) {
        this->quit = true;
        return true;
    }
    if (parser.Found("version")) {
        // TRANSLATORS: the %s is the package version.
        wxPrintf(_("Spek version %s"), PACKAGE_VERSION);
        wxPrintf("\n");
        this->quit = true;
        return true;
    }
    if (parser.GetParamCount()) {
        this->path = parser.GetParam();
#ifdef OS_OSX
        this->cmdcall = true;
#endif
    }
    if (parser.GetParamCount() > 1) {
        wxString pngpath = parser.GetParam(1);
        wxFileName png_path(pngpath);
        png_path.MakeAbsolute();
        wxFileName file_path(this->path);

        if (!(png_path.IsDirWritable() || png_path.IsFileWritable())) {
            wxPrintf(_("PNG \"%s\" is not writable"), pngpath);
#ifndef OS_WIN
            wxPrintf("\n");
#endif
            this->quit = true;
            return false;
        }
        if (png_path.SameAs(file_path)) {
            wxPrintf(_("PNG \"%s\" is same as FILE \"%s\""), pngpath, this->path);
#ifndef OS_WIN
            wxPrintf("\n");
#endif
            this->quit = true;
            return false;
        }

        this->pngpath = pngpath;
    }
    if (parser.GetParamCount() > 3) {
        wxString width_str = parser.GetParam(2);
        wxString height_str = parser.GetParam(3);

        if (!(width_str.ToLong(&width) && height_str.ToLong(&height))) {
            width = prefs.get_window_width();
            height = prefs.get_window_height();
        }
    }

    this->window = new SpekWindow(width, height, this->path, this->pngpath);
    this->window->Show(true);
    SetTopWindow(this->window);
    return true;
}

int Spek::OnRun()
{
    if (quit) {
        return 0;
    }

    return wxApp::OnRun();
}

#ifdef OS_OSX
void Spek::MacOpenFiles(const wxArrayString& files)
{
    if (!this->cmdcall && files.GetCount() == 1) {
        this->window->open(files[0]);
    }
}
#endif
