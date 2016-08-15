##EpDB2UG

This package is a utility tool to convert EupathDB GFF3 output with sequence to the genbank format file for UGENE (annotated sequence file).

##get started w/o reading manual
please copy and paste scripts below in notepad or RStudio, edit and run in R console.

    install.packages("devtools")#if not yet installed.
    devtools::install_github("Tasu/EpDB2UG")
    library(EpDB2UG)
    
    #for single file conversion
    ##change to your input gff file path
    in_f<-"./testTGME49_chrX_1032284_1067339.gff3"
    inputGFF3OutputGenbank(in_f)
    
    #for conversion of multiple files in the same directory
    ##change to your target directory
    dirL<-("./directoryOfGff3")
    flist<-dir(dirL)
    files<-paste(dirL,flist[grepl("*gff3$",flist)],sep="")
    sapply(files,inputGFF3OutputGenbank)

####coming feature(s)

 0. get chromosomal locus gff3 file from EupathDB with ID of gene of interest.
 1. translate the CDS to peptide to get the straight forward peptide translation of the gene.

####requirement
This package was tested in R 3.2.0 x64 on OS X 10.11.6.
"devtools" package in CRAN is required for easy installing this package from github.
Package itself do not have dependency. Only R-base system is required. RStudio will make it easy to edit and run scripts, but not required. 

####install for your R packge library
 - In R console.

    install.packages("devtools")
    devtools::install_github("Tasu/EpDB2UG")
    library(EpDB2UG)
    help(package = EpDB2UG)

###getting input GFF anotation file with genome sequence (of interest)

1. Go to genome browser in EupathDB (ToxoDB, TriTrypDB, MicrosporidiaDB ...).
2. Move to the locus of interest (Alternatively, you can search gene of interest, go to gene's page, in the page you can find the link to genome browser of the locus where your gene locate. )
3. download gff file including DNA sequence.
  3.1. select 'Download Track Data' in a pull down box located at the right top of the genome browser.
  3.2. tap configure to open the configuration.
  3.3. you can select parameters for the downloading the locus.
    3.3.1. please check on "Embed DNA sequence in the file"
  3.4. save the locus in file <-- this file can be used as an input file.

####usage 1 with fasta and gff file

    library(EpDB2UG)
    in_f<-'your-gff3-file-path'
    toxodb2ugene(in_f)

###usage 2 only genbank file

    library(EpDB2UG)
    in_f<-'your-gff3-file-path'
    inputGFF3OutputGenbank(in_f)

#please use https://github.com/Tasu/EpDB2UG/blob/master/util-script/toxodb2ugene.R for actual usage with R or RStudio.
