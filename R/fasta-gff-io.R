#this script contains function for the EupathDB gff3 cleanup
#TODO change code to R6 objective structure.
#TODO split the file for the function which use another function in this file.

#' parsegff3WithSeq
#'
#' split EupathDB GFF3 with sequence to GFF and FASTA
#' deplicated
#' @param inF input GFF3 file path
#' @param outGFF output GFF file path
#' @param outFASTA output fasta file path
#' @export
#' @examples
#'
parsegff3WithSeq<-function(inF="",outGFF="",outFASTA=""){
  #init parameter
  gffPart<-FALSE
  fastaPart<-FALSE
  gffPart<-.getGffFromGFF3(inF)
  fastaPart<-.getSeqFromGFF3(inF)
  #out each file
  fastaOverwrite="yes"
  if(file.exists(outFASTA)) fastaOverwrite<-readline(prompt=paste("fasta output file, ", outFASTA, " already exists. Do you want to overwrite? yes / no [enter]",sep=""))
  if(fastaOverwrite=="yes") writeLines(fastaPart,con = outFASTA)
  gffOverwrite="yes"
  if(file.exists(outGFF)) gffOverwrite<-readline(prompt=paste("gff output file, ", outGFF, " already exists. Do you want to overwrite? yes / no [enter]",sep=""))
  if(gffOverwrite=="yes") writeLines(gffPart,con = outGFF)
}


#' modifyGFF4UGENE
#'
#' this function edits the base position
#' @param toxoDBGFF input file path
#' @param UGENEGFF output file path
#' @export
#' @examples
#'
modifyGFF4UGENE <- function(toxoDBGFF, UGENEGFF) {
  in_F<-toxoDBGFF
  try(if(in_F=="")stop("ToxoDB GFF input path is required."))
  gff3 <- readLines(toxoDBGFF)
  gff3out <- .positionFix(gff3)
  #write GFF in new GFF file.
  gffOverwrite="yes"
  if(file.exists(UGENEGFF)) gffOverwrite<-readline(prompt=paste("position fixed gff output file, ", UGENEGFF, " already exists. Do you want to overwrite? yes / no [enter]",sep=""))
  if(gffOverwrite=="yes") write.table(gff3out,file = UGENEGFF,sep = "\t", quote = F, row.names = F, col.names = F)
}

#' .positionFix
#'
#' getFastaPart from GFF3 with sequence.
#' @param inF any file contains single fasta sequence at the end of the file.
#' @examples
#'
.positionFix<-function(gffPart=c("")){
#init parameter
  startCol<-4  #column 4 in GFF is start position of the features
  endCol<-5    #column 5 in GFF is end position of the features
  sequence_region_pattern<-"^##sequence-region "
  position_splitter<-c("..",":")
  #read gff file
  gff3 <- gffPart
  #get position in the chromosome
  regionline <- gff3[grepl(pattern = sequence_region_pattern, gff3)]
  #*:startNumber..endNumber
  startPosition <- as.numeric(
  unlist(
      strsplit(split = position_splitter[1], fixed=T,
               x = unlist(strsplit(x = regionline, split = position_splitter[2], fixed = T)
               )[2]
      )
    )[1]
  )
  #read feature table from the file stream
#   gff3<-c("#hoge","#comment","1\t2\t3","4\t5\t6")
  tableStream<-gff3[!grepl("^#",gff3)]
  rows<-strsplit(tableStream,split="\t")
  gff3out<-do.call(rbind.data.frame,rows)
  #calc position from chromosomal position to position in fasta file
  starts<-as.numeric(as.character(gff3out[,startCol]))-startPosition +1 #start base of the GFF is 1 not 0
  ends<-as.numeric(as.character(gff3out[,endCol]))-startPosition +1 #start base of the GFF is 1 not 0
  #edit GFF with modified position
  gff3out[,startCol]<-starts
  gff3out[,endCol]<-ends
  gff3out#return position modified gff table.
}

