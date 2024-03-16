{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch2
, avahi
, boost
, cmake
, cudaPackages
, eigen
, ffmpeg
, freetype
, git
, glm
, glslang
, harfbuzz
, libdrm
, libva
, libpulseaudio
, libX11
, libXrandr
, monado
, nlohmann_json
, onnxruntime
, openxr-loader
, pkg-config
, python3
, shaderc
, spdlog
, systemd
, udev
, vulkan-headers
, vulkan-loader
, vulkan-tools
, x264
}:
let
  vendorMonado = monado.overrideAttrs rec {
    # Version stated in CMakeList for WiVRn 0.12
    version = "ffb71af26f8349952f5f820c268ee4774613e200";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = version;
      hash = "sha256-+RTHS9ShicuzhiAVAXf38V6k4SVr+Bc2xUjpRWZoB0c=";
    };

    # FIXME: Never used? Since we only eval .src
    patches = [
      # WiVRn-specific patch
      (fetchpatch2 {
        name = "0001-c-multi-disable-dropping-of-old-frames.patch";
        url = "https://raw.githubusercontent.com/Meumeu/WiVRn/46d6d2181b62ecb976616a3b2396b9bd0ce345b4/patches/monado/0001-c-multi-disable-dropping-of-old-frames.patch";
        hash = "sha256-s/000000000/woCEOEZECdcZoJDoWc1eM63sd60cxeY=";
      })
    ];

    postInstall = ''
      mv src/xrt/compositor/libcomp_main.a $out/lib/libcomp_main.a
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "wivrn";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "meumeu";
    repo = "wivrn";
    rev = "v${version}";
    hash = "sha256-O6Eq7EQ427hOcN16Z33I74CevnHlX/a4ZAcljgc+vk8=";
  };

  prePatch = ''
    substituteInPlace ./server/CMakeLists.txt \
      --replace "../../../" "../../../../../.."
  '';

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
    git
    pkg-config
    python3
  ];

  buildInputs = [
    avahi
    boost
    cudaPackages.cuda_cudart
    eigen
    ffmpeg
    freetype
    glm
    glslang
    harfbuzz
    libdrm
    libva
    libX11
    libXrandr
    libpulseaudio
    nlohmann_json
    onnxruntime
    openxr-loader
    shaderc
    spdlog
    systemd
    udev
    vulkan-headers
    vulkan-loader
    vulkan-tools
    x264
  ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_NVENC" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${vendorMonado.src}")
  ];

  meta = with lib; {
    description = "An OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/Meumeu/WiVRn/";
    changelog = "https://github.com/Meumeu/WiVRn/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ passivelemon ];
    platforms = platforms.linux;
    mainProgram = "wivrn-server";
  };
}
