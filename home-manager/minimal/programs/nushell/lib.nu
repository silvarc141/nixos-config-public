# xdg-open wrapper for detached execution
export def "__xdg-open-detached" [...rest: string] {
    job spawn { xdg-open ...$rest } | ignore
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
        chmod +w $in.name
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
