#this script contains function for the EupathDB gff3 cleanup

##################
#function parsegff3WithSeq
#####PARAMETER####
#require input file path to EupathDB gff3 output WITH sequence.
#require outGFF and outFASTA file paths.
#####NOTES########
#input file may include track configuration data, it will be ignored.
#####TIPS#########
#TO GET INPUT_FILE
#sequence around your gene of interest from EupathDB.
#1.go to gene page in any of EupathDB
#2.go to genome browser from gene page.
#3.In the upright pull down box, choose 'DOWNLOAD TRACK Data'
#4.Tap Configure... button next to pull down box.
#5.check "Save to File", check "Embed DNA sequence in the file"
#6.Tap Go Button.
#your file will be downloaded.
#toxodb2ugene.R is the wrapper script of this method libarary.
#feel free to use it.
#################



#' parsegff3WithSeq
#'
#' this function parse gff files
#' @param inF outGFF outFASTA
#' @export
#' @examples
#' parsegff3WithSeq(inF,outGFF,outFASTA)
parsegff3WithSeq<-function(inF,outGFF,outFASTA){
  ##############
  #to reduce the memory size for big files, you can use line by line read
  #and line by line write instead. eupathDB genome sequence will not be beyond several hundred MB, it can be handled with recent PC.
  ##############
  #init parameter
  gffPart<-FALSE
  fastaPart<-FALSE
  gffHeader<-"^##gff-version 3" #please modify if needed.
  fastaHeader<-"^>"
  gffTmp<-c()
  fastaTmp<-c()

  #read file containing multi part(header,gff,fasta) object
  multi<-readLines(inF)

  #split files into 'header, GFF and fasta'
  for(line in multi){
    #detect start line of gff part
    if(!gffPart & !fastaPart){
      if(grepl(gffHeader,line)){
        gffPart<-TRUE
        fastaPart<-FALSE
      }
    }
    #detect start line of fasta part
    if(!fastaPart){
      if(grepl(fastaHeader,line)){
        fastaPart<-TRUE
        gffPart<-FALSE
      }
    }
    #append gff line to gff output stream
    if(gffPart){
      gffTmp<-c(gffTmp,line)
    }
    #append fasta line to fasta output stream
    if(fastaPart){
      fastaTmp<-c(fastaTmp,line)
    }
  }

  #error handling
  if(is.null(gffTmp)){
    write("no gff part in the file. please check file have '##gff-version 3' line in it", stderr())
  }
  if(is.null(fastaTmp)){
    write("no fasta part in the file. please check file have sequence start with '>..SEQNAMEHERE..' line in it", stderr())
  }
  #out each file
  writeLines(gffTmp,con = outGFF)
  writeLines(fastaTmp,con = outFASTA)
}


#' modifyGFF4UGENE
#'
#' this function edits the base position
#' @param toxoDBGFF, UGENEGFF
#' @export
#' @examples
#' modifyGFF4UGENE(toxoDBGFF, UGENEGFF)
modifyGFF4UGENE <- function(toxoDBGFF, UGENEGFF) {
  #init parameter
  startCol<-4  #column 4 in GFF is start position of the features
  endCol<-5    #column 5 in GFF is end position of the features
  #read gff file
  gff3 <- readLines(toxoDBGFF)#if you care about the memory size, just read line by line and quit if not starts with #.

  #get position in the chromosome
  regionline <- gff3[grepl(pattern = "^##sequence-region ", gff3)]
  #*:startNumber..endNumber
  startPosition <- as.numeric(
  unlist(
      strsplit(split = "..", fixed=T,
               x = unlist(strsplit(x = regionline, split = ":", fixed = T)
               )[2]
      )
    )[1]
  )
  #read gff3 file, ignore header lines starting with "#",
  gff3out <- read.table(toxoDBGFF, sep = "\t", comment.char = "#", quote = "")
  #calc position from chromosomal position to position in fasta file
  starts<-gff3out[,startCol]-startPosition +1 #start base of the GFF is 1 not 0
  ends<-gff3out[,endCol]-startPosition +1 #start base of the GFF is 1 not 0
  #edit GFF with modified position
  gff3out[,startCol]<-starts
  gff3out[,endCol]<-ends
  #write GFF in new GFF file.
  write.table(gff3out,file = UGENEGFF,sep = "\t", quote = F, row.names = F, col.names = F)
}


#' toxodb2ugene
#'
#' utility for this package functions (not recommended.)
#' please refer--> https://github.com/Tasu/EpDB2UG/blob/master/build-script/toxodb2ugene.R
#' @param toxoDBGFF
#' @export ${toxoDBGFF}.fasta and ${toxoDBGFF}.ugene.gff in the same directory of toxoDBGFF file
#' @examples
#' toxodb2ugene(toxoDBGFF)
toxodb2ugene<-function(toxoDBGFF){
  in_f<-toxoDBGFF
  outFASTAUGENE<-paste(in_f,".fasta",sep="")
  outGFFUGENE<-paste(in_f,".ugene.gff",sep="")
  tempDir<-"./temp"
  outGFFtemp<-paste(tempDir,runif(1),sep="")
  parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
  #edit base position
  modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
  #delete temp file
  file.remove(outGFFtemp)
}
