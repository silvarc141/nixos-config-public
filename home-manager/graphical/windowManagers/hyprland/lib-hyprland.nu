# View information about active Hyprland instance.
#
# You must use one of the following subcommands. Using this command as-is will only produce this help message.
export def "sys hypr" [ ] { help sys hypr }

# View information about windows.
export def "sys hypr clients" [ ] {
  hyprctl clients -j 
  | from json
  | insert x {|row| $row.at | first}
  | insert y {|row| $row.at | last}
  | insert width {|row| $row.size | first}
  | insert height {|row| $row.size | last}
  | reject at size
  | move class title pid focusHistoryID xwayland monitor x y width height --first
}

# View information about workspaces.
export def "sys hypr workspaces" [ ] { hyprctl workspaces -j | from json }

# View information about currently active workspace.
export def "sys hypr activeworkspace" [ ] { hyprctl activeworkspace -j | from json }

# View information about previous focused window in active workspace.
export def "sys hypr previous-focus-in-active-workspace" [ ] {
  let activeWorkspaceId = sys hypr activeworkspace | get id
  let activeWorkspaceWindows = sys hypr clients | where { $in.workspace.id == $activeWorkspaceId }
  let previousWindows = $activeWorkspaceWindows | where { $in.focusHistoryID != 0 }
  $previousWindows | sort-by focusHistoryID | default -e [null] | first
}
