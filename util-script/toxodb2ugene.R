#modified 052716TASUGI
#modified 073016Tasu
#modified 080216Tasu batch conversion example added.

#install requirement
install.packages("devtools")
devtools::install_github("Tasu/EpDB2UG")


###################################################################
####standard usage: if you want to convert one gff3 file###########
###################################################################
library(EpDB2UG)
#1.change to your input gff file
in_f<-"~/Documents/OneDrive/ToxoDB2Ugene/EPDB2UG/tests/testthat/testdata/input/testTGME49_chrX_1032284_1067339.gff3"
inputGFF3OutputGenbank(in_f)
#####################################

#####################################################################
####batch usage: if you have multiple gff3 files in one directory.###
#####################################################################
library(EpDB2UG)
#change to your target directory
dirL<-("~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/")
flist<-dir(dirL)
files<-paste(dirL,flist[grepl("*gff3$",flist)],sep="")
sapply(files,inputGFF3OutputGenbank)
#############batch usage: END HERE###################################
