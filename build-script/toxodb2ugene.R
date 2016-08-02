#modified 052716TASUGI
#modified 073016Tasu
#modified 080216Tasu batch conversion example added.

#read requirement
library(EpDB2UG)
####batch process #not recommended###
dirL<-("~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/")
flist<-dir(dirL)
files=paste(dirL,flist[grepl("*gff3$",flist)],sep="")
files
sapply(files,toxodb2ugene)
###################################

####standard example
######please change this parameter for your settings.###########
#1.   input gff file name
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/TGME49_chrVIII_5677701_5687700.gff3"

###############change if needed.#####
#2.   fasta file name you will use for ugene
outFASTAUGENE<-paste(in_f,".fasta",sep="")
#3.   gff file output you will use for ugene
outGFFUGENE<-paste(in_f,".ugene.gff",sep="")
#4. tempfile prefix
tempDir<-"./temp"
outGFFtemp<-paste(tempDir,runif(1),sep="")
#####################################################################
#run parser
parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
#edit base position
modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
#delete temp file
file.remove(outGFFtemp)

#after running this script without error message...
#Please read GFF file for UGENE and fasta file in UGENE and HF.

