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
    bool quit;
};

IMPLEMENT_APP(Spek)

bool Spek::OnInit()
{
    wxInitAllImageHandlers();
    wxSocketBase::Initialize();

    spek_artwork_init();
    spek_platform_init();
    SpekPreferences::get().init();

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
        },
        wxCMD_LINE_DESC_END,
    };

    wxMessageOutput *msgout = wxMessageOutput::Get();
    wxCmdLineParser parser(desc, argc, argv);
    int ret = parser.Parse(true);
    if (ret == 1) {
#ifndef OS_WIN
        msgout->Printf("\n");
#endif
        return false;
    }
    if (ret == -1) {
#ifndef OS_WIN
        msgout->Printf("\n");
#endif
        this->quit = true;
        return true;
    }
    if (parser.Found("version")) {
        // TRANSLATORS: the %s is the package version.
        msgout->Printf(_("Spek version %s"), PACKAGE_VERSION);
#ifndef OS_WIN
        msgout->Printf("\n");
#endif
        this->quit = true;
        return true;
    }
    if (parser.GetParamCount()) {
        this->path = parser.GetParam();
    }

    // Checking prefs can probably be solved differently.
    SpekPreferences& prefs = SpekPreferences::get();

    this->window = new SpekWindow(prefs.get_window_width(), prefs.get_window_height(), this->path);
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
    if (files.GetCount() == 1) {
        this->window->open(files[0]);
    }
}
#endif
