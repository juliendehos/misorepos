 
let

  miso-src = fetchTarball {
    url = https://github.com/dmjio/miso/archive/d9ba465e9210d35208c4a2fb82287f0531157425.tar.gz;
    sha256 = "sha256:1056x2f9gc16ss4ldyw0a04f3547vrjhwvpdnk994ig10d21kn2z";
    # should match cabal.project
  };

  servant-miso-client-src = fetchTarball {
    url = https://github.com/haskell-miso/servant-miso-client/archive/6178a50a94c6c8cbb0faaf6c78203ceae272cd3f.tar.gz;
    sha256 = "sha256:17i9m2iz7g3qw54ian9678zyzi110m92c2gp046jv0wif6z1bk9q";
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

