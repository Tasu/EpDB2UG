#write genbank format file
#SPECIFICATION#####
FORMAT_LOCUS="LOCUS      "#paste with space
FORMAT_UNIMARK="UNIMARK    "#paste with space
FORMAT_FEATURE="FEATURES             Location/Qualifiers"
FORMAT_MISC_FEATURE="     misc_feature   "#paste with space
FORMAT_NOTES="                    "#paste with space /hoge="foobar"
FORMAT_ORIGIN="ORIGIN"
##UGENE ignore the space in the sequence but space between base number and sequence is required.
FORMAT_ENDMARK="//"
###################

#modify the outraged value
.trimFeature=function(featureList,seqLen){
  for(i in 1:length(featureList)){
    resultList=list()
    feature<-featureList[[i]]
    if(feature$end>=1&feature$start<=seqLen){
    feature$start<-max(1,feature$start)
    feature$end<-min(seqLen,feature$end)
    resultList[[i]]<-feature
    }
  }
  resultList#return feature list
}

#construct header lines
.weaveHeader=function(header){
  h<-c()
  h<-paste(FORMAT_LOCUS,header, sep=" ")
  h<-c(h,paste(FORMAT_UNIMARK,header,sep=" "))
  h#return chracters vector (element by line)
}

#construct feature and seq region
.weaveBody=function(featureList,seq){
  seqLen=nchar(seq)
  trimed<-.trimFeature(featureList,seqLen)
  f<-c()
  f<-FORMAT_FEATURE
  for(feature in trimed){
    position<-paste(feature$start,"..",feature$end,sep="")
    if(feature$complement){
      position<-paste("complement(",position,")",sep="")
    }
    f<-c(f,paste(FORMAT_MISC_FEATURE,position,sep=" "))
    for(note in f$notes){
      f<-c(f,paste(FORMAT_NOTES,feature$featureid,sep=" "))
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

.writeGenbank<-function(outfile,fasta,featureList){
  header<-fasta$name
  tmp<-.weaveHeader(header)
  seq<-fasta$seq
  tmp<-c(tmp,.weaveBody(featureList,seq))
  write(tmp,file = outfile,ncolumns = 1,sep="")
}

.readGFF<-function(inF){
#   inF<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/done//TGME49_chrIb_823555_857088.ugene.gff3"
  multi<-readLines(inF)
  featureList<-list()
  for(i in 1:length(multi)){
    #i=1
    l<-multi[i]
    feature<-list()#empty feature
    annotation<-strsplit(l,split = "\t")[[1]]
    #position
    feature$start<-annotation[4]
    feature$end<-annotation[5]
    feature$complement<-annotation[7]=="-"
    #annotation type
    feature$notes<-list()
    feature$notes["ugene_type"]<-paste('/ugene_name="',feature[3],'"',sep="")
    #annotation description
    attrList<-annotation[9]
    for(attr in strsplit(attrList,split=";")[[1]]){
      #attr<-strsplit(attrList,split=";")[[1]][1]
      attrNameValue<-strsplit(attr,split="=")[[1]]
      note<-paste('/',attrNameValue[1],'="',attrNameValue[2],'"',sep="")
      feature$note[attrNameValue[1]]<-note
    }
  featureList[[i]]<-feature
  }
  featureList#return featureList
}

.readFASTA<-function(inF){
#inF<-"~/Google Drive/louLab/cyst wall/figures-6umclearance/tagging/temp/done//TGME49_chrIb_823555_857088.fasta"
  multi<-readLines(inF)
  seqName<-substr(multi[1],2,nchar(multi[1]))
  seq<-paste(multi[-1],collapse = "")
  fasta=list(name=seqName,seq=seq)
  fasta#return fasta object
}
