
TARGET_LIBDEX := ./out/obj/STATIC_LIBRARIES/libdex.a
TARGET_LIBLOG := ./out/obj/STATIC_LIBRARIES/liblog.a
TARGET_DEXDUMP:= ./out/obj/EXECUTABLES/dexdump

TARGET  := $(TARGET_LIBDEX) $(TARGET_LIBLOG) $(TARGET_DEXDUMP)

AR      = ar
RANLIB  = ranlib
LIBS    := -lpthread -lz 
LDFLAGS:= 
DEFINES:=
INCLUDE:=  -I./include/ -I. -I./include/safe-iop/ -I./include/nativehelper

CFLAGS  := -fno-exceptions -Wno-multichar -fPIC -m32 -D_FORTIFY_SOURCE=0 -DANDROID -fmessage-length=0 -W -Wall -Wno-unused -Winit-self -Wpointer-arith -g -fno-strict-aliasing  -DANDROID -fmessage-length=0     -W -Wall -Wno-unused -Winit-self -Wpointer-arith  -DNDEBUG -UDEBUG  -include include/arch/AndroidConfig.h -DDUMP_TRACE=0 $(INCLUDE)

CXXFLAGS:= $(CFLAGS) -DHAVE_CONFIG_H

#source file
# 源文件，自动找所有 .c 和 .cpp 文件，并将目标定义为同名 .o 文件

LOG_SOURCE  := $(wildcard ./liblog/*.c) 
OBJS_LOG    := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(LOG_SOURCE)))

DEX_SOURCE  := $(wildcard ./libdex/*.cpp) 
OBJS_DEX    := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(DEX_SOURCE)))

DEXDUMP_SOURCE  := $(wildcard ./src/*.cpp) 
OBJS_DEXDUMP    := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(DEXDUMP_SOURCE)))


.PHONY : clean 

all : $(TARGET)

clean : 
	rm -fr $(TARGET)
	rm -fr $(TARGET_DEXDUMP)
	rm -fr $(OBJS_LOG)
	rm -fr $(OBJS_DEX)
	rm -fr $(OBJS_DEXDUMP)

$(TARGET_LIBDEX) : $(OBJS_DEX) 
	$(AR) cru $(TARGET_LIBDEX) $(OBJS_DEX)
	$(RANLIB) $(TARGET_LIBDEX)

$(TARGET_LIBLOG) : $(OBJS_LOG)
	$(AR) cru $(TARGET_LIBLOG) $(OBJS_LOG)
	$(RANLIB) $(TARGET_LIBLOG)

$(TARGET_DEXDUMP) : $(OBJS_DEXDUMP) 
	g++ -o $(TARGET_DEXDUMP) $(OBJS_DEXDUMP)  $(TARGET_LIBDEX) $(TARGET_LIBLOG) $(LIBS) -m32 
