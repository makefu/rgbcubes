{ pkgs ? import <nixpkgs> {} }:
let
  # TODO: from <stockholm>
  nodemcu-uploader = pkgs.python2Packages.buildPythonPackage rec {
      name = "nodemcu-uploader-${version}";
      version = "0.2.2";
      propagatedBuildInputs = with pkgs;[
        python2Packages.pyserial
      ];
      src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/n/nodemcu-uploader/nodemcu-uploader-${version}.tar.gz";
        sha256 = "090giz84y9y3idgifp0yh80qqyv2czv6h3y55wyrlgf7qfbwbrvn";
      };
      doCheck = false;
  };
  esptool = pkgs.python2Packages.buildPythonPackage rec {
      name = "esptool-${version}";
      version = "0.1.0";
      propagatedBuildInputs = with pkgs;[
        python2Packages.pyserial
      ];
      src = pkgs.fetchFromGitHub {
        owner = "themadinventor";
        repo = "esptool";
        rev = "master";
        sha256 = "09gxrk3jky3lx4j4qfsimx8z4irw7ii54c5va2cvx8r5hcs4hav2";
      };
      doCheck = false;
  };

in pkgs.stdenv.mkDerivation rec {
  name = "minikrebs-env";
  version = "1.1";
  buildInputs = with pkgs; [
    wget
    git
    gawk
    bash
    # platformio
    nodemcu-uploader
    esptool
  ];
    shellHook =''
      HISTFILE="$PWD/.histfile"
    '' ;
}
