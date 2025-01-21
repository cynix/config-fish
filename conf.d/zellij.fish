if set -q ZELLIJ
  # https://github.com/fish-shell/fish-shell/blob/945a53557038062eeb0cae551f8014cef5f3310f/share/functions/fish_title.fish
  function fish_title
    # If we're connected via ssh, we print the hostname.
    set -l ssh
    set -q SSH_TTY; and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"

    # An override for the current command is passed as the first parameter.
    # This is used by `fg` to show the true process name, among others.
    set -l command
    if set -q argv[1]
      set command $argv[1]
    else
      # Don't print "fish" because it's redundant
      set command (status current-command)
      if test "$command" = "fish"
        set command
      end
    end

    echo -- $ssh (string sub -l 20 -- $command) (prompt_pwd -d 1 -D 1)

    # Make Zellij generate a PaneUpdate event _after_ title has been set
    sh -c 'zellij action rename-pane "" &'
  end
end
