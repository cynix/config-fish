if status is-interactive && type -q tide
  if ! set -q tide__configured
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Few icons' --transient=No
    set -U tide__configured true
  end
  set -U tide_left_prompt_items context pwd git newline character
  set -U tide_right_prompt_items status cmd_duration jobs shlvl time
  set -U tide_shlvl_threshold 2
end
