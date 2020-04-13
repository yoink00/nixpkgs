{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, librsvg, libxml2, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, t4kcommon }:

stdenv.mkDerivation rec {
  version = "2.0.3";
  pname = "tuxmath";

  src = fetchFromGitHub {
    owner = "tux4kids";
    repo = "tuxmath";
    rev = "upstream/${version}";
    sha256 = "1f1pz83w6d3mbik2h6xavfxmk5apxlngxbkh80x0m55lhniwkdxv";
  };

  postPatch = ''
    patchShebangs data/scripts/sed-linux.sh
    patchShebangs data/themes/asturian/scripts/sed-linux.sh
    patchShebangs data/themes/greek/scripts/sed-linux.sh
    patchShebangs data/themes/hungarian/scripts/sed-linux.sh

    substituteInPlace Makefile.am \
      --replace "\$(MKDIR_P) -m 2755 " "\$(MKDIR_P) -m 755 " \
      --replace "chown root:games \$(DESTDIR)\$(pkglocalstatedir)/words" " "

    substituteInPlace configure.ac \
      --replace 'CFLAGS="$CFLAGS $SDL_IMAGE"' 'CFLAGS="$CFLAGS $SDL_IMAGE_CFLAGS"' \
      --replace 'PKG_CHECK_MODULES([SDL_ttf],' 'PKG_CHECK_MODULES([SDL_TTF],'
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ librsvg libxml2 SDL SDL_image SDL_mixer SDL_net SDL_ttf t4kcommon ];

  configureFlags = [ "--without-sdlpango" ];

  meta = with stdenv.lib; {
    description = "An educational math tutorial game starring Tux, the Linux Penguin";
    homepage = "https://github.com/tux4kids/tuxmath";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.swallace ];
    platforms = platforms.linux;
  };
}
