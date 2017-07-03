# Thanks to http://vivekvidyasagaran.weebly.com/moose/compiling-cuda-code-along-with-other-c-code
CUDA_INSTALL_PATH := /opt/cuda

CXX := g++
CC := gcc
LINK := g++ -fPIC
NVCC  := nvcc

# Includes
INCLUDES = -I. -I$(CUDA_INSTALL_PATH)/include

# Common flags
COMMONFLAGS += $(INCLUDES) -std=c++11 -lcurl -lm -lstdc++
NVCCFLAGS += $(COMMONFLAGS) -gencode arch=compute_52,code=sm_52
CXXFLAGS += $(COMMONFLAGS)
CFLAGS += $(COMMONFLAGS)

LIB_CUDA := -L$(CUDA_INSTALL_PATH)/lib64 -lcudart $(COMMONFLAGS)
OBJS = gpu-cuda-miner.cu.o gpu-miner.cpp.o network.cpp.o
TARGET = gpu-miner
LINKLINE = $(LINK) -o $(TARGET) $(OBJS) $(LIB_CUDA)

.SUFFIXES: .c .cpp .cu .o

%.c.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.cu.o: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OBJS) Makefile
	$(LINKLINE)
