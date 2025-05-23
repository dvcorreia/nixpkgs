{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "go-graft";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "mzz2017";
    repo = "gg";
    tag = "v${version}";
    hash = "sha256-DXW0NtFYvcCX4CgMs5/5HPaO9f9eFtw401wmJdCbHPU=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X github.com/mzz2017/gg/cmd.Version=${version}"
    "-s"
    "-w"
  ];

  vendorHash = "sha256-fnM4ycqDyruCdCA1Cr4Ki48xeQiTG4l5dLVuAafEm14=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gg \
    --bash completion/bash/gg \
    --fish completion/fish/gg.fish \
    --zsh completion/zsh/_gg
  '';

  meta = with lib; {
    description = "Command-line tool for one-click proxy in your research and development without installing v2ray or anything else";
    changelog = "https://github.com/mzz2017/gg/releases/tag/${src.rev}";
    homepage = "https://github.com/mzz2017/gg";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      xyenon
      oluceps
    ];
    mainProgram = "gg";
    platforms = platforms.linux;
  };
}
