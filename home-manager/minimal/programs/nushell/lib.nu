# Multi-use command for quick navigation:
# - without arguments: ls
# - path to an existing file: edit the file with $EDITOR
# - path to an existing directory: zoxide to it and ls
# - path to a non-existent file in an existing directory: start $EDITOR with that new file as an argument
# - any other string: try to zoxide to it and ls
export def --env act-on-path [ target?: string ] {
  if ($target | is-empty) { 
    ls
    return
  }
  if ($target | path exists) {
    match ($target | path type) {
      "dir" => { 
        __zoxide_z $target;
        ls
      },
      "file" => { ^$env.EDITOR $target },
      _ => { ls -D $target },
    }
  } else {
    if ($target | path dirname | path exists) {
      ^$env.EDITOR $target
    } else {
      __zoxide_z $target
      ls
    }
  }
}
