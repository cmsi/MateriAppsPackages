#!/bin/sh

set -x

if [ -n "$XTAPP_ROOT" ]; then
  XTAPP_PS_DIR=$XTAPP_ROOT/pseudo-potential/PBE/PS
else
  XTAPP_PS_DIR=/usr/share/xtapp/pseudo-potential/PBE/PS
fi

# export GIOUNIT_DEBUG=1

rm -f fort.* quartz.lpt quartz.rho quartz.str quartz.wfn *.log
export FORT10=quartz.cg
export FORT34=$XTAPP_PS_DIR/ps-Si
export FORT35=$XTAPP_PS_DIR/ps-O
time inipot > quartz-initpot.log

export FORT11=quartz.lpt
export FORT25=quartz.rho
export FORT96=quartz.wfn
export FORT99=quartz.str
time cgmrpt > quartz-cgmrpt.log
