{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  stockfish,
}:

buildGoModule rec {
  pname = "uchess";
  version = "0.2.1";

  subPackages = [ "cmd/uchess" ];

  src = fetchFromGitHub {
    owner = "tmountain";
    repo = "uchess";
    tag = "v${version}";
    sha256 = "1njl3f41gshdpj431zkvpv2b7zmh4m2m5q6xsijb0c0058dk46mz";
  };

  vendorHash = "sha256-4yEE1AsSChayCBxaMXPsbls7xGmFeWRhfOMHyAAReDY=";

  # package does not contain any tests as of v0.2.1
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uchess --suffix PATH : ${stockfish}/bin
  '';

  meta = with lib; {
    description = "Play chess against UCI engines in your terminal";
    mainProgram = "uchess";
    homepage = "https://tmountain.github.io/uchess/";
    maintainers = with maintainers; [ tmountain ];
    license = licenses.mit;
  };
}
