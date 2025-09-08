 
let

  miso-src = fetchTarball {
    url = https://github.com/dmjio/miso/archive/fddd4c95866523cbb97164c6d6193b89aa4c94be.tar.gz;
    sha256 = "sha256:0q0xmdrnh03b89v3jr07b9jsx6a4j6znmj9v92iz1c7a5qm44g66";
    # should match cabal.project
  };

  servant-miso-client-src = fetchTarball {
    url = https://github.com/haskell-miso/servant-miso-client/archive/d973db14834077670d22e3c86cf46646276038e1.tar.gz;
    sha256 = "sha256:14n2gj8r7n42w1fbsbhl084wx750b8zfd7xsdc5jz5n596z5mw6y";
    # should match cabal.project
  };

  servant-src = fetchTarball {
    url = https://github.com/haskell-servant/servant/archive/refs/tags/servant-0.20.3.0.tar.gz;
    sha256 = "sha256:0cx37nrqlylmsi5f75mqs8vlqnsn41qn94k3d9zl4lyczvmm8sfd";
    # should match cabal.project
  };

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: rec {
          miso = self.callCabal2nixWithOptions "miso" miso-src "-ftemplate-haskell" {};
          servant-miso-client = self.callCabal2nix "servant-miso-client" servant-miso-client-src {};
          servant = self.callCabal2nix "servant" "${servant-src}/servant" {};
        };
      };
    };
  };
  
  channel = <nixpkgs>;
  # channel = fetchTarball "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";

  pkgs = import channel { inherit config; };

in pkgs

