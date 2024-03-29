{ config, pkgs, user, ... }:
{
  config.home-manager.users.${user}.programs.kitty = {
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
    #   "kitty_mod+c" = "copy_to_clipboard"
    #   "cmd+c" = "copy_to_clipboard"

    #   "kitty_mod+v" = "paste_from_clipboard"
    #   "cmd+v" = "paste_from_clipboard"

    #   "kitty_mod+right" = "next_tab"
    #   "cmd+right" = "next_tab"

    #   "kitty_mod+left" = "previous_tab"
    #   "cmd+left" = "previous_tab"

    #   "kitty_mod+t" = "new_tab"
    #   "cmd+t" = "new_tab"

    #   "kitty_mod+q" = "close_tab"
    #   "cmd+w" = "close_tab"

    #   "kitty_mod+l" = "next_layout"

       "kitty_mod+1" = "goto_tab 1";
       "kitty_mod+2" = "goto_tab 2";
       "kitty_mod+3" = "goto_tab 3";
       "kitty_mod+4" = "goto_tab 4";
       "kitty_mod+5" = "goto_tab 5";
       "kitty_mod+6" = "goto_tab 6";
       "kitty_mod+7" = "goto_tab 7";
       "kitty_mod+8" = "goto_tab 8";
       "kitty_mod+9" = "goto_tab 9";
       "kitty_mod+0" = "goto_tab 10";
     };


  };
}
