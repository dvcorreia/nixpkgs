{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  qt5,
}:

let
  inherit (qt5)
    qmake
    wrapQtAppsHook
    qtgraphicaleffects
    qtquickcontrols2
    ;
in
stdenv.mkDerivation rec {
  pname = "opensoundmeter";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "psmokotnin";
    repo = "osm";
    tag = "v${version}";
    hash = "sha256-X/edRuYtZsvbs7Bl/JpJJPIGeQDEDH+FTQCX1Zy1osE=";
  };

  patches = [ ./build.patch ];

  postPatch = ''
    substituteInPlace OpenSoundMeter.pro \
      --replace 'APP_GIT_VERSION = ?' 'APP_GIT_VERSION = ${src.rev}'
  '';

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    qtgraphicaleffects
    qtquickcontrols2
  ];

  installPhase = ''
    runHook preInstall

    install OpenSoundMeter -Dt $out/bin
    install OpenSoundMeter.desktop -m444 -Dt $out/share/applications
    install icons/white.png -m444 -D $out/share/icons/OpenSoundMeter.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sound measurement application for tuning audio systems in real-time";
    homepage = "https://opensoundmeter.com/";
    license = licenses.gpl3Plus;
    mainProgram = "OpenSoundMeter";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
