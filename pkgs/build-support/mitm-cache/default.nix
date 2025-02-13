{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  rustPlatform,
  replaceVars,
  openssl,
  Security,
  python3Packages,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitm-cache";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "chayleaf";
    repo = "mitm-cache";
    rev = "v${version}";
    hash = "sha256-l9dnyA4Zo4jlbiCMRzUqW3NkiploVpmvxz9i896JkXU=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-6554Tf5W+7OFQw8Zm4yBQ2/rHm31MQ0Q+vTbnmZTGMQ=";

  setupHook = replaceVars ./setup-hook.sh {
    inherit openssl;
    ephemeral_port_reserve = python3Packages.ephemeral-port-reserve;
  };

  passthru.fetch = callPackage ./fetch.nix { };

  meta = with lib; {
    description = "A MITM caching proxy for use in nixpkgs";
    homepage = "https://github.com/chayleaf/mitm-cache#readme";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
    mainProgram = "mitm-cache";
  };
}
