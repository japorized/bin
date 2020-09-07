#!/usr/bin/env ruby

# keybindings
$SHADOW_KEY="Alt+s"
$COPY_KEY="Alt+c"
$DELAY_KEY="Alt+d"
$CURSOR_KEY="Alt+C"

# configurations
$font="Hack Nerd Font 10"
$highlightcolor='Aqua'

# load configs
require "~/.config/rofi/script-configs/rofi-screenshot.conf.rb"

$highlightcolor=Config::HIGHLIGHTCOLOR if defined? Config::HIGHLIGHTCOLOR
$font=Config::FONT if defined? Config::FONT

$scrotcmd="~/.bin/screenshot.sh"

$hasShadow=false
$hasCopy=false
$hasDelay=false
$hasCursor=false
$shadowIndex=3
$copyIndex=4
$delayIndex=5
$cursorIndex=6
$delay=0

$rofi_active=[]

$cancelNoti="$HOME/.config/lemonbar/show.sh 'Scrot cancelled'  "

def rofi(opts, *args)
  options = args.join('|')
  `echo -n "#{options}" | \
     -theme "$XDG_CONFIG_HOME/rofi/theme/rofi-sidemenu.rasi" \
   rofi -sep '|' -columns 1 -lines 7 -disable-history true -cycle true \
     -location 4 -width 5 \
     -dmenu -font "#{$font}" \
     #{opts}`
end

def rofimsg(msg)
  `rofi -theme "$XDG_CONFIG_HOME/rofi/theme/rofi-smallmenu.rasi" \
     -location 5 -width 170 -height 50 \
     -font "#{$font}" \
     -e '#{msg}'`
end

def toggleShadow()
  $hasShadow=!$hasShadow
  if $hasShadow
    $rofi_active.push($shadowIndex)
  else
    $rofi_active.delete($shadowIndex)
  end
end

def toggleCopy()
  $hasCopy=!$hasCopy
  if $hasCopy
    $rofi_active.push($copyIndex)
  else
    $rofi_active.delete($copyIndex)
  end
end

def toggleDelay()
  if $hasDelay
    $hasDelay = false
    $rofi_active.delete($delayIndex)
  else
    delay = rofi("-mesg 'Delay'", 3, 5, 10).chomp
    retval = $?.exitstatus

    if retval == 0
      $hasDelay = true
      $delay = delay
      $rofi_active.push($delayIndex)
    end
  end
end

def toggleCursor()
  $hasCursor = !$hasCursor
  if $hasCursor
    $rofi_active.push($cursorIndex)
  else
    $rofi_active.delete($cursorIndex)
  end
end

def getScrotOpts()
  return "#{'-s' if $hasShadow}#{' -c' if $hasCopy}#{" -d #{$delay}" if $hasDelay}#{' -u' if $hasCursor}".chomp
end

def main
  rofi_active = $rofi_active.join(',')
  rofiopts = "-mesg ' SCROT' \
  -kb-custom-1 '#{$SHADOW_KEY}' -kb-custom-2 '#{$COPY_KEY}' \
  -kb-custom-3 '#{$DELAY_KEY}' -kb-custom-4 '#{$CURSOR_KEY}' \
  #{"-a" if rofi_active.length > 0} #{rofi_active}"
  
  choice = rofi(rofiopts, "", "濾", "类", "", "", "", "").chomp
  retval = $?.exitstatus

  case retval
    when 1
      `#{$cancelNoti}`
      exit(0)
    when 10
      toggleShadow
      main
    when 11
      toggleCopy
      main
    when 12
      toggleDelay
      main
    when 13
      toggleCursor
      main
    when 0
      case choice
        when ""
          toggleShadow
          main
        when ""
          toggleCopy
          main
        when ""
          toggleDelay
          main
        when ""
          toggleCursor
          main
        when ""
          sleep(0.3)
          `#{$scrotcmd} #{getScrotOpts()} fullscreen`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
        when "濾" 
          sleep(0.3)
          `#{$scrotcmd} #{getScrotOpts()} select`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
        when "类"
          sleep(0.3)
          `#{$scrotcmd} #{getScrotOpts()} window`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
      end
  end
end

main
