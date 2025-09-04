 
let

  miso-src = fetchTarball {
    url = https://github.com/dmjio/miso/archive/d45d0e9a5a17d40f44f78e18784d6eb38e8785d3.tar.gz;
    sha256 = "sha256:0pnxs00d65z49jl9gv7sfps6q7hlagx7w2408v9cdi1d0xw3py4n";
    # should match cabal.project
  };

  servant-miso-router-src = fetchTarball {
    url = https://github.com/haskell-miso/servant-miso-router/archive/0c828e0ba30ee7a446ce8999288b32b7f6425dd1.tar.gz;
    sha256 = "sha256:01n0nhcmk0hqhcnmabis00w3gimczkm3ps046ib32d52pmwj2nfr";
    # should match cabal.project
  };

  servant-miso-html-src = fetchTarball {
    url = https://github.com/haskell-miso/servant-miso-html/archive/00781d1920795b67e0476b67ed6840c388f29810.tar.gz;
    sha256 = "sha256:0w3i7wk05n9zk0hxl3l0076zsx2nq64vdfg467phbyfh4v0yb0vm";
    # should match cabal.project
  };

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: rec {
          miso = self.callCabal2nixWithOptions "miso" miso-src "-ftemplate-haskell" {};
          servant-miso-router = self.callCabal2nix "servant-miso-router" servant-miso-router-src {};
          servant-miso-html = self.callCabal2nix "servant-miso-html" servant-miso-html-src {};
        };
      };
    };
  };
  
  channel = <nixpkgs>;
  # channel = fetchTarball "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";

  pkgs = import channel { inherit config; };

in pkgs

