# meta
NAME 		:= gobot_leap
MAIN 		:= main.go
GO_VERSION	:= 1.12.3

VERSION 	:= v1.0.0
REVISINO 	:= 000001
LDFLAGS 	:= -X 'main.version=$(VERSION)' -X 'main.revision=$(REVISON)'
GOMOD 		:= go.mod
GOMODEXISTS	:= $(shell ls | grep $(GOMOD))
SRCS 		:= $(shell find . -type f -name '*.go')
TARGETS 	:= api assets build cmd configs deployments docs examples githooks init internal pkg scripts test third_party tools vendor web website

## env
export GO111MODULE=on

## setup
setup:
	@for target in $(TARGETS); do \
		if [ ! -d ./$$target ]; then \
			if [ "$$target" = "build" ]; then \
				mkdir -p ./$$target/ci; \
				mkdir -p ./$$target/package; \
			elif [ "$$target" = "internal" ]; then \
				mkdir -p ./$$target/app; \
				mkdir -p ./$$target/pkg; \
			elif [ "$$target" = "web" ]; then \
				mkdir -p ./$$target/app; \
				mkdir -p ./$$target/static; \
				mkdir -p ./$$target/template; \
			else \
				mkdir -p ./$$target; \
			fi \
		fi \
	done

.PHONY: install-gvm
install-gvm:
ifeq ($(shell command -v gvm 2> /dev/null),)
	@bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
else
	@echo "[INFO] gvm(Go Version Manager) already installed."
endif

.PHONY: setup-gvm
setup-gvm:
	@if [ `gvm list | grep "go${GO_VERSION}" | wc -l` -eq "0" ]; then \
		gvm install "go${GO_VERSION}"; \
	else \
		echo "[INFO] go${GO_VERSION} already installed."; \
	fi

	@if [ `gvm pkgset list | grep ${NAME} | wc -l` -eq "0" ]; then \
		gvm pkgset create ${NAME} --local; \
	else \
		echo "[INFO] ${NAME} already created."; \
	fi

.PHONY: switch-gvm
switch-gvm:
	@gvm use go${GO_VERSION} --default; \
	@gvm pkgset use ${NAME} --local;