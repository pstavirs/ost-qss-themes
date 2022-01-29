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

.PHONY: all clean
.PHONY: material material-clean
.PHONY: qds qds-dark qds-clean

all: material qds

clean: material-clean qds-clean

material:
	python mk-material.py

material-clean:
	-$(DEL_FILE) material-*.qss material-*.qrc material-*.rcc
	-$(DEL_DIR) material-dark material-light

qds: qds-dark

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

qds-clean:
	-$(DEL_FILE) qds-*.qss qds-*.qrc qds-*.rcc
	-$(DEL_DIR) qds-dark qds-light
