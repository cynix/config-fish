setenv HOMEBREW_NO_ANALYTICS 1

abbr cask 'brew cask'

for i in bin sbin
  if test -d /opt/homebrew/$i
    fish_add_path -m /opt/homebrew/$i
  end
end
