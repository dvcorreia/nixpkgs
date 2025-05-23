{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "typical";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "typical";
    tag = "v${version}";
    hash = "sha256-y7PWTzD9+rkC4wZYhecmDTa3AoWl4Tgh7QXbSK4Qq5Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+SnwxmNQDj6acr2nEKJkNmR5PqnTIvyMApyZOmCld2U=";

  nativeBuildInputs = [
    installShellFiles
  ];

  preCheck = ''
    export NO_COLOR=true
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd typical \
      --bash <($out/bin/typical shell-completion bash) \
      --fish <($out/bin/typical shell-completion fish) \
      --zsh <($out/bin/typical shell-completion zsh)
  '';

  meta = with lib; {
    description = "Data interchange with algebraic data types";
    mainProgram = "typical";
    homepage = "https://github.com/stepchowfun/typical";
    changelog = "https://github.com/stepchowfun/typical/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
