#!/usr/bin/env ruby

# keybindings
$SHADOW_KEY="Alt+s"
$COPY_KEY="Alt+c"
$DELAY_KEY="Alt+d"

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
$shadowIndex=3
$copyIndex=4
$delayIndex=5
$delay=0

$rofi_active=[]

$cancelNoti="$HOME/.config/lemonbar/show.sh 'Scrot cancelled'  "

def rofi(opts, *args)
  options = args.join('|')
  `echo -n "#{options}" | \
   rofi -sep '|' -columns 1 -lines 6 -disable-history true -cycle true \
     -theme "$XDG_CONFIG_HOME/rofi/theme/rofi-sidemenu.rasi" \
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
    delay = rofi("-mesg 'Delay'", 3, 5, 10)
    retval = $?.exitstatus

    if retval == 0
      $hasDelay = true
      $delay = delay
      $rofi_active.push($delayIndex)
    end
  end
end

def getScrotOpts()
  return "#{'-s' if $hasShadow}#{' -c' if $hasCopy}#{" -d #{$delay}" if $hasDelay}".chomp
end

def main
  rofi_active = $rofi_active.join(',')
  rofiopts = "-mesg ' SCROT' \
  -kb-custom-1 '#{$SHADOW_KEY}' -kb-custom-2 '#{$COPY_KEY}' -kb-custom-3 '#{$DELAY_KEY}' \
  #{"-a" if rofi_active.length > 0} #{rofi_active}"
  
  choice = rofi(rofiopts, "", "濾", "类", "", "", "").chomp
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
        when ""
          `#{$scrotcmd} #{getScrotOpts()} fullscreen`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
        when "濾" 
          `#{$scrotcmd} #{getScrotOpts()} select`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
        when "类"
          `#{$scrotcmd} #{getScrotOpts()} window`
          if $?.exitstatus != 0
            `#{$cancelNoti}`
          end
      end
  end
end

main
