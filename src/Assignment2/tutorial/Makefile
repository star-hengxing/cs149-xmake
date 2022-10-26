CXX=g++ -m64
CXXFLAGS=-O3 -std=c++11 -Wall

APP_NAME=tutorial

default: $(APP_NAME)

.PHONY: dirs clean

clean:
	/bin/rm -rf $(APP_NAME)

$(APP_NAME): clean
	$(CXX) $(CXXFLAGS) -o $@ $@.cpp -lpthread
