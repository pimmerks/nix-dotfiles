{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;

      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      font_family = "MesloLGL Nerd Font";
      font_size = 11.0;
      adjust_line_height = -4;
      adjust_baseline = 2;
      disable_ligatures = "never";
      mouse_hide_wait = 3.0;

      copy_on_select = false;
      enable_audio_bell = false;
      bell_on_tab = "🔔 ";

      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_activity_symbol = "!";
      tab_title_template = "{index} {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
      active_tab_font_style = "bold-italic";

      kitty_mod = "ctrl+shift";
    };

    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard"
      "cmd+c" = "copy_to_clipboard"

      "kitty_mod+v" = "paste_from_clipboard"
      "cmd+v" = "paste_from_clipboard"

      "kitty_mod+right" = "next_tab"
      "cmd+right" = "next_tab"

      "kitty_mod+left" = "previous_tab"
      "cmd+left" = "previous_tab"

      "kitty_mod+t" = "new_tab"
      "cmd+t" = "new_tab"

      "kitty_mod+q" = "close_tab"
      "cmd+w" = "close_tab"

      "kitty_mod+l" = "next_layout"

      "cmd+1" = "goto_tab 1"
      "cmd+2" = "goto_tab 2"
      "cmd+3" = "goto_tab 3"
      "cmd+4" = "goto_tab 4"
      "cmd+5" = "goto_tab 5"
      "cmd+6" = "goto_tab 6"
      "cmd+7" = "goto_tab 7"
      "cmd+8" = "goto_tab 8"
      "cmd+9" = "goto_tab 9"
      "cmd+0" = "goto_tab 10"
    };


  };
}
