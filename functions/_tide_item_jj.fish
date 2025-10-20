function _tide_item_jj
  if not command -sq jj; or not jj root --quiet &>/dev/null
    return 1
  end

  jj --at-operation=@ debug snapshot

  set jj_branch (jj --ignore-working-copy --at-operation=@ --color=never --no-pager log --limit=1 --no-graph --revisions='
    coalesce(
      heads(::@ & (bookmarks() | remote_bookmarks() | tags())),
      heads(@:: & (bookmarks() | remote_bookmarks() | tags())),
      trunk(),
    )' --template='separate(" ", bookmarks, tags)' 2>/dev/null | cut -d ' ' -f 1)

  if test -n "$jj_branch"
    set jj_branch (string trim --right --chars '*' "$jj_branch")
    set jj_commits_before (jj --ignore-working-copy --at-operation=@ --color=never --no-pager log --no-graph --revisions="@..$jj_branch & (~empty() | merges())" --template='"x"' 2>/dev/null | wc -c | tr -d ' ')
    set jj_commits_after  (jj --ignore-working-copy --at-operation=@ --color=never --no-pager log --no-graph --revisions="$jj_branch..@ & (~empty() | merges())" --template='"x"' 2>/dev/null | wc -c | tr -d ' ')
    set -l jj_counts (jj --ignore-working-copy --at-operation=@ --color=never --no-pager bookmark list --revisions="$jj_branch" --template='
      if(remote,
        separate("#",
          coalesce(tracking_ahead_count.exact(), tracking_ahead_count.lower()),
          coalesce(tracking_behind_count.exact(), tracking_behind_count.lower()),
        ) ++ "\n"
      )
    ' 2>/dev/null | string split '#')
    set jj_remote_ahead  (string pad --char '0' --width 1 "$jj_counts[1]")
    set jj_remote_behind (string pad --char '0' --width 1 "$jj_counts[2]")

    if test "$jj_remote_ahead" -gt 0 -a "$jj_remote_behind" -gt 0
      set jj_branch_color red
    else if test "$jj_remote_ahead" -gt 0
      set jj_branch_color cyan
    else if test "$jj_remote_behind" -gt 0
      set jj_branch_color magenta
    else
      set jj_branch_color green
    end
  end

  set -l jj_changes (jj --ignore-working-copy --at-operation=@ --color=never --no-pager log --no-graph --revisions=@ --template='diff.summary()' 2>/dev/null | awk 'BEGIN {a=0; d=0; m=0} /^A / {a++} /^D / {d++} /^M / {m++} /^R / {m++} /^C / {a++} END {print(a, d, m)}' | string split ' ')
  set jj_added    $jj_changes[1]
  set jj_deleted  $jj_changes[2]
  set jj_modified $jj_changes[3]

  set jj_status (jj --ignore-working-copy --at-operation=@ --color=always --no-pager log --limit=1 --no-graph --revisions=@ --template='
    separate(" ",
      change_id.shortest(4),
      commit_id.shortest(4),
      surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
      concat(
        if(!empty, "✏️"),
        if(conflict, "💥"),
        if(divergent, "🚧"),
        if(hidden, "👻"),
        if(immutable, "🔒"),
      ),
    )
  ' | string trim)

  _tide_print_item jj $tide_jj_icon' ' (
    if test -n "$jj_branch"
      set_color "$jj_branch_color"
      echo -ns "$jj_branch"

      if test "$jj_commits_before" -gt 0; echo -ns "‹$jj_commits_before"; end
      if test "$jj_commits_after"  -gt 0; echo -ns "›$jj_commits_after" ; end
      if test "$jj_remote_ahead"   -gt 0; echo -ns "⇣$jj_remote_ahead"  ; end
      if test "$jj_remote_behind"  -gt 0; echo -ns "⇡$jj_remote_behind" ; end

      echo -ns ' '
    end

    set jj_space ''
    if test "$jj_added"    -gt 0; set_color green ; echo -ns "+$jj_added"   ; set jj_space ' '; end
    if test "$jj_deleted"  -gt 0; set_color red   ; echo -ns "-$jj_deleted" ; set jj_space ' '; end
    if test "$jj_modified" -gt 0; set_color yellow; echo -ns "~$jj_modified"; set jj_space ' '; end
    echo -ns "$jj_space"

    set_color normal
    echo -ns "$jj_status"
  )
end

# vim: set ts=2 sw=2 et:
