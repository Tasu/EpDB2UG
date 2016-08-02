# EpDB2UG

This package can be used as a utility tool to convert EupathDB GFF output to the local annotation files and DNA sequences for UGENE.

#clone R project
1.install git in your system.
2.open parent directory you want to locate this Rproject directory
3.open shell and type $git clone https://github.com/Tasu/EpDB2UG.git

#install for your R packge library
install.packages("devtools")
library("devtools")
devtools::install_github("Tasu/EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)

#to get input GFF anotation file with genome sequence (of interest)
1.Go to genome browser in eupathdb.
2.Move to the locus of interest (you can go to gene page first, then you can view the locus in the genome browser.)
3.download gff file.
  3.1. select Download Track Data in pull down box located at the right top of the genome browser.
  3.2. tap configure to open the configuration.
  3.3. you can select parameters for the downloading the locus.
    3.3.1. You can check on "Embed DNA sequence in the file"
  3.4. save the locus in file <-- this file can be used as an input file.

#usage
please use script in build-script/toxodb2ugene.R
#modified 052716Tasu
#modified 071816Tasu

######please change these 3 parameter for your settings.###########
#1.   input gff file name (the file you got from EupathDB)
in_f<-"~/Google Drive/louLab/PKAs/sequence/bPAC//TGME49_chrXI_5270568_5280567.gff3"

#2.   fasta file name you want to use for ugene
outFASTAUGENE<-"~/Google Drive/louLab/PKAs/sequence/bPAC//TGME49_chrXI_5270568_5280567.fasta"

#3.   gff file output you want to use for ugene
outGFFUGENE<-"~/Google Drive/louLab/PKAs/sequence/bPAC//TGME49_chrXI_5270568_5280567.ugene.gff3"
############BELOW THIS LINE DO NOT HAVE TO BE CHANGED##############


###############change if needed. DEFAULT<-current directory+temp#####
#4. tempfile prefix
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
