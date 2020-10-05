{ avr ? true }:

let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/903266491b7b9b0379e88709feca0af900def0d9.tar.gz";
    sha256 = "1b5wjrfgyha6s15k1yjyx41hvrpmd5szpkpkxk6l5hyrfqsr8wip";
  };

  pkgs = import nixpkgs { };
in

with pkgs;
let
  avrlibc = pkgsCross.avr.libcCross;

  avr_incflags = [
    "-isystem ${avrlibc}/avr/include"
    "-B${avrlibc}/avr/lib/avr5"
    "-L${avrlibc}/avr/lib/avr5"
    "-B${avrlibc}/avr/lib/avr35"
    "-L${avrlibc}/avr/lib/avr35"
    "-B${avrlibc}/avr/lib/avr51"
    "-L${avrlibc}/avr/lib/avr51"
  ];
in
mkShell {
  name = "qmk-firmware";

  buildInputs = [
    dfu-programmer
    dfu-util
    pkgsCross.avr.buildPackages.binutils
    pkgsCross.avr.buildPackages.gcc8
    avrlibc
    avrdude
  ];

  AVR_CFLAGS = avr_incflags;
  AVR_ASFLAGS = avr_incflags;
  shellHook = ''
    # Prevent the avr-gcc wrapper from picking up host GCC flags
    # like -iframework, which is problematic on Darwin
    unset NIX_TARGET_CFLAGS_COMPILE
  '';
}
