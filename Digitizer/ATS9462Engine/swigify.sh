#!/bin/bash

#script to generate python module from c++ file

cp ~/Qt-Projects/build-ATS9462-Desktop-Release/ats9462engine.o ./
#direct SWIG to the SWIG interface file (.i) and build a new .cpp file
swig -c++ -python -o ats9462engine_wrap.cpp ats9462engine_wrapper.i

L_FLAGS=" -L/usr/local/lib \
-L/usr/lib \
-L/usr/lib/x86_64-linux-gnu/ \
-L/usr/local/AlazarTech/lib \
-L/usr/local/lib64
"

LIB_FLAGS+=" -lboost_iostreams \
-lboost_filesystem \
-lboost_system \
-lboost_thread \
-pthread"

LIB_FLAGS+=" -lfftw3_threads -lfftw3 -lm"

LIB_FLAGS+=" -lATSApi"

INCLUDE_FLAGS="-I/home/admx/Qt-Projects/JASPL \
-I/home/admx/Qt-Projects/ATS9462"

#note that the include path MUST be for python3.4
#the c++11 file is to prevent errors of the form, 'x... is not a member of std::'
gcc -I/usr/include/python3.4m $INCLUDE_FLAGS -fPIC -std=c++11 -c ats9462engine_wrap.cpp $(python3-config --cflags) -o ats9462engine_wrap.o

#point g++ at the .o file generated in the previous step and the .o file
#generated by compiling the program seperately
g++ -fopenmp -lgomp -I/usr/include/python3.4m $INCLUDE_FLAGS $L_FLAGS $LIB_FLAGS -fPIC -lrt $(python3-config --ldflags) -shared ats9462engine_wrap.o ats9462engine.o -o _ats9462engine.so
#Module will be named 'ats9462engine'
#Note that this must be done using python3
