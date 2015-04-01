INSTALL_DIR := install/usr/local

.PHONY: toxcore

all: toxcore

stub:
	echo "stub"

toxcore:
	make -C toxcore
	make -C toxcore install

qtox-run:
	build-*/qtox

qtox-debug:
	gdb build-*/qtox

qtox-grant:
	sudo setcap cap_net_admin+ep build-*/qtox

qtox: toxcore
	cd qTox; qmake qtox-static.pro; make -j8

toxcore-configure:
	cd toxcore; ./autogen.sh; mkdir -p $(INSTALL_DIR); ./configure --prefix $(shell pwd)/$(INSTALL_DIR)

toxcore-test:
	cd toxcore/build; $(MAKE) toxvpn_test; sudo setcap cap_net_admin+ep $(shell pwd)/toxcore/build/.libs/toxvpn_test


configure-qtox:
	cd qTox; qmake qtox.pro "LIBS += -L$(PWD)/install/usr/local/lib -Bstatic -ltoxcore" "INCLUDEPATH += $(PWD)/install/usr/local/include" ENABLE_SYSTRAY_UNITY_BACKEND=NO


clean:
	make -C toxcore clean
	
