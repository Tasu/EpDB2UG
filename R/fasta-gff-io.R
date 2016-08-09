#this script contains function for the EupathDB gff3 cleanup
#TODO change code to R6 objective structure.
#TODO split the file for the function which use another function in this file.

#' parsegff3WithSeq
#'
#' split EupathDB GFF3 with sequence to GFF and FASTA
#' @param inF input GFF3 file path
#' @param outGFF output GFF file path
#' @param outFASTA output fasta file path
#' @export
#' @examples
#' inF<-"FILEPATH TO TOXODB GFF3 FILE INCLUDING track data and fasta sequence"
#' outGFF<-"FILEPATH TO STOR GFF PART"
#' outFASTA<-"FILEPATH TO STORE FASTA PART"
#' parsegff3WithSeq(inF,outGFF,outFASTA)
parsegff3WithSeq<-function(inF,outGFF,outFASTA){
  #init parameter
  gffPart<-FALSE
  fastaPart<-FALSE
  gffHeader<-"^##gff-version 3" #please modify if needed.
  fastaHeader<-"^>"
  gffTmp<-c()
  fastaTmp<-c()
  #read file containing multi part(header,gff,fasta) object
  #FILE ERROR HANDLING
  try(if(!file.exists(inF))stop("input file not found."))
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
  try(if(is.null(gffTmp))stop("gff part could not be found in input file"))
  try(if(is.null(fastaTmp))stop("fasta part could not be found in input file. please make sure you check the include sequence box when you download gff3 file in ToxoDB."))
  #out each file
  fastaOverwrite="yes"
  if(file.exists(outFASTA)) fastaOverwrite<-readline(prompt=paste("fasta output file, ", outFASTA, " already exists. Do you want to overwrite? yes / no [enter]"),sep="")
  if(fastaOverwrite=="yes") writeLines(fastaTmp,con = outFASTA)

  gffOverwrite="yes"
  if(file.exists(outGFF)) gffOverwrite<-readline(prompt=paste("gff output file, ", outGFF, " already exists. Do you want to overwrite? yes / no [enter]"),sep="")
  if(gffOverwrite=="yes") writeLines(gffTmp,con = outGFF)
}


#' modifyGFF4UGENE
#'
#' this function edits the base position
#' @param toxoDBGFF input file path
#' @param UGENEGFF output file path
#' @export
#' @examples
#' modifyGFF4UGENE(toxoDBGFF, UGENEGFF)
modifyGFF4UGENE <- function(toxoDBGFF, UGENEGFF) {
  #init parameter
  startCol<-4  #column 4 in GFF is start position of the features
  endCol<-5    #column 5 in GFF is end position of the features
  sequence-region-pattern<-"^##sequence-region "
  position-splitter<-c("..",":")
  #read gff file
  gff3 <- readLines(toxoDBGFF)
  #get position in the chromosome
  regionline <- gff3[grepl(pattern = sequence-region-pattern, gff3)]
  #*:startNumber..endNumber
  startPosition <- as.numeric(
  unlist(
      strsplit(split = position-splitter[1], fixed=T,
               x = unlist(strsplit(x = regionline, split = position-splitter[2], fixed = T)
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
  gffOverwrite="yes"
  if(file.exists(UGENEGFF)) gffOverwrite<-readline(prompt=paste("position fixed gff output file, ", UGENEGFF, " already exists. Do you want to overwrite? yes / no [enter]"),sep="")
  if(gffOverwrite=="yes") write.table(gff3out,file = UGENEGFF,sep = "\t", quote = F, row.names = F, col.names = F)
}


#' .readGFF
#'
#' gff to featurelist (private function)
#' @param inF gff file path
#' @export
#' @examples
#' TODO
.readGFF<-function(inF){
  multi<-readLines(inF)
  #TODO validation of gff file format here
  featureList<-list()
  i=c()
  for(i in 1:length(multi)){
    l<-multi[i]
    feature<-list()#empty feature
    annotation<-strsplit(l,split = "\t")[[1]]
    #position
    feature$start<-annotation[4]
    feature$end<-annotation[5]
    feature$complement<-annotation[7]=="-"
    #annotation type
    feature$notes<-list()
    feature$notes["ugene_type"]<-paste('/ugene_name="',annotation[3],'"',sep="")
    #annotation description
    attrList<-annotation[9]
    for(attr in strsplit(attrList,split=";")[[1]]){
      #attr<-strsplit(attrList,split=";")[[1]][1]
      attrNameValue<-strsplit(attr,split="=")[[1]]
      note<-paste('/',attrNameValue[1],'="',attrNameValue[2],'"',sep="")
      feature$notes[attrNameValue[1]]<-note
    }
  featureList[[i]]<-feature
  }
  featureList#return featureList
}

#' .readFASTA
#'
#' fasta to name and seq (private function)
#' @param inF fasta file path
#' @export
#' @examples
#' TODO
.readFASTA<-function(inF){
  multi<-readLines(inF)
  #TODO fasta format validation here
  seqName<-substr(multi[1],2,nchar(multi[1]))
  seq<-paste(multi[-1],collapse = "")
  fasta=list(name=seqName,seq=seq)
  fasta#return fasta object
}
