set -g fisher_path ~/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

if not functions -q fisher
	set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
	curl -sL https://github.com/jorgebucaran/fisher/raw/main/functions/fisher.fish | source
end

for file in $fisher_path/conf.d/*.fish
	builtin source $file 2> /dev/null
end
