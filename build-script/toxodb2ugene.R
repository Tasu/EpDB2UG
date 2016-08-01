#modified 052716TASUGI
#modified 073016Tasu

#read requirement
library(EpDB2UG)

######please change these 4 parameter for your settings.###########
#1.   input gff file name
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/TGME49_chrVIIa_2403098_2413097.gff3"

###############change if needed. DEFAULT<-current directory+temp#####
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

