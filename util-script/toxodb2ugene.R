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


#####################################################################
####sandbox: make genbank from Gene Of Interest ID.
####require whole genome fasta and whole genome GFF (any but in the same version)
#####################################################################
library(EpDB2UG)
#init
geneOfInterest<-"TGME49_286470"
#output genbank file
outDir<-"~/Documents/OneDrive/ToxoDB2Ugene//EPDB2UG/tests/testthat/testdata/"
outGENBANK<-paste(outDir,geneOfInterest,"_gLocus.gb",sep="")

#fasta and gff files should have the same version & strain.
gff<-"~/Documents/OneDrive/ToxoDB2Ugene//EPDB2UG/tests/testthat/testdata/current-toxodb/ToxoDB-28_TgondiiME49.gff"
fasta<-"~/Documents/OneDrive/ToxoDB2Ugene//EPDB2UG/tests/testthat/testdata/current-toxodb/ToxoDB-28_TgondiiME49_Genome.fasta"

####get gLocus of interest from geneId
gLocus<-findGeneLocusFromToxoDBGFF(geneId=geneOfInterest,gff=gff)
surroundingLocus<-gLocus
surroundingLocus$start<-max(1,gLocus$start-4000)
surroundingLocus$end<-gLocus$end+4000
surroundingLocus

#make and write out annotated genbank
genbank<-list(seq=c(),featureList=c())
#get seq and feature in locus of interest
genbank<-list(
  seq=subFasta(gLocus=surroundingLocus,fasta=fasta)
  ,
  #TODO SUSPEND HERE
  featureList=subGFF(gLocus=surroundingLocus,gff=gff)
)

#write genbank file
.writeGenbank(outfile=outGENBANK,fasta=genbank$seq,featureList=genbank$featureList)
cat(paste("Please use",outGENBANK," for UGENE."))

#############################
#for test
#############################
saveRDS(gLocus,file = "~/Documents/OneDrive/ToxoDB2Ugene//EPDB2UG/tests/testthat/testdata/expect/TGME49_286470-gLocus.rds")
remove(gLocus)
gLocus<-readRDS("~/Documents/OneDrive/ToxoDB2Ugene//EPDB2UG/tests/testthat/testdata/expect/TGME49_286470-gLocus.rds")




############################
#shiny UI test
############################

