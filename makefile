# ======================================== #

# Directory for DOXYGEN
DOXYGEN=/Applications/Doxygen.app/Contents/Resources/doxygen

# Compiler and options
CC	= gcc
OPT	= -Wall -O3 -g -DSYMTRX_VERSION=\"1.0\" -DSYMTRX_BUILD=\"`svnversion -n .`\"

# ======================================== #

SYMTRXDIR = .
SYMTRXLIB = $(SYMTRXDIR)/lib/c
SYMTRXINC = $(SYMTRXDIR)/include/c
SYMTRXBIN = $(SYMTRXDIR)/bin/c
SYMTRXLIBN= symtrx
SYMTRXSRC = $(SYMTRXDIR)/src/c
SYMTRXOBJ = $(SYMTRXSRC)

# ======================================== #

vpath %.c $(SYMTRXSRC)
vpath %.h $(SYMTRXSRC)

LDFLAGS = -L$(SYMTRXLIB) -l$(SYMTRXLIBN)

FFLAGS  = -I$(SYMTRXINC)

SYMTRXOBJS= $(SYMTRXOBJ)/centrosym.o	\
	  $(SYMTRXOBJ)/miscmath.o	\
	  $(SYMTRXOBJ)/square.o

$(SYMTRXOBJ)/%.o: %.c
	$(CC) $(OPT) $(FFLAGS) -c $< -o $@

# ======================================== #

.PHONY: default
default: lib about tidy

.PHONY: all
all: lib doc test about tidy

.PHONY: lib
lib: $(SYMTRXLIB)/lib$(SYMTRXLIBN).a
$(SYMTRXLIB)/lib$(SYMTRXLIBN).a: $(SYMTRXOBJS)
	ar -r $(SYMTRXLIB)/lib$(SYMTRXLIBN).a $(SYMTRXOBJS)

.PHONY: test
test: $(SYMTRXBIN)/symtrx_test
$(SYMTRXBIN)/symtrx_test: $(SYMTRXOBJ)/symtrx_test.o $(SYMTRXLIB)/lib$(SYMTRXLIBN).a
	$(CC) $(OPT) $< -o $(SYMTRXBIN)/symtrx_test $(LDFLAGS)
	$(SYMTRXBIN)/symtrx_test

.PHONY: about
about: $(SYMTRXBIN)/about
$(SYMTRXBIN)/about: $(SYMTRXOBJ)/about.o 
	$(CC) $(OPT) $< -o $(SYMTRXBIN)/about
	$(SYMTRXBIN)/about

.PHONY: doc
doc:
	$(DOXYGEN) $(SYMTRXDIR)/src/doxygen.config
.PHONY: cleandoc
cleandoc:
	rm -rf $(SYMTRXDIR)/doc/html/*

.PHONY: clean
clean:	tidy cleandoc
	rm -f $(SYMTRXLIB)/lib$(SYMTRXLIBN).a
	rm -f $(SYMTRXBIN)/symtrx_test
	rm -f $(SYMTRXBIN)/about

.PHONY: tidy
tidy:
	rm -f $(SYMTRXOBJ)/*.o
	rm -f $(SYMTRXOBJMEX)/*.o
	rm -f *~ 

# ======================================== #