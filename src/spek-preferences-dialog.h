#pragma once

#include <wx/wx.h>

class SpekPreferencesDialog : public wxDialog
{
public:
    SpekPreferencesDialog(wxWindow *parent);

private:
    void on_language(wxCommandEvent& event);
    void on_check_update(wxCommandEvent& event);
    void on_check_hide_full_path(wxCommandEvent& event);

    wxArrayString languages;

    DECLARE_EVENT_TABLE()
};
