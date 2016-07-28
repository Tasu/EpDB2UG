#modified 052716TASUGI

######please change these 4 parameter for your settings.###########
#1.   input gff file name
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/TGME49_chrIb_823555_857088.gff3"

#2.   fasta file name you will use for ugene
outFASTAUGENE<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/TGME49_chrIb_823555_857088.fasta"

#3.   gff file output you will use for ugene
outGFFUGENE<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/TGME49_chrIb_823555_857088.ugene.gff3"

###############change if needed. DEFAULT<-current directory+temp#####
#5. tempfile prefix
tempDir<-"./temp"
#gff temp output file, you can ignore this
outGFFtemp<-paste(tempDir,runif(1),sep="")
#####################################################################

#read requirement
library(EpDB2UG)

#run parser
parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
#edit base position
modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
#delete temp file
file.remove(outGFFtemp)

#after running this script without error message...
#Please read GFF file for UGENE and fasta file in UGENE and HF.
