#!/bin/sh

sudo apt-get -y install libboost-dev pybind11-dev

python3 -m venv $HOME/qc
source $HOME/qc/bin/activate
pip3 install ipython numpy matplotlib

pip3 install blueqat cirq openfermion openjij qiskit qulacs qutip strawberryfields

(cd $HOME/qc && git clone https://github.com/iqusoft/intel-qs.git)
(cd $HOME/qc/intel-qs && curl -sL https://github.com/cmsi/MateriAppsPackages/raw/main/qc/intel-qs.patch | patch -p1)
mkdir $HOME/qc/intel-qs/build
(cd $HOME/qc/intel-qs/build && cmake -DIqsPython=ON .. && make)
cp -fp $HOME/qc/intel-qs/include/* $HOME/qc/include
cp -rp $HOME/qc/intel-qs/build/lib/*.so $HOME/qc/lib/$(python -c "import sys; print('python{}.{}'.format(sys.version_info.major, sys.version_info.minor))")/site-packages
ln -s $HOME/qc/lib/$(python -c "import sys; print('python{}.{}'.format(sys.version_info.major, sys.version_info.minor))")/site-packages/libiqs.so $HOME/qc/lib

(cd $HOME/qc && git clone https://github.com/qulacs/qulacs.git)
mkdir $HOME/qc/qulacs/build
(cd $HOME/qc/qulacs/build && cmake -DCMAKE_BUILD_TYPE=Release .. && make)
cp -rfp $HOME/qc/qulacs/include/* $HOME/qc/include/
cp -fp $HOME/qc/qulacs/lib/* $HOME/qc/lib/