#' .getSeqFromGFF3
#'
#' getFastaPart from GFF3 with sequence.
#' @param inF any file contains single fasta sequence at the end of the file.
#' @examples
#'
.getSeqFromGFF3<-function(inF=""){
   #init parameter
  fastaPart<-FALSE
  fastaHeader<-"^>"
  fastaTmp<-c()
  #read file containing multi part(header,gff,fasta) object
  #FILE ERROR HANDLING
  try(if(!file.exists(inF))stop("input file not found."))
  multi<-readLines(inF)
  #split files into 'header, GFF and fasta'
  for(line in multi){
    #detect start line of fasta part
    if(!fastaPart){
      if(grepl(fastaHeader,line)){
        fastaPart<-TRUE
      }
    }
    #append fasta line to fasta output stream
    if(fastaPart){
      fastaTmp<-c(fastaTmp,line)
    }
  }
  #error handling
  try(if(is.null(fastaTmp))stop("fasta part could not be found in input file. please make sure you check the include sequence box when you download gff3 file in ToxoDB."))
  fastaTmp#return fasta part character vectors.
}

#' .getFastaFromGFF3
#'
#' getFastaPart from GFF3 as a list(name and seq).
#' @param inF any file contains single fasta sequence at the end of the file.
#' @examples
#'
.getFastaFromGFF3<-function(inF=""){
  fastaPart<-.getSeqFromGFF3(inF)
  return(.fastaToSeq(fastaPart))
}

#' .getGffFromGFF3
#'
#' getGffPart from GFF3 with sequence.
#' @param inF any file contains GFF
#' @examples
#'
.getGffFromGFF3<-function(inF=""){
   #init parameter
  gffPart<-FALSE
  gffHeader<-"^##gff-version 3" #please modify if needed.
  fastaHeader<-"^>"

  gffTmp<-c()
  #read file containing multi part(header,gff,fasta) object
  #FILE ERROR HANDLING
  try(if(!file.exists(inF))stop("input file not found."))
  multi<-readLines(inF)
  #split files into 'header, GFF and fasta'
  for(line in multi){
    #detect start line of gff part
    if(!gffPart){
      if(grepl(gffHeader,line)){
        gffPart<-TRUE
      }
    }
    if(grepl(fastaHeader,line)){
        fastaPart<-TRUE
        gffPart<-FALSE
    }
    #append gff line to gff output stream
    if(gffPart){
      gffTmp<-c(gffTmp,line)
    }
  }
  #error handling
  try(if(is.null(gffTmp))stop("gff part could not be found in input file"))
  gffTmp#return gffTmp gff part character vectors.
}

#' .getFeatureFromGFF3
#'
#' gff3 to featurelist (private function)
#' @param inF gff3 file path
#' @examples
#'
.getFeatureFromGFF3<-function(inF=""){
  gffPart<-.getGffFromGFF3(inF)
  modGFF<-.positionFix(gffPart)
  features<-.getFeatureFromGFF(modGFF)
}


#' .getFeatureFromGFF
#'
#' gff to featurelist (private function)
#' @param modGFF positionFixed gff character vectors line by line
#' @examples
#'
.getFeatureFromGFF<-function(modGFF=c("")){
  #TODO validation of gff file format here
  featureList<-list()
  featureList<-apply(modGFF,1,function(x){
    feature<-list(start=0,end=0,complement=FALSE)#empty feature
    #position
    feature$start<-x[4]
    feature$end<-x[5]
    feature$complement<-x[7]=="-"
    #annotation type
    feature$notes<-list()
    feature$notes["ugene_type"]<-paste('/ugene_name="',x[3],'"',sep="")
    #annotation description
    attrList<-x[9]
    for(attr in strsplit(attrList,split=";")[[1]]){
      #attr<-strsplit(attrList,split=";")[[1]][1]
      attrNameValue<-strsplit(attr,split="=")[[1]]
      note<-paste('/',attrNameValue[1],'="',attrNameValue[2],'"',sep="")
      feature$notes[attrNameValue[1]]<-note
    }
    return(feature)
  })
  return(featureList)#return featureList
}

#' .readGFF
#'
#' gff to featurelist (wrapper for .getFeatureFromGFF with parameter of file path)
#' @param inF gff file path
#' @export
#' @examples
#'
.readGFF<-function(inF){
  table<-read.table(inF,sep="\t")
  .getFeatureFromGFF(table)
}

