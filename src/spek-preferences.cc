#include <wx/string.h>

#include "spek-platform.h"

#include "spek-preferences.h"

SpekPreferences& SpekPreferences::get()
{
    static SpekPreferences instance;
    return instance;
}

void SpekPreferences::init()
{
    if (this->locale) {
        delete this->locale;
    }
    this->locale = new wxLocale();

#ifdef OS_WIN
    // Load MO files embedded in Windows executable file.
    wxTranslations *translation = wxTranslations::Get();
    if (translation == nullptr) {
        translation = new wxTranslations();
        wxTranslations::Set(translation);
    }
    wxResourceTranslationsLoader *loader = new wxResourceTranslationsLoader();
    translation->SetLoader(loader);
#endif

    int lang = wxLANGUAGE_DEFAULT;
    wxString code = this->get_language();
    if (spek_platform_can_change_language() && !code.IsEmpty()) {
        const wxLanguageInfo *info = wxLocale::FindLanguageInfo(code);
        if (info) {
            lang = info->Language;
        }
    }
    this->locale->Init(lang);
    this->locale->AddCatalog(GETTEXT_PACKAGE);
}

SpekPreferences::SpekPreferences() : locale(NULL)
{
    wxString path = spek_platform_config_path("spek");
    this->config = new wxFileConfig(
        wxEmptyString,
        wxEmptyString,
        path,
        wxEmptyString,
        wxCONFIG_USE_LOCAL_FILE,
        wxConvUTF8
    );
}

bool SpekPreferences::get_check_update()
{
    bool result = true;
    this->config->Read("/update/check", &result);
    return result;
}

void SpekPreferences::set_check_update(bool value)
{
    this->config->Write("/update/check", value);
    this->config->Flush();
}

long SpekPreferences::get_last_update()
{
    long result = 0;
    this->config->Read("/update/last", &result);
    return result;
}

void SpekPreferences::set_last_update(long value)
{
    this->config->Write("/update/last", value);
    this->config->Flush();
}

wxString SpekPreferences::get_language()
{
    wxString result("");
    this->config->Read("/general/language", &result);
    return result;
}

void SpekPreferences::set_language(const wxString& value)
{
    this->config->Write("/general/language", value);
    this->config->Flush();
}

bool SpekPreferences::get_hide_full_path()
{
    bool result = false;
    this->config->Read("/general/hidepath", &result);
    return result;
}

void SpekPreferences::set_hide_full_path(bool value)
{
    this->config->Write("/general/hidepath", value);
    this->config->Flush();
}

bool SpekPreferences::get_show_detailed_description()
{
    bool result = false;
    this->config->Read("/general/showdetails", &result);
    return result;
}

void SpekPreferences::set_show_detailed_description(bool value)
{
    this->config->Write("/general/showdetails", value);
    this->config->Flush();
}

int SpekPreferences::get_window_width()
{
    int result = 640 * spek_platform_dpi_scale();
    this->config->Read("/general/width", &result);
    return result;
}

int SpekPreferences::get_window_height()
{
    int result = 480 * spek_platform_dpi_scale();
    this->config->Read("/general/height", &result);
    return result;
}
