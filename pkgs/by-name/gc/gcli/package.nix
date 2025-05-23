{
  lib,
  fetchFromGitHub,
  stdenv,
  curl,
  pkg-config,
  byacc,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "gcli";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    tag = "v${version}";
    hash = "sha256-N5dzGhyXPDWcm/cNUSUQt4rR+PzaD1OUssRO3Sdfmoo=";
  };

  nativeBuildInputs = [
    pkg-config
    byacc
    flex
  ];
  buildInputs = [ curl ];

  meta = with lib; {
    description = "Portable Git(Hub|Lab|ea) CLI tool";
    homepage = "https://herrhotzenplotz.de/gcli/";
    changelog = "https://github.com/herrhotzenplotz/gcli/releases/tag/${version}";
    license = licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with maintainers; [ kenran ];
    platforms = platforms.unix;
  };
}
