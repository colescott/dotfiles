with import <nixpkgs> {};

let
  version = "5.0.0-beta.17";

  runtimeDeps = [
    udev libnotify
  ];
  deps = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver libxcb
  ]) ++ [
    gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ] ++ runtimeDeps;

  desktopItem = makeDesktopItem rec {
    name = "Franz";
    exec = name;
    icon = "franz";
    desktopName = name;
    genericName = "Franz messenger";
    categories = "Network;";
  };
in stdenv.mkDerivation rec {
  name = "franz-${version}";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz-${version}.tar.gz";
    sha256 = "1a8ijlm8m57i2vbkb2zx2g0f29xlixr9zgzqin6rrx98vyvw98cf";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "postFixup" ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    cd franz-${version}

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" franz
    patchelf --set-rpath "$out/opt/franz:${stdenv.lib.makeLibraryPath deps}" franz

    mkdir -p $out/bin $out/opt/franz
    cp -r * $out/opt/franz
    ln -s $out/opt/franz/franz $out/bin

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  postFixup = ''
    paxmark m $out/opt/franz/franz
    wrapProgram $out/opt/franz/franz --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = http://meetfranz.com;
    license = licenses.free;
    maintainers = [ maintainers.gnidorah ];
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
