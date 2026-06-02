{ pkgs, lib, config, inputs, ... }:

{
  languages.python =
  {
    enable = true;
    version = "3.13";
    venv.enable = true;

    uv =
    {
      enable = true;
      sync.enable = true;  # Auto-sync dependencies on direnv reload
    };
  };

  # cairosvg rasterizes the cached flag SVGs for the PDF; its cairocffi backend
  # dlopen()s the system Cairo library, so Cairo must be both installed and on the
  # dynamic-loader path (LD_ on Linux/NixOS, DYLD_ on macOS).

  packages = [ pkgs.cairo ];

  env.LD_LIBRARY_PATH   = lib.makeLibraryPath [ pkgs.cairo ];
  env.DYLD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.cairo ];

  # Tell uv to use devenv's venv

  env.UV_PROJECT_ENVIRONMENT = "${config.devenv.root}/.devenv/state/venv";

  # See full reference at https://devenv.sh/reference/options/
}
