{
  runCommand,
  deadnix,
  alejandra,
  statix,
  self,
}: {
  formatting =
    runCommand "check-formatting"
    {
      nativeBuildInputs = [
        deadnix
        alejandra
        statix
      ];
    }
    ''
      cd ${self}

      echo "Running deadnix..."
      deadnix --fail

      echo "Running nixfmt..."
      alejandra --check .

      echo "Running statix"
      statix check .

      touch $out
    '';
}
