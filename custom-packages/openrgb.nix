{
  lib,
  stdenv,
  fetchFromGitLab,
  libsForQt5,
  libusb1,
  hidapi,
  pkg-config,
  coreutils,
  mbedtls_2,
  symlinkJoin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb";
  version = "candidate_1.0rc1";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_${finalAttrs.version}";
    hash = "sha256-jKAKdja2Q8FldgnRqOdFSnr1XHCC8eC6WeIUv83e7x4=";
  };

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ (with libsForQt5; [
      qmake
      wrapQtAppsHook
    ]);

  buildInputs =
    [

      libusb1
      hidapi
      mbedtls_2
    ]
    ++ (with libsForQt5; [
      qtbase
      qttools
      qtwayland
    ]);

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace-fail /bin/chmod "${coreutils}/bin/chmod"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
  '';

  passthru.withPlugins =
    plugins:
    let
      pluginsDir = symlinkJoin {
        name = "openrgb-plugins";
        paths = plugins;
        # Remove all library version symlinks except one,
        # or they will result in duplicates in the UI.
        # We leave the one pointing to the actual library, usually the most
        # qualified one (eg. libOpenRGBHardwareSyncPlugin.so.1.0.0).
        postBuild = ''
          for f in $out/lib/*; do
            if [ "$(dirname $(readlink "$f"))" == "." ]; then
              rm "$f"
            fi
          done
        '';
      };
    in
    finalAttrs.finalPackage.overrideAttrs (old: {
      qmakeFlags = old.qmakeFlags or [ ] ++ [
        # Welcome to Escape Hell, we have backslashes
        ''DEFINES+=OPENRGB_EXTRA_PLUGIN_DIRECTORY=\\\""${
          lib.escape [ "\\" "\"" " " ] (toString pluginsDir)
        }/lib\\\""''
      ];
    });

  meta = {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    maintainers = with lib.maintainers; [ johnrtitor ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "openrgb";
  };
})