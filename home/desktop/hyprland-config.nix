{ self, pkgs, ... }: {

  env = [
    # Some default env vars.
    "XCURSOR_SIZE,24"

    # Nvidia
    "WLR_NO_HARDWARE_CURSORS,1"
    "WLR_RENDERER,vulkan"
    "WLR_DRM_NO_ATOMIC,1" # use legacy DRM interface instead of atomic mode setting. Might fix flickering issues.
    "WLR_BACKEND,vulkan"

    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"

    "__GL_GSYNC_ALLOWED,0"
    "__GL_VRR_ALLOWED,0"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"

    "SDL_VIDEODRIVER,wayland"

    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_QPA_PLATFORMTHEME,qt5ct"
    "QT_STYLE_OVERRIDE,kvantum"

    # XDG
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "XDG_SCREENSHOTS_DIR,~/Pictures/Screenshots"
  ];

  "exec-once" =
    let
      onepassword = "${pkgs._1password-gui}/bin/1password";
      discord = "env -u NIXOS_OZONE_WL ${pkgs.discord}/bin/discord --use-gl=desktop";
      spotify = "${pkgs.spotify}/bin/spotify";
    in
    [
      # Execute your favorite apps at launch
      "${onepassword} --silent" # Startup 1password already

      # Startup other tools
      "[workspace 5 silent] ${discord}"
      "[workspace 5 silent] ${spotify}"
    ];

  "$mainMod" = "SUPER";

  monitor = [
    "HDMI-A-2, 1920x1080@75, 0x0, 1"
    "HDMI-A-1, 1920x1080@75, 1920x0, 1"
  ];

  input = {
    # Keyboard repeatrate/delay
    repeat_rate = 30;
    repeat_delay = 200;

    kb_layout = "us";
    follow_mouse = 2;

    # Sensitivity and no acceleration
    sensitivity = 0;
    accel_profile = "flat";
  };

  general = {
    layout = "dwindle";

    gaps_in = 2;
    gaps_out = 5;
    border_size = 2;

    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    apply_sens_to_raw = 0;
    allow_tearing = true;
  };

  decoration = {
    rounding = 2;

    active_opacity = 1.0;
    inactive_opacity = 0.95;
    fullscreen_opacity = 1.0;

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };

    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  # blurls = "waybar";

  animations = {
    enabled = 1;

    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = 1;
    preserve_split = 1;
    no_gaps_when_only = true;
  };

  master = {
    new_is_master = true;
    no_gaps_when_only = true;
  };

  misc = {
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;

    disable_hyprland_logo = true;
    disable_splash_rendering = true;

    focus_on_activate = true;
  };

  windowrulev2 = [
    "workspace 5 silent, class:^(discord)$"

    # Jetbrains IDE's
    # context-menus
    "noinitialfocus, class:^(jetbrains-.*)$, title:^(win.*)$"
    # Delete popup
    "stayfocused, class:^(jetbrains-.*)$, title:^(Delete)$"
    "dimaround, class:^(jetbrains-.*)$, title:^(Delete)$"

    # 1password
    "float, class:^(1Password)$, title:^(Lock Screen — 1Password)$"
    "dimaround, class:^(1Password)$, title:^(Lock Screen — 1Password)$"

    "dimaround, class:^(1Password)$, title:^(Quick Access — 1Password)$"
    "float, class:^(1Password)$, title:^(Quick Access — 1Password)$"
    "stayfocused, class:^(1Password)$, title:^(Quick Access — 1Password)$"

    # Steam
    "float, class:(steam), title:(Friends List)"

    # Make sure rofi stays focused even when moving mouse
    "float, class:$(Rofi)^"
    "stayfocused, class:$(Rofi)^"
    "dimaround, class:$(Rofi)^"
    "forceinput, class:$(Rofi)^"
    "pin, class:$(Rofi)^"
  ];

  # Workspaces
  workspace = [
    # Workspace rules
    # Create some persistant workspace...
    "1, monitor:HDMI-A-1, persistent:true"
    "2, monitor:HDMI-A-1, persistent:true"
    "3, monitor:HDMI-A-1, persistent:true"

    "4, monitor:HDMI-A-2, persistent:true"
    "5, monitor:HDMI-A-2, persistent:true"
    "6, monitor:HDMI-A-2, persistent:true"
  ];

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  # Keybindings even when locked
  bindl =
    let
      volume-control = "${self.packages.${pkgs.system}.volume-control}/bin/volume-control";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in
    [
      ", XF86AudioRaiseVolume, exec, ${volume-control} up"
      ", XF86AudioLowerVolume, exec, ${volume-control} down"
      ", XF86AudioMute,        exec, ${volume-control} mute"

      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioNext, exec, ${playerctl} next"
    ];

  # Keybindings
  bind =
    let
      onepassword = "${pkgs._1password-gui}/bin/1password";
      hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
      gnome-system-monitor = "${pkgs.gnome.gnome-system-monitor}/bin/gnome-system-monitor";
      kitty = "${pkgs.kitty}/bin/kitty";
      rofi = "${pkgs.rofi-wayland}/bin/rofi";

      screenshot-copy = "${self.packages.${pkgs.system}.screenshot-copy}/bin/screenshot-copy";
      cliphist-rofi = "${self.packages.${pkgs.system}.cliphist-rofi}/bin/cliphist-rofi";
      power-menu-rofi = "${self.packages.${pkgs.system}.power-menu-rofi}/bin/power-menu-rofi";
      monitor-brightness = "${self.packages.${pkgs.system}.monitor-brightness}/bin/monitor-brightness";
    in
    [
      "$mainMod, Q, killactive,"
      "$mainMod, RETURN, exec, ${kitty}"

      # Try to mimick some kind of alt-tab, not working atm...
      #    "ALT, TAB, exec, rofi -show window -kb-accept-entry \"Tab,!Alt+Alt_L\" -kb-row-down \"Alt+Tab\" -selected-row 1 -kb-element-next \"Down\""
      "ALT, TAB, cyclenext"
      "ALT, Tab, bringactivetotop"

      "ALT, SPACE, exec, ${rofi} -show drun"
      "ALT, SPACE, focuswindow, title:(rofi), floating"

      "$mainMod, T, togglefloating,"
      "$mainMod, P, pseudo," # dwindle
      "$mainMod, G, togglesplit," # dwindle
      "$mainMod, S, togglegroup"
      "$mainMod, F, fullscreen,1"
      "$mainMod SHIFT, F, fullscreen,0"

      "$mainMod, L, exec, ${power-menu-rofi}" # Open power menu

      "ALTCTRL, DELETE, exec, ${gnome-system-monitor}"

      "SUPER, V, exec, ${rofi} -modi clipboard:${cliphist-rofi} -show clipboard"
      "CTRLSHIFT, SPACE, exec, ${onepassword} --quick-access"

      ", XF86MonBrightnessUp,   exec, ${monitor-brightness} up"
      ", XF86MonBrightnessDown, exec, ${monitor-brightness} down"

      # Colorpicker one mainMod + printscreen
      "$mainMod, Print, exec, ${hyprpicker} --autocopy --no-fancy"
      ", Print, exec, ${screenshot-copy}"

      # Move focus with mainMod + arrow keys
      "$mainMod, left,  movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up,    movefocus, u"
      "$mainMod, down,  movefocus, d"

      # Move windows around left and right
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
    ];
}
