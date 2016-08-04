#modified 052716TASUGI
#modified 073016Tasu
#modified 080216Tasu batch conversion example added.

#install requirement
install.packages("devtools")
library(devtools)
install_github("Tasu/EpDB2UG")

#####################################################################
####batch usage: if you have multiple gff3 files in one directory.###
#####################################################################
library(EpDB2UG)
#change to your target directory
dirL<-("~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/")
flist<-dir(dirL)
files=paste(dirL,flist[grepl("*gff3$",flist)],sep="")
sapply(files,toxodb2ugene)
#############batch usage: END HERE###################################


###################################################################
####standard usage: if you want to convert one gff3 file###########
###################################################################
library(EpDB2UG)
#1.   input gff file name
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/TGME49_chrVIII_5677701_5687700.gff3"
#change if needed. DEFAULT: output files will be made in the same directry tha you put input file#####
#2.   fasta file name you will use for ugene
outFASTAUGENE<-paste(in_f,".fasta",sep="")
#3.   gff file output you will use for ugene
outGFFUGENE<-paste(in_f,".ugene.gff",sep="")
#4. tempfile prefix
tempDir<-"./temp"
outGFFtemp<-paste(tempDir,runif(1),sep="")
#run parser
parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
#edit base position
modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
#delete temp file
file.remove(outGFFtemp)
#################single usage: END HERE##########################################
