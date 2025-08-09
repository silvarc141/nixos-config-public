# View information about Hyprland windows.
export def "sys clients" [ ] {
  hyprctl clients -j 
  | from json
  | insert x {|row| $row.at | first}
  | insert y {|row| $row.at | last}
  | insert width {|row| $row.size | first}
  | insert height {|row| $row.size | last}
  | reject at size
  | move class title pid focusHistoryID xwayland monitor x y width height --first
}
