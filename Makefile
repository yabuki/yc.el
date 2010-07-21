prefix = /usr/local
#exesuffix = .exe # for Windows

EMACS = emacs
#EMACS = xemacs

elispdir = $(prefix)/share/emacs/site-lisp
#elispdir = $(prefix)/lib/$(EMACS)/site-lisp
#elispdir = $(prefix)/lib/emacs

INSTALL_PATH = $(prefix)/bin
elc = yc.elc
PROGRAM = icanna$(exesuffix)
OBJS = icanna.o
CC = gcc
INSTALL = install

.SUFFIXES: .el .elc

.el.elc:
	$(EMACS) -batch -f batch-byte-compile $<

all: $(PROGRAM) $(elc)

$(PROGRAM): $(OBJS)
	$(CC) -o $(PROGRAM) $(OBJS)

clean:
	@rm $(OBJS) $(PROGRAM) $(elc)

install: install-bin install-el

install-bin: $(PROGRAM)
	$(INSTALL) -m 755 -s $(PROGRAM) $(INSTALL_PATH)/$(PROGRAM)

install-el: $(ELCS) $(SRCS)
	$(INSTALL) -m 755 $(elc) $(elispdir)/$(elc)
	$(INSTALL) -m 755 $(elc:.elc=.el) $(elispdir)/$(elc:.elc=.el)

uninstall: uninstall-bin uninstall-el

uninstall-bin:
	@rm $(INSTALL_PATH)/$(PROGRAM)

uninstall-el:
	@for i in $(elc:.elc=.el) $(elc); do rm $(elispdir)/$$i; done
