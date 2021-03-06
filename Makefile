CC ?= gcc
CXX ?= g++

CXXFLAGS = -Wall -std=c++11

UTILDIR = data

INCDIR = $(UTILDIR)
LIBDIR = $(UTILDIR)

BINARIES = cache_kde_score cv_scan fcv_scan akde_scan kde_scan

all : $(BINARIES)

kde_scan : kde_scan.cc gauss_legendre.o Kde2d.o ProdKde2d.o fft.o $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) -I$(INCDIR) $^ -o $@

akde_scan : akde_scan.cc gauss_legendre.o Kde2d.o ProdKde2d.o ProdAdaKde2d.o fft.o $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) -I$(INCDIR) $^ -o $@

fcv_scan : fcv_scan.cc gauss_legendre.o Kde2d.o ProdKde2d.o fft.o $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) -I$(INCDIR) $^ -o $@

cv_scan : cv_scan.cc gauss_legendre.o Kde2d.o ProdKde2d.o fft.o $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) -I$(INCDIR) $^ -o $@

gauss_legendre.o : gauss_legendre.c gauss_legendre.h
	$(CC) -Wall -c $< -o $@

fft.o : fft.cc fft.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

cache_kde_score : cache_kde_score.o gauss_legendre.o Kde2d.o ProdKde2d.o fft.o $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) $^ -o $@

cache_kde_score.o : cache_kde_score.cc ProdKde2d.h $(UTILDIR)/file_io_utils.o
	$(CXX) $(CXXFLAGS) -I$(INCDIR) -c $< -o $@

Kde2d.o : Kde2d.cc Kde2d.h gauss_legendre.h $(UTILDIR)/file_io_utils.h
	$(CXX) $(CXXFLAGS) -I$(INCDIR) -c $< -o $@

ProdKde2d.o : ProdKde2d.cc ProdKde2d.h Kde2d.h fft.h
	$(CXX) $(CXXFLAGS) -I$(INCDIR) -c $< -o $@

ProdAdaKde2d.o : ProdAdaKde2d.cc ProdAdaKde2d.h ProdKde2d.h Kde2d.h fft.h
	$(CXX) $(CXXFLAGS) -I$(INCDIR) -c $< -o $@

clean:
	@rm -f *~ *.o $(BINARIES)
