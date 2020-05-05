Repro for https://github.com/NixOS/nixpkgs/issues/86775

To reproduce:

- Make `foo` unreadable (`chmod a-r foo`)
- Try to enter a nix shell (`nix-shell`)
- Observe that the command fails because it is unable to read `foo` (`error: opening file '/home/j/projects/bugs/nix-greedy-source/foo': Permission denied`)
- Modify nixpkgs thusly:

    ```diff
    diff --git a/pkgs/development/haskell-modules/make-package-set.nix b/pkgs/development/haskell-modules/make-package-set.nix
    index 9ba25e09db9..1e7c7d6dfff 100644
    --- a/pkgs/development/haskell-modules/make-package-set.nix
    +++ b/pkgs/development/haskell-modules/make-package-set.nix
    @@ -298,8 +298,7 @@ in package-set { inherit pkgs stdenv callPackage; } self // {
                 # If `packages = [ a b ]` and `a` depends on `b`, don't build `b`,
                 # because cabal will end up ignoring that built version, assuming
                 # new-style commands.
    -            combinedPackages = pkgs.lib.filter
    -              (input: pkgs.lib.all (p: input.outPath or null != p.outPath) selected);
    +            combinedPackages = x: x;
    ```

- Try to enter a nix shell (`nix-shell`)
- Observe that only `package.yaml` is read and you can enter the shell
  successfully
