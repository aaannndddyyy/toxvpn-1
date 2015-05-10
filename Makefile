INSTALL_DIR := install/usr/local

.PHONY: toxcore

all: toxcore

stub:
	echo "stub"

toxcore:
	rm -rf install
	mkdir -p install
	make -C toxcore
	make -C toxcore install

qtox-run:
	build-*/qtox

qtox-debug:
	gdb build-*/qtox

qtox-grant:
	sudo setcap cap_net_admin+ep build*/qtox

toxcore-configure:
	cd toxcore; ./autogen.sh; mkdir -p $(INSTALL_DIR); ./configure CFLAGS="-g -DDEBUG" --prefix $(shell pwd)/$(INSTALL_DIR)

qtox-configure:
	mkdir -p qTox-build
	cd qTox-build && qmake ../qTox/qtox.pro "INCLUDEPATH += $(PWD)/install/usr/local/include" "LIBS += -L$(PWD)/install/usr/local/lib" "STATICPKG=YES" 

qtox:
	cd qTox-build && make -j8
	
clean:
	make -C toxcore distclean
	rm -rf isntall/*	
