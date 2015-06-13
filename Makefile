BUILD_DIR := /tmp/diplom
INSTALL_DIR := $(BUILD_DIR)/install/usr/local
PWD := $(shell pwd)

.PHONY: toxcore

all: toxcore


toxcore:
	rm -rf install
	mkdir -p install
	make -C toxcore
	make -C toxcore install

build-dir: 
	mkdir -p $(BUILD_DIR)

qtox-run:
	$(BUILD_DIR)/build-*/qtox

qtox-debug:
	gdb $(BUILD_DIR)/build-*/qtox

qtox-grant:
	sudo setcap cap_net_admin+ep $(BUILD_DIR)/build-*/qtox

toxcore-configure:
	mkdir -p $(INSTALL_DIR)
	cd toxcore; ./autogen.sh; mkdir -p $(INSTALL_DIR); ./configure CFLAGS="-g -DDEBUG=1" --prefix $(INSTALL_DIR)

qtox-configure:
	mkdir -p $(BUILD_DIR)/qTox-build
	cd $(BUILD_DIR)/qTox-build && qmake $(PWD)/qTox/qtox.pro "INCLUDEPATH += $(INSTALL_DIR)/include" "LIBS += -L$(INSTALL_DIR)/lib" "STATICPKG=YES" 

qtox:
	cd $(BUILD_DIR)/qTox-build && make -j8
	
clean:
	make -C toxcore distclean
	rm -rf $(BUILD_DIR)/install/*	
