ifeq ($(OS),Windows_NT)
    LIST_FILES = dir /b
    MOVE = move /y
    DEL_FILE = del /q /f
    DEL_DIR = rmdir /q /s
    CAT = type
    PWD = $(shell cd)
    CP=copy /y
    CPDIR=xcopy /e /y
    CHMOD=attrib
    Q=
    S=\\
else
    LIST_FILES = ls
    MOVE =  mv
    DEL_FILE = rm
    DEL_DIR = rm -rf
    CAT = cat
    CP=cp
    CPDIR=cp -R
    CHMOD=chmod
    Q='
    S=/
endif

.PHONY: all clean distclean
.PHONY: install uninstall
.PHONY: material material-clean
.PHONY: qds qds-dark qds-light qds-clean

all: material qds

clean: material-clean qds-clean

material:
	python mk-material.py

material-clean:
	-$(DEL_FILE) material-*.qss material-*.qrc material-*.rcc
	-$(DEL_DIR) material-dark material-light

qds: qds-dark qds-light

qds-dark:
	sed -e 's;url(".*/rc;url(":/ostinato.org/themes/qds-dark/rc;' \
	    qds$(S)dark$(S)style.qss > qds-dark.qss
	$(CAT) qds$(S)version.txt >> qds-dark.qss
	-mkdir qds-dark
	$(CPDIR) qds$(S)dark qds-dark$(S)
	sed -e 's;prefix=".*";prefix="ostinato.org/themes";' \
	    -e 's;rc/;qds-dark/rc/;' \
	    -e 's;style.qss;;' \
	    qds$(S)dark$(S)style.qrc > qds-dark.qrc
	rcc --binary -o qds-dark.rcc qds-dark.qrc

qds-light:
	sed -e 's;url(".*/rc;url(":/ostinato.org/themes/qds-light/rc;' \
	    qds$(S)light$(S)style.qss > qds-light.qss
	$(CAT) qds$(S)version.txt >> qds-light.qss
	-mkdir qds-light
	$(CPDIR) qds$(S)light qds-light$(S)
	sed -e 's;prefix=".*";prefix="ostinato.org/themes";' \
	    -e 's;rc/;qds-light/rc/;' \
	    -e 's;style.qss;;' \
	    qds$(S)light$(S)style.qrc > qds-light.qrc
	rcc --binary -o qds-light.rcc qds-light.qrc

qds-clean:
	-$(DEL_FILE) qds-*.qss qds-*.qrc qds-*.rcc
	-$(DEL_DIR) qds-dark qds-light

install: all
	-mkdir themes
	$(CP) material-*.qss themes
	$(CP) material-*.rcc themes
	$(CP) qds-*.qss themes
	$(CP) qds-*.rcc themes
	dos2unix themes/*.qss

uninstall:
	-$(DEL_DIR) themes

distclean: uninstall clean

