#!/bin/sh
#$ -N demo
#$ -cwd
#$ -m beas
#$ -M xueyi.shen@ed.ac.uk
#$ -l h_vmem=2G
#$ -l h_rt=24:00:00
. /etc/profile.d/modules.sh
source ~/.bash_profile

module load igmm/apps/R/3.5.1

R CMD BATCH demo.R