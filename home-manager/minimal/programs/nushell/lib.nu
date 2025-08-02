# Multi-use command for quick navigation:
# - ls when without arguments
# - pass arguments to $EDITOR if the argument is: 
#   a) path to an existing file
#   b) path to a non-existent file in an existing directory
#   c) path to current directory
# - zoxide to argument for any other string, and ls if current directory changed
export def --env --wrapped act-on-path [ ...rest: string ] {
  def --env zoxide_ls [ str: string ] {
    let pwd = $env.PWD
    __zoxide_z $str
    if ($pwd != $env.PWD) { ls }
  }

  let input = $rest | str join
  if ($input | is-empty) { 
    return (ls)
  }

  if ($input | path exists) {
    let expanded = $input | path expand
    let info = ls -D $expanded | first
    match ($info.type) {
      "dir" => { 
        if ($expanded == $env.PWD) {
          ^$env.EDITOR 
          return
        }
        zoxide_ls $expanded
      },
      "file" => { ^$env.EDITOR $input },
      _ => { $info },
    }
  } else {
    if ($input | path dirname | path exists) {
      ^$env.EDITOR $input
    } else {
      zoxide_ls $input
    }
  }
}

# "nix run" wrapper which prepends "nixpkgs" to the argument
export def --env --wrapped __nix-run-nixpkgs [ target: string, ...rest: string ] {
  $target | nix run --impure $"nixpkgs#($in)" -- ...$rest
}

# "nix shell" wrapper which prepends "nixpkgs" to each argument
export def --env --wrapped __nix-shell-nixpkgs [ ...rest: string ] {
  ^nix shell --impure ...($rest | each { $"nixpkgs#($in)" })
}

# Utilities to quickly test changes and iterate on files behind /nix/store symlinks
export def "nix-symlink" [] {}

# Create temporary store symlink copies to iterate quickly
export def "nix-symlink extract" [glob = "**/*": glob] {
    ls ($glob | into glob)
    | where { $in.name | path exists }
    | where { $in.type == symlink }
    | where { (not ($in.name ends-with ".sbak")) }
    | insert expanded { readlink -e $in.name }
    | where { $in.expanded starts-with "/nix/store" }
    | each { 
        mv $in.name $"($in.name).sbak"
        cp $in.expanded $in.name
    }
    | ignore
}

# Restore temporary store symlink copies created by "nix-symlink extract"
export def "nix-symlink restore" [glob = "**/*": glob] {
    ls ($glob | into glob)
    | where { $in.name | path exists } 
    | where { $in.type == file }
    | where { not ($in.name ends-with ".sbak") }
    | where { $"($in.name).sbak" | path exists }
    | each { 
        rm $in.name
        mv $"($in.name).sbak" $in.name
    }
    | ignore
}
