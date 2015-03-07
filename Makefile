INSTALL_DIR := install/usr/local

.PHONY: toxcore

all: toxcore

toxcore:
	make -C toxcore
	make -C toxcore install

run-qtox:
	LD_LIBRARY_PATH=$(INSTALL_DIR)/lib/ build-*/qtox

grant-qtox:
	sudo setcap cap_net_admin+ep build-*/qtox

qtox: toxcore
	cd qTox; qmake qtox-static.pro; make -j8

configure-toxcore:
	cd toxcore; ./autogen.sh; mkdir -p $(INSTALL_DIR); ./configure --prefix $(shell pwd)/$(INSTALL_DIR)

configure-qtox:
	cd qTox; qmake qtox.pro "LIBS += -L$(PWD)/install/usr/local/lib -Bstatic -ltoxcore" "INCLUDEPATH += $(PWD)/install/usr/local/include" ENABLE_SYSTRAY_UNITY_BACKEND=NO


clean:
	make -C toxcore clean
	
