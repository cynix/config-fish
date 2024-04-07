if command -sq mise && not functions -q __mise_env_eval
  mise activate fish | source
end
