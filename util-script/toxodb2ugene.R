#modified 052716TASUGI
#modified 073016Tasu
#modified 080216Tasu batch conversion example added.

#install requirement
install.packages("devtools")
library(devtools)
install_github("Tasu/EpDB2UG")


###################################################################
####standard usage: if you want to convert one gff3 file###########
###################################################################
library(EpDB2UG)
#1.   input gff file name
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/testTGME49_chrX_1032284_1067339.gff3"
toxodb2ugene(in_f)
#####################################

#####################################################################
####batch usage: if you have multiple gff3 files in one directory.###
#####################################################################
library(EpDB2UG)
#change to your target directory
dirL<-("~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/")
flist<-dir(dirL)
files<-paste(dirL,flist[grepl("*gff3$",flist)],sep="")
sapply(files,toxodb2ugene)
#############batch usage: END HERE###################################


########if you want to know what's going on#############
#change if needed. DEFAULT: output files will be made in the same directry tha you put input file#####
#2.   fasta file name you will use for ugene
outFASTAUGENE<-paste(in_f,".fasta",sep="")
#3.   gff file output you will use for ugene
outGFFUGENE<-paste(in_f,".ugene.gff",sep="")
#4 genbank file output path
outGENBANK<-paste(in_f,".gb",sep="")
#5. tempfile prefix
tempDir<-"./temp"
outGFFtemp<-paste(tempDir,runif(1),sep="")
#run parser
parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
#edit base position
modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
#delete temp file
file.remove(outGFFtemp)

#######Need to be modify not to use privaye methods.
#read fasta file for genbank flatfile seq formatting
fasta<-.readFASTA(outFASTAUGENE)
#read gff file for genbank feature lists
featureList<-.readGFF(outGFFUGENE)
#export genbank file
.writeGenbank(outfile=outGENBANK,fasta=fasta,featureList=featureList)
#################single usage: END HERE##########################################
