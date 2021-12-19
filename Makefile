ifeq ($(OS),Windows_NT)
    LIST_FILES = dir /b
    MOVE = move /y
    DEL_FILE = del /q /f
    DEL_DIR = rmdir /q /s
    CAT = type
    PWD = $(shell cd)
    CP=copy
    CHMOD=attrib
    Q=
else
    LIST_FILES = ls
    MOVE =  mv
    DEL_FILE = rm
    DEL_DIR = rm -rf
    CAT = cat
    CP=cp
    CHMOD=chmod
    Q='
endif

.PHONY: all material material-clean clean

all: material

material:
	python mk-material.py
	$(DEL_FILE) material-*.qrc
	$(DEL_DIR) icons

material-clean:
	$(DEL_FILE) material-*.qss material-*.rcc

clean: material-clean
