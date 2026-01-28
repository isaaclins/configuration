# Shared Fish configuration managed by Home Manager
# This file will be symlinked to ~/.config/fish/config.fish
#
# You can edit this like a normal Fish config file. Changes are applied
# on the next Home Manager activation.

# Example: remove the default greeting (clean prompt)
set -g fish_greeting ""

# Example: enable Starship prompt if installed
if type -q starship
  starship init fish | source
end

