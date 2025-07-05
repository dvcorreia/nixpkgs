{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  git,
  ruby,
  bundlerEnv,
  python3,
  nodejs,

  # ruby packages
  licensee,
  github-linguist,
  asciidoctor,
}:

let
  rubyEnv = bundlerEnv {
    name = "ruby-repolinter-env";
    gemdir = ./.;

    ruby = ruby.withPackages (ps: with ps; [
      commonmarker
      rdoc
    ]);

    gemConfig = pkgs: {
      github-markup = {};
      wikicloth = {};
      creole = {};
      org-ruby = {};
      RedCloth = {};
    };
  };

  pythonEnv = python3.withPackages (ps: with ps; [
    docutils
  ]);
in
buildNpmPackage (finalAttrs: {
  pname = "repolinter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "todogroup";
    repo = "repolinter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3wKoUYqTyFYuwDnXAD3X/QlV5Yw1F1F7m60sAgUNdag=";
  };

  npmDepsHash = "sha256-KQr8Aq/jckqJLXZomW7FZbWRtSy4AW04LbRa+oLAjao=";

  buildInputs = [
    git

    gems

    licensee
    github-linguist
    asciidoctor

    pythonEnv
  ];
  nativeBuildInputs = [
    nodejs
  ];

  meta = {
    description = "Lint open source repositories for common issues";
    mainProgram = "repolinter";
    homepage = "https://github.com/todogroup/repolinter";
    changelog = "https://github.com/todogroup/repolinter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
})
