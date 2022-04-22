# Ploybar Mpris Control

🎶This polybar module displays mpris-enabled media information on your device. Besides, it use [zscroll](https://github.com/noctuid/zscroll) to display information in a small place.

🤗 Many ideas and codes come from [PrayagS/polybar-spotify](https://github.com/PrayagS/polybar-spotify), thanks a lot!

### Features and Previews

- Show Informations  
  ![normal-bar](/images/normal-bar.png)
- Adjust volume by scrolling on left icon, progress bar or song title(only works in very few players)
- player switch(Just click the left icon to open)  
  ![player-switch](/images/player-switch.png)
- Can change menu icon if the player is chromium/ firefox/ spotify/ vlc
  - using chromium  
    ![chrome-bar](/images/chrome-bar.png)
  - using firefox  
    ![chrome-bar](/images/firefox-bar.png)
  - using vlc  
    ![vlc-bar](/images/vlc-bar.png)
  - using spotify  
    ![spotify-bar](/images/spotify-bar.png)

### Dependencies

- [zscroll](https://github.com/noctuid/zscroll): To scroll the fetched text
- [rofi](https://github.com/davatorium/rofi): To provide player switch
- icomoon font family: To provides icon fonts on polybar. You can replace the icon in the code to remove the dependency.

### Config

- move `/mpris` to `~/.config/polybar/scripts/`
- add modules in `config.ini`
  ```ini
  modules-left = mrpis-control mrpis-prev mrpis-play-pause mrpis-next mrpis-process mrpis-status
  ```
- add modules config
  ```ini
  [module/mrpis-control]

  type = custom/script
  exec = ~/.config/polybar/scripts/mpris/mpris_control.sh --icon
  format = <label>
  click-left = ~/.config/polybar/scripts/mpris/mpris_control.sh --select
  scroll-up = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05+
  scroll-down = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05-

  [module/mrpis-status]

  type = custom/script
  tail = true
  interval = 1
  ; prefix symbol is shown before the text
  format = <label>
  exec = ~/.config/polybar/scripts/mpris/scoll.sh
  scroll-up = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05+
  scroll-down = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05-

  [module/mrpis-prev]
  type = custom/script
  exec = echo ""
  format = <label>
  click-left = ~/.config/polybar/scripts/mpris/mpris_control.sh --previous

  [module/mrpis-play-pause]
  type = custom/script
  exec = echo "懶"
  format = <label>
  click-left = ~/.config/polybar/scripts/mpris/mpris_control.sh --playpause

  [module/mrpis-next]
  type = custom/script
  exec = echo ""
  format = <label>
  click-left = ~/.config/polybar/scripts/mpris/mpris_control.sh --next

  [module/mrpis-process]
  type = custom/script
  tail = true
  interval = 1
  ; prefix symbol is shown before the text
  format = <label>
  exec = ~/.config/polybar/scripts/mpris/mpris_control.sh --process
  scroll-up = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05+
  scroll-down = ~/.config/polybar/scripts/mpris/mpris_control.sh --vc 0.05-
  ```

### Customize

- You can replace the icons on polybar, two good website to choose icons are: [Nerd Fonts](https://www.nerdfonts.com/cheat-sheet), [FontAwsome](https://fontawesome.com/v5/cheatsheet). **Always be aware that you are using an available font family**
- You can add lyrics display just copy modify the mrpis-status module. This requires the player to write the lyrics to `metadata.someattribute` (although this may not be language compliant)
- For [YesPlayMusic](https://github.com/qier222/YesPlayMusic) user, I recommend to use the [polybar-yesplaymusic-lyrics](https://github.com/KairuiLiu/polybar-yesplaymusic-lyrics] to show lyrics on polybar
