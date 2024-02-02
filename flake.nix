{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = (import nixpkgs) {
          inherit system;
        };
      pypkgs = pkgs.python311.pkgs;

      tw = pypkgs.buildPythonPackage {
        pname = "TracyWidom";
        version = "0.3.0";
        src = pypkgs.fetchPypi {
          pname = "TracyWidom";
          version = "0.3.0";
          sha256 = "1425fe9ad5764280ada7825037f30b5928f71a13265e32cea6c0d7c27cbc0a10";
        };

        propagatedBuildInputs = with pypkgs; [
          numpy scipy
        ];
      };
      
      clumppling = pypkgs.buildPythonPackage {
        format = "pyproject";
        pname = "clumppling";
        version = "0.1.0";
        src = ./.;

        propagatedBuildInputs = with pypkgs; [ 
          setuptools 
          poetry-core 
          numpy 
          scipy
          pandas
          matplotlib
          networkx
          python-louvain
          tw
          
          cvxpy
          pkgs.lapack
          pkgs.blas
          pkgs.gcc-unwrapped
          pkgs.glpk
        ];
      };
    in 
    rec {
      packages.default = clumppling;
    }
  );
}
