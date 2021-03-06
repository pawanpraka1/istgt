# top Makefile

top_srcdir = .
srcdir   = .

prefix   = /usr/local
exec_prefix = ${prefix}
bindir   = ${exec_prefix}/bin
sbindir  = ${exec_prefix}/sbin
sysconfdir = ${prefix}/etc
datarootdir = ${prefix}/share
datadir  = ${datarootdir}
libexecdir = ${exec_prefix}/libexec
mandir   = ${datarootdir}/man

PACKAGE_NAME = istgt
PACKAGE_STRING = istgt 0.5
PACKAGE_TARNAME = istgt
PACKAGE_VERSION = 0.5

document = COPYRIGHT README INSTALL ChangeLog.jp

VER_H = src/istgt_ver.h
DISTBASE = istgt
DISTVER  = `sed -e '/ISTGT_VERSION/!d' -e 's/[^0-9.]*\([0-9.a-z]*\).*/\1/' $(VER_H)`
DISTEXTVER = `sed -e '/ISTGT_EXTRA_VERSION/!d' -e 's/[^0-9.]*\([0-9.a-z]*\).*/\1/' $(VER_H)`
#DISTDIR  = $(PACKAGE_NAME)-$(PACKAGE_VERSION)
#DISTDIR  = $(DISTBASE)-$(DISTVER)-$(DISTEXTVER)
DISTDIR  = $(DISTBASE)-$(DISTEXTVER)
DISTNAME = $(DISTDIR).tar.gz
DISTFILES = Makefile.in configure.in config.guess config.sub install-sh configure \
	$(header) $(source) $(ctl_header) $(ctl_source) \
	$(document) $(sample)

SUBDIRS = src etc doc

#########################################################################

.PHONY: all install install-doc
all:
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done

install:
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done

install-doc:
	for subdir in doc; do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done


.PHONY: dist clean distclean local-clean local-distclean depend
dist: distdir
	rm -rf $(DISTDIR) $(DISTNAME)
	mkdir $(DISTDIR)
	for file in $(DISTFILES); do \
	  cp -p $(srcdir)/$$file $(DISTDIR); \
	done
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) subdir=$$subdir $@) || exit $$?; \
	done
	tar cf - $(DISTDIR) | gzip -9c > $(DISTNAME)
	rm -rf $(DISTDIR) distdir

distdir:
	echo $(DISTDIR) >$@

clean: local-clean
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done

distclean: clean local-distclean
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done

local-clean:
	-rm -f a.out *.o *.core
	-rm -f *~

local-distclean: local-clean
	-rm -f Makefile config.status config.cache config.log config.h
	-rm -f $(DISTNAME) distdir

depend:
	for subdir in $(SUBDIRS); do \
          (cd $$subdir; $(MAKE) $@) || exit $$?; \
	done

#########################################################################
