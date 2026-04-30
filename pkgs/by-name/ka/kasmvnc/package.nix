{
  cmake,
  expat,
  fetchFromGitHub,
  ffmpeg-headless,
  gnutls,
  lib,
  libcpuid,
  libdrm,
  libidn2,
  libjpeg_turbo,
  libjpeg_turbo' ? libjpeg_turbo.override { enableStatic = true; },
  libtasn1,
  libwebp,
  libX11,
  libxcrypt,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXft,
  libXi,
  libXinerama,
  libXrandr,
  libXtst,
  makeWrapper,
  mesa,
  ninja,
  onetbb,
  openssl,
  p11-kit,
  pam,
  perl,
  perlPackages,
  pixman,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "kasmvnc";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "kasmtech";
    repo = "KasmVNC";
    rev = "v${version}";
    sha256 = "sha256-wGyYq9Hl2KoMAl18T79Vz+kB81YwTYmuNplQrE0ZX0w=";
  };

  patchPhase = ''
    substituteInPlace CMakeLists.txt --replace-fail "cmake_policy(SET CMP0022 OLD)" ""
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
  ];

  buildInputs = [
    expat
    ffmpeg-headless
    gnutls
    libcpuid
    libdrm
    libidn2
    libjpeg_turbo'
    libtasn1
    libwebp
    libwebp
    libX11
    libxcrypt
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXft
    libXi
    libXinerama
    libXrandr
    libXtst
    mesa
    onetbb
    openssl
    p11-kit
    pam
    perl
    pixman
    zlib
  ];

  propagatedBuildInputs = with perlPackages; [
    BHooksEndOfScope
    ClassDataInheritable
    ClassInspector
    ClassSingleton
    DateTime
    DateTimeLocale
    DateTimeTimeZone
    DevelStackTrace
    EvalClosure
    ExceptionClass
    ExporterTiny
    FileShareDir
    FileWhich
    HashMerge
    ListMoreUtils
    ModuleImplementation
    ModuleRuntime
    MROCompat
    NamespaceAutoclean
    NamespaceClean
    PackageStash
    ParamsValidationCompiler
    RoleTiny
    Specio
    SubExporterProgressive
    SubIdentify
    Switch
    TryTiny
    VariableMagic
    YAML
  ];

  cmakeFlags = [
    "-DBUILD_VIEWER=ON"
    "-DINSTALL_SYSTEMD_UNITS=OFF"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_CXX_FLAGS=-Wno-error=format-security"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  postInstall = ''
    ls -lR
    for i in $out/bin/*; do
      wrapProgram $i \
      --set PERL5LIB "${perlPackages.makePerlPath propagatedBuildInputs}"
    done
  '';

  meta = with lib; {
    description = "Modern VNC server with web-based rendering and high-performance streaming";
    homepage = "https://github.com/kasmtech/KasmVNC";
    license = licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = platforms.linux;
    mainProgram = "vncserver";
  };
}
