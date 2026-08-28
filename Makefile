.PHONY: docker-china run

build-china:
	docker build \
		--build-arg NIXPKGS_REV=0e251e24a4f24e036a084b6b4b2d2491af4167f4 \
		--build-arg FLAKE_PARTS_REV=427bf4bd9435fdf21321c8cc628c24efc14c0f7a \
		--build-arg NIXPKGS_LIB_REV=0e79af5e3d4dcfcd676ab5ba3f95d2e3352e078c \
		-t nix-env china.Dockerfile

run:
	docker run -it --rm -v nix-store:/nix -v "$(pwd)":/work -w /work nix-env nix develop
