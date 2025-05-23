{
  blas,
  fetchFromGitHub,
  gfortran,
  lapack,
  lib,
  llvmPackages,
  meson,
  metis,
  ninja,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "spral";
  version = "2025.01.08";

  src = fetchFromGitHub {
    owner = "ralna";
    repo = "spral";
    tag = "v${version}";
    hash = "sha256-tuhJClSjah/ud6PVr6biOq5KdKtspJ7hpWZ350yzz+U=";
  };

  postPatch =
    ''
      # Skipped test: ssidst
      # hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
      substituteInPlace tests/meson.build --replace-fail \
        "subdir('ssids')" \
        ""
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Skipped test: lsmrt, segfault
      substituteInPlace tests/meson.build --replace-fail \
        "['lsmrt', files('lsmr.f90')]," \
        ""
    '';

  nativeBuildInputs = [
    gfortran
    meson
    ninja
  ];

  buildInputs = [
    blas
    lapack
    metis
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  mesonFlags = [ (lib.mesonBool "tests" true) ];

  LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [ "-lomp" ];

  doCheck = true;

  meta = {
    description = "Sparse Parallel Robust Algorithms Library";
    homepage = "https://github.com/ralna/spral";
    changelog = "https://github.com/ralna/spral/blob/${src.rev}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
