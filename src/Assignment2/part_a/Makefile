CXX=g++ -m64
CXXFLAGS=-I. -I../common -I../tests -Iobjs/ -O3 -std=c++11 -Wall

APP_NAME=runtasks
OBJDIR=objs
COMMONDIR=../common

PPM_CXX=$(COMMONDIR)/ppm.cpp
PPM_OBJ=$(addprefix $(OBJDIR)/, $(subst $(COMMONDIR)/,, $(PPM_CXX:.cpp=.o)))

default: $(APP_NAME)

.PHONY: dirs clean

dirs:
	/bin/mkdir -p $(OBJDIR)/

clean:
	/bin/rm -rf $(OBJDIR) *.ppm *~ $(APP_NAME)

OBJS=$(PPM_OBJ) $(OBJDIR)/tasksys.o

$(APP_NAME): clean dirs $(OBJS)
	$(CXX) ../tests/main.cpp $(CXXFLAGS) -o $@ $(OBJDIR)/tasksys.o -lm -lpthread

$(OBJDIR)/%.o: $(COMMONDIR)/%.cpp
	$(CXX) $< $(CXXFLAGS) -c -o $@

$(OBJDIR)/%.o: %.cpp
	$(CXX) $< $(CXXFLAGS) -c -o $@
