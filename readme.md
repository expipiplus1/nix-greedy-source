Repro for https://github.com/NixOS/nixpkgs/issues/86775

To reproduce:

- Make `foo` unreadable (`chmod a-r foo`)
- Try to enter a nix shell (`nix-shell`)
- Observe that the command fails because it is unable to read `foo` (`error: opening file '/home/j/projects/bugs/nix-greedy-source/foo': Permission denied`)
- Modify nixpkgs thusly:

    ```diff
    diff --git a/pkgs/development/haskell-modules/make-package-set.nix b/pkgs/development/haskell-modules/make-package-set.nix
    index 45fe475b733..38265a2e8af 100644
    --- a/pkgs/development/haskell-modules/make-package-set.nix
    +++ b/pkgs/development/haskell-modules/make-package-set.nix
    @@ -354,7 +354,7 @@ in package-set { inherit pkgs stdenv callPackage; } self // {
             #
             #   isNotSelected lens [ frontend backend common ]
             #   => true
    -        isNotSelected = input: pkgs.lib.all (p: input.outPath or null != p.outPath) selected;
    +        isNotSelected = input: true;

             # A function that takes a list of list of derivations, filters out all
             # the `selected` packages from each list, and concats the results.
    ```

- Try to enter a nix shell (`nix-shell`)
- Observe that only `package.yaml` is read and you can enter the shell
  successfully
