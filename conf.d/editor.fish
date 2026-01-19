if type -q nvim
  set --universal --export EDITOR nvim
else if type -q vim
  set --universal --export EDITOR vim
else if type -q vi
  set --universal --export EDITOR vi
end
