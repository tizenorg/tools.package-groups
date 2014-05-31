# ex: set tabstop=4 noexpandtab: 
VERSION = $(shell cat VERSION)
NAME=package-groups
TAGVER = $(shell cat VERSION | sed -e "s/\([0-9\.]*\).*/\1/")
DESTDIR=
ARCH=i586

ifeq ($(VERSION), $(TAGVER))
        TAG = $(TAGVER)
else
        TAG = "HEAD"
endif

all: 
	python scripts/merge-patterns.py -a ${ARCH}
	xsltproc xsl/comps.xsl patterns.xml > group.xml

meta: 
	python scripts/merge-patterns.py -a ${ARCH} -s

install:
	install -d ${DESTDIR}/usr/share/package-groups
	install -m 644 patterns.xml ${DESTDIR}/usr/share/package-groups
	install -m 644 group.xml ${DESTDIR}/usr/share/package-groups

tag:
	git tag -a $(VERSION) -m "$(VERSION)"
	git push --tags

changelog:
	python ./scripts/gitlog2changelog.py

repackage: dist
	osc branch -c Tizen:Base $(NAME)
	rm home\:*\:branches\:Tizen:Base/$(NAME)/*tar.bz2
	cp $(NAME)-$(VERSION).tar.bz2 home\:*\:branches\:Tizen:Base/$(NAME)

	

dist-bz2:
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ $(TAG) | \
		bzip2  > $(NAME)-$(VERSION).tar.bz2

dist-gz:
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ $(TAG) | \
		gzip  > $(NAME)-$(VERSION).tar.gz

dist: dist-bz2

clean:
	rm -rf patterns.xml INDEX.xml group.xml *.xml
