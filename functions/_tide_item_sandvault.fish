function _tide_item_sandvault
  if not set -q SV_SESSION_ID
    return
  end

  set -fx tide_sandvault_color yellow
  set -fx tide_sandvault_bg_color normal
  _tide_print_item sandvault "[SV]"
end

# vim: set ts=2 sw=2 et:
