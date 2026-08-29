.PHONY: docker-china run

build-china:
	docker build \
		-t nix-env -f china.Dockerfile .

run:
	docker run -it --rm -v nix-store:/nix -v "$(pwd)":/work -w /work nix-env nix develop
