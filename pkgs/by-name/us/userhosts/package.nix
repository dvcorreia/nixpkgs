{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "userhosts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "figiel";
    repo = "hosts";
    tag = "v${version}";
    hash = "sha256-9uF0fYl4Zz/Ia2UKx7CBi8ZU8jfWoBfy2QSgTSwXo5A";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Libc wrapper providing per-user hosts file";
    homepage = "https://github.com/figiel/hosts";
    maintainers = [ maintainers.bobvanderlinden ];
    license = licenses.cc0;
    platforms = platforms.linux;
  };
}
