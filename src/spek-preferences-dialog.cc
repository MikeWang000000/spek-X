#include "spek-platform.h"
#include "spek-preferences.h"

#include "spek-preferences-dialog.h"

// List all languages with a decent (e.g. 80%) number of translated
// strings. Don't translate language names. Keep the first line intact.
static const char *available_languages[] =
{
    "", "",
    "bs", "Bosanski",
    "ca", "Català",
    "cs", "Čeština",
    "da", "Dansk",
    "de", "Deutsch",
    "el", "Ελληνικά",
    "en", "English",
    "eo", "Esperanto",
    "es", "Español",
    "fi", "Suomi",
    "fr", "Français",
    "gl", "Galego",
    "he", "עִבְרִית",
    "hu", "Magyar nyelv",
    "id", "Bahasa Indonesia",
    "it", "Italiano",
    "ja", "日本語",
    "ko", "한국어/韓國語",
    "lv", "Latviešu",
    "nb", "Norsk (bokmål)",
    "nl", "Nederlands",
    "pl", "Polski",
    "pt_BR", "Português brasileiro",
    "ru", "Русский",
    "sk", "Slovenčina",
    "sr@latin", "Srpski",
    "sv", "Svenska",
    "th", "ภาษาไทย",
    "tr", "Türkçe",
    "uk", "Українська",
    "vi", "Tiếng Việt",
    "zh_CN", "中文(简体)",
    "zh_TW", "中文(台灣)",
    NULL
};

#define ID_LANGUAGE (wxID_HIGHEST + 1)
#define ID_CHECK_UPDATE (wxID_HIGHEST + 2)
#define ID_CHECK_FULL_PATH (wxID_HIGHEST + 3)
#define ID_CHECK_DETAILED_DESCRIPTION (wxID_HIGHEST + 4)

BEGIN_EVENT_TABLE(SpekPreferencesDialog, wxDialog)
    EVT_CHOICE(ID_LANGUAGE, SpekPreferencesDialog::on_language)
    EVT_CHECKBOX(ID_CHECK_UPDATE, SpekPreferencesDialog::on_check_update)
    EVT_CHECKBOX(ID_CHECK_FULL_PATH, SpekPreferencesDialog::on_check_hide_full_path)
    EVT_CHECKBOX(ID_CHECK_DETAILED_DESCRIPTION, SpekPreferencesDialog::on_check_show_detailed_description)
END_EVENT_TABLE()

SpekPreferencesDialog::SpekPreferencesDialog(wxWindow *parent) :
    wxDialog(parent, -1, _("Preferences"))
{
    for (int i = 0; available_languages[i]; ++i) {
        this->languages.Add(wxString::FromUTF8(available_languages[i]));
    }
    this->languages[1] = _("(system default)");

    wxSizer *sizer = new wxBoxSizer(wxVERTICAL);
    wxSizer *inner_sizer = new wxBoxSizer(wxVERTICAL);
    sizer->Add(inner_sizer, 1, wxALL, 12);

    // TRANSLATORS: The name of a section in the Preferences dialog.
    wxStaticText *general_label = new wxStaticText(this, -1, _("General"));
    wxFont font = general_label->GetFont();
    font.SetWeight(wxFONTWEIGHT_BOLD);
    general_label->SetFont(font);
    inner_sizer->Add(general_label);

    if (spek_platform_can_change_language()) {
        wxSizer *language_sizer = new wxBoxSizer(wxHORIZONTAL);
        inner_sizer->Add(language_sizer, 0, wxLEFT | wxTOP, 12);
        wxStaticText *language_label = new wxStaticText(this, -1, _("Language:"));
        language_sizer->Add(language_label, 0, wxALIGN_CENTER_VERTICAL);

        wxChoice *language_choice = new wxChoice(this, ID_LANGUAGE);
        language_sizer->Add(language_choice, 0, wxALIGN_CENTER_VERTICAL | wxLEFT, 12);
        int active_index = 0;
        wxString active_language = SpekPreferences::get().get_language();
        for (unsigned int i = 0; i < this->languages.GetCount(); i += 2) {
            language_choice->Append(this->languages[i + 1]);
            if (this->languages[i] == active_language) {
                active_index = i / 2;
            }
        }
        language_choice->SetSelection(active_index);
    }

    wxCheckBox *check_update = new wxCheckBox(this, ID_CHECK_UPDATE, _("Check for &updates"));
    /* Spek-X do not support check_update */
    check_update->SetValue(false);
    // inner_sizer->Add(check_update, 0, wxLEFT | wxTOP, 12);
    // check_update->SetValue(SpekPreferences::get().get_check_update());

    wxCheckBox *hide_full_path = new wxCheckBox(this, ID_CHECK_FULL_PATH, _("Show &filename only"));
    inner_sizer->Add(hide_full_path, 0, wxLEFT | wxTOP, 12);
    hide_full_path->SetValue(SpekPreferences::get().get_hide_full_path());

    wxCheckBox *show_detailed_description = new wxCheckBox(this, ID_CHECK_DETAILED_DESCRIPTION, _("Show detailed &description"));
    inner_sizer->Add(show_detailed_description, 0, wxLEFT | wxTOP, 12);
    show_detailed_description->SetValue(SpekPreferences::get().get_show_detailed_description());

    sizer->Add(CreateButtonSizer(wxOK), 0, wxALIGN_RIGHT | wxBOTTOM | wxRIGHT, 12);
    sizer->SetSizeHints(this);
    SetSizer(sizer);
}

void SpekPreferencesDialog::on_language(wxCommandEvent& event)
{
    SpekPreferences::get().set_language(this->languages[event.GetSelection() * 2]);
}

void SpekPreferencesDialog::on_check_update(wxCommandEvent& event)
{
    SpekPreferences::get().set_check_update(event.IsChecked());
}

void SpekPreferencesDialog::on_check_hide_full_path(wxCommandEvent& event)
{
    SpekPreferences::get().set_hide_full_path(event.IsChecked());
}

void SpekPreferencesDialog::on_check_show_detailed_description(wxCommandEvent& event)
{
    SpekPreferences::get().set_show_detailed_description(event.IsChecked());
}
