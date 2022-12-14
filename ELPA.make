# For compiling in elpa

.PHONY : all force

all : byte-compile autoloads

ifeq ($(shell uname),Linux)
EMACS_EXE ?= emacs
WISI ?= /Projects/org.emacs.wisi

else ifeq ($(shell uname),Darwin)
EMACS_EXE ?= "/Applications/Emacs.app/Contents/MacOS/Emacs"
WISI ?= /Projects/org.emacs.wisi

else
# windows
# specify uniscribe to workaround weird Windows harfbuzz bug
EMACS_EXE ?= emacs -xrm Emacs.fontBackend:uniscribe
WISI ?= c:/Projects/elpa/packages/wisi

endif

BYTE_COMPILE := "(progn (setq byte-compile-error-on-warn t)(batch-byte-compile))"
byte-compile : byte-compile-clean
	$(MAKE) -C $(WISI)/build byte-compile autoloads
	$(EMACS_EXE) -Q -batch -L . -L $(WISI) --eval $(BYTE_COMPILE) *.el

byte-compile-clean :
	rm -f *.elc

autoloads : force
	$(EMACS_EXE) -Q -batch --eval "(progn (setq generated-autoload-file (expand-file-name \"autoloads.el\"))(update-directory-autoloads \".\"))"

# builds $(ELPA_ROOT)/archive-devel/*, from the last commit, _not_ the
# current workspace Also checks copyright; run elpa/GNUMakefile
# check/<pkg> first if added files.
build-elpa : force
	rm -rf $(ELPA_ROOT)/archive-devel
	make -C $(ELPA_ROOT)/ build/gnat-compiler

# end of file