#' .readFASTA
#'
#' fasta to name and seq (private function)
#' @param inF fasta file path
#' @export
#' @examples
#'
.readFASTA<-function(inF){
  multi<-readLines(inF)
  return(.fastaToSeq(multi))
}

#' .fastaToSeq
#'
#' fasta to name and seq (private function)
#' @param multi character vectors
#' @examples
#'
.fastaToSeq<-function(multi){
  #TODO fasta format validation here
  seqName<-substr(multi[1],2,nchar(multi[1]))#remove > from name
  seq<-paste(multi[-1],collapse = "")
  fasta=list(name=seqName,seq=seq)
  return(fasta)
}

#' subFasta
#'
#' return subregion of an input fasta as a seq object
#' seq(name="CHR_START_END",seq="ATGC...")
#' @param gLocus genome locus list(start=0, end=0, complement=F)
#' @param multi character vectors
#' @export
#' @examples
#'
subFasta<-function(gLocus=list(chr="",start=0,end=0,complement=F),fasta="filepath"){
  seqName<-paste(gLocus$chr,gLocus$start,gLocus$end,sep="_")
  try(if(!file.exists(fasta)) stop("input fasta file not found."))
  conn<-file(fasta,open="r")#open r is required to save your time
  flag<-TRUE
  line<-""
  header<-paste("^>",gLocus$chr," ",sep="")
  while (flag){
    line<-readLines(conn,n=1)
    flag<-!grepl(header,line)
  }
  seqV<-c()
  seqLen<-0
  while(seqLen<gLocus$end){
    line<-readLines(conn,n=1)
    seqV<-c(seqV,line)
    seqLen<-seqLen+nchar(line)
  }
  seq<-substr(x=paste(seqV,collapse = ""),start = gLocus$start,stop = gLocus$end)
  fasta=list(name=seqName,seq=seq)
  return(fasta)
}



#' findGeneLocusFromToxoDBGFF
#'
#' input toxoDBID return genome locus position (chr, start, end, complement)
#' ~1MB memory for 19MB ToxoDB-28_TgondiiME49.gff
#' @param geneId toxoDB geneId ex. TGME49_286470
#' @param gff path to toxodbgff file
#' @export
findGeneLocusFromToxoDBGFF<-function(geneId,gff){
  conn<-file(gff,open="rt")
  geneIdPattern<-paste("ID=",geneId,";",sep="")
  flag<-TRUE
  line<-c()
#   library(pryr)
#   maxMem<-0
  while (flag){
    line<-readLines(conn,n=1)
    flag<-!grepl(geneIdPattern,line)
#     maxMem<-max(maxMem,object.size(line))
  }

  gene<-strsplit(line,split = "\t")[[1]]
#   cat("\nmaxObj\n")
#   cat(maxMem)
  close(conn)
  return(list(chr=as.character(gene[1]),start=as.numeric(as.character(gene[4])),end=as.numeric(as.character(gene[5])),complement=as.character(gene[7])=="-"))
}


#' loadAllOnMemotry
#'
#' input toxoDBID return genome locus position (chr, start, end, complement)
#' around 25MB will be used for 19MB ToxoDB-28_TgondiiME49.gff
#' for test
#' @param geneId toxoDB geneId ex. TGME49_286470
#' @param gff path to toxodbgff file
#' @export
loadAllOnMemotry<-function(geneId,gff){
  conn<-file(gff,open="rt")
  geneIdPattern<-paste("ID=",geneId,";",sep="")
  multi<-readLines(conn)
  flag<-TRUE
  line<-c()
  index<-1
  #   library(pryr)
  #   maxMem<-0
  #   maxMem<-max(maxMem,object.size(multi))
  #around 25MB will be used for 19MB ToxoDB-28_TgondiiME49.gff
  line<-grep(value = T,pattern = geneIdPattern,x = multi)
  try(if(is.null(line)) stop ("ID not found in GFF"))
  gene<-strsplit(line[1],split = "\t")[[1]]
  #     cat("\nmaxObj\n")
  #     cat(maxMem)
  close(conn)
  return(list(chr=as.character(gene[1]),start=as.numeric(as.character(gene[4])),end=as.numeric(as.character(gene[5])),complement=as.character(gene[7])=="-"))
}
