TARGET_NAME = my-project
PROJ_ROOT = $(shell echo $$HOME)/projects/$(TARGET_NAME)
INCLUDE_DIR = $(PROJ_ROOT)/include
SRC_DIR = $(PROJ_ROOT)/src
BUILD_DIR = $(PROJ_ROOT)/build

CC = clang
CFLAGS = -I$(INCLUDE_DIR)

build:
	mkdir -p $(BUILD_DIR)
	$(CC) -o $(BUILD_DIR)/$(TARGET_NAME) $(SRC_DIR)/*.c $(CFLAGS)

.PHONY: run clean

run:
	$(BUILD_DIR)/$(TARGET_NAME)

clean:
	rm -rf $(BUILD_DIR)
