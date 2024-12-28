if command -sq zellij && not functions -q __auto_zellij_tab_name
  function __auto_zellij_tab_name --on-variable PWD --description "Update zellij tab name on directory change"
    if set -q ZELLIJ
      nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1
    end
  end

  __auto_zellij_tab_name
end
