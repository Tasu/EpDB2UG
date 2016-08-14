# EpDB2UG

This package can be used as a utility tool to convert EupathDB GFF output to the genbank format file for UGENE.

#I just want to get it work...
please run script below.

install.packages("devtools")
library(devtools)
install_github("Tasu/EpDB2UG")
library(EpDB2UG)

##change to your input gff file
in_f<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/testTGME49_chrX_1032284_1067339.gff3"
inputGFF3OutputGenbank(in_f)

##change to your target directory
dirL<-("~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/")
flist<-dir(dirL)
files<-paste(dirL,flist[grepl("*gff3$",flist)],sep="")
sapply(files,inputGFF3OutputGenbank)

#TODO
concatenate the CDS to make the full length CDS sequence of the gene, translate the CDS to peptide.

#requirement
This package was tested in R 3.2.0 x64 os x.
devtools package in CRAN is required for installing this package from github.

#install for your R packge library

install.packages("devtools")
devtools::install_github("Tasu/EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)

#to get input GFF anotation file with genome sequence (of interest)

1.Go to genome browser in EupathDB (ToxoDB, TriTrypDB, MicrosporidiaDB ...).
2.Move to the locus of interest (Alternatively, you can search gene of interest, go to gene's page, in the page you can find the link to genome browser of the locus where your gene locate. )
3.download gff file including DNA sequence.
  3.1. select 'Download Track Data' in a pull down box located at the right top of the genome browser.
  3.2. tap configure to open the configuration.
  3.3. you can select parameters for the downloading the locus.
    3.3.1. please check on "Embed DNA sequence in the file"
  3.4. save the locus in file <-- this file can be used as an input file.

#usage 1 with fasta and gff file
>library(EpDB2UG)
>in_f<-'your-gff3-file-path'
>toxodb2ugene(in_f)

#usage 2 only genbank file
>library(EpDB2UG)
>in_f<-'your-gff3-file-path'
>inputGFF3OutputGenbank(in_f)

genbank file with '${your-gff3-file-path}.gb' will be created in the directory where ${your-gff3-file-path} is in.

please use https://github.com/Tasu/EpDB2UG/blob/master/util-script/toxodb2ugene.R for actual usage with R or RStudio.
#modified 052716Tasu
#modified 071816Tasu
