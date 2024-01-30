#!/bin/sh

set -x

if [ -n "$XTAPP_ROOT" ]; then
  XTAPP_PS_DIR=$XTAPP_ROOT/pseudo-potential/PBE/PS
else
  XTAPP_PS_DIR=/usr/share/xtapp/pseudo-potential/PBE/PS
fi

# export GIOUNIT_DEBUG=1

rm -f fort.* si.lpt si.rho si.str si.wfn *.log
export FORT10=si.cg
export FORT34=$XTAPP_PS_DIR/ps-Si
time inipot > si-inipot.log

export FORT11=si.lpt
export FORT96=si.wfn
export FORT99=si.str
time cgmrpt > si-cgmrpt.log

export FORT10=si.pef
export FORT25=si.rho
export FORT50=si.band
time vbpef > si-vbpef.log
