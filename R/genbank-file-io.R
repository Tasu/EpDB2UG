
#' .trimFeature
#'
#' modify the outraged value
#' @param featureList list of gff annotation line
#' @export
#' @examples
#' todo
.trimFeature=function(featureList,seqLen){
  resultList=list()
  for(i in 1:length(featureList)){
    feature<-featureList[[i]]
    if(as.numeric(feature$end)<1|as.numeric(feature$start)>seqLen){
      resultList[[i]]<-NULL
    }else{
      feature$start<-max(1,as.numeric(feature$start))
      feature$end<-min(seqLen,as.numeric(feature$end))
      resultList[[i]]<-feature
    }
  }
  resultList#return feature list
}

#' .weaveHeader
#'
#' construct header for genbank
#' @param header name of sequence
#' @export
#' @examples
#' TODO
.weaveHeader=function(header){
  FORMAT_LOCUS="LOCUS      "#paste with space
  FORMAT_UNIMARK="UNIMARK    "#paste with space
  h<-c()
  h<-paste(FORMAT_LOCUS,header, sep=" ")
  h<-c(h,paste(FORMAT_UNIMARK,header,sep=" "))
  h#return chracters vector (element by line)
}

#' .weaveBody
#'
#' construct feature and sequence for genbank
#' @param featureList features
#' @param seq sequence
#' @export
#' @examples
#' TODO
.weaveBody=function(featureList,seq){
  #seq=fasta$seq
  FORMAT_FEATURE="FEATURES             Location/Qualifiers"
  FORMAT_MISC_FEATURE="     misc_feature   "#paste with space
  FORMAT_NOTES="                    "#paste with space /hoge="foobar"
  FORMAT_ORIGIN="ORIGIN"
  FORMAT_ENDMARK="//"
  #seq<-fasta$seq
  seqLen=nchar(seq)
  trimed<-.trimFeature(featureList,seqLen)
#   trimed<-featureList
  f<-c()
  f<-FORMAT_FEATURE
  for(feature in trimed){
    if(!is.null(feature)){
    position<-paste(feature$start,"..",feature$end,sep="")
    if(feature$complement){
      position<-paste("complement(",position,")",sep="")
    }
    f<-c(f,paste(FORMAT_MISC_FEATURE,position,sep=" "))
    for(note in feature$notes){
      f<-c(f,paste(FORMAT_NOTES,note,sep=" "))
    }
    }
  }
  s<-c()
  s<-FORMAT_ORIGIN
  seqlineNum<-ceiling(seqLen/60)
  for(i in 1:seqlineNum){
    start<-1+60*(i-1)
    s[i+1]<-paste(start,substr(seq,start,start+59),sep=" ")
  }
  b<-c(f,s,FORMAT_ENDMARK)
  b
}

#' .writeGenbank
#'
#' export genbank file
#' @param outfile output path
#' @param fasta fasta
#' @param featureList gff
#' @export
#' @examples
#' TODO
.writeGenbank<-function(outfile,fasta,featureList){
  tmp<-.weaveHeader(fasta$name)
  tmp<-c(tmp,.weaveBody(featureList,fasta$seq))
  genbankOverwrite="yes"
  if(file.exists(outfile)) genbankOverwrite<-readline(prompt=paste("genbank output file, ", outfile, " already exists. Do you want to overwrite? yes / no [enter]"),sep="")
  if(genbankOverwrite=="yes") write(tmp,file = outfile,ncolumns = 1,sep="")
}


