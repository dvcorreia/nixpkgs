{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  pulseaudio,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cplay-ng";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "xi";
    repo = "cplay-ng";
    tag = version;
    hash = "sha256-6mphhoLDkGZ2r+elzLlPl3B8fNz3loqrQB8x8276AHI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  build-system = [
    python3.pkgs.setuptools
  ];

  pyproject = true;

  postInstall = ''
    wrapProgram $out/bin/cplay-ng \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          pulseaudio
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/xi/cplay-ng";
    description = "Simple curses audio player";
    mainProgram = "cplay-ng";
    longDescription = ''
      cplay is a minimalist music player with a textual user interface written
      in Python. It aims to provide a power-user-friendly interface with simple
      filelist and playlist control.

      Instead of building an elaborate database of your music library, cplay
      allows you to quickly browse the filesystem and enqueue files,
      directories, and playlists.

      The original cplay was started by Ulf Betlehem in 1998 and is no longer
      maintained. This is a rewrite that aims to stay true to the original
      design while evolving with a shifting environment.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
  };
}
