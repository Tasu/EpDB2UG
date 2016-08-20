#main function
#' toxodb2ugene
#'
#' fasta, position fixed gff, genbank file will be made.
#' output genbank file is ugene-compatible, may not be compatible for other software.
#' @param toxoDBGFF input file path
#' @export
#' @examples
#'
toxodb2ugene<-function(toxoDBGFF){
  #FILE IO
  in_f<-toxoDBGFF
  outFASTAUGENE<-paste(in_f,".fasta",sep="")
  outGFFUGENE<-paste(in_f,".ugene.gff",sep="")
  outGENBANK<-paste(in_f,".gb",sep="")
  tempPrefix<-"./temp"
  outGFFtemp<-paste(tempPrefix,runif(1),sep="")

  #split gff3withfasta to tmp-fasta and tmp-gff file.
  parsegff3WithSeq(inF=in_f,outGFF=outGFFtemp,outFASTA=outFASTAUGENE)
  #edit base position in tmp-gff file to tmp-ugene-gff file.
  modifyGFF4UGENE(toxoDBGFF=outGFFtemp, UGENEGFF=outGFFUGENE)
  #delete temp file
  file.remove(outGFFtemp)

  #read tmp-fasta file for genbank flatfile seq formatting
  fasta<-.readFASTA(outFASTAUGENE)
  #read tmp-ugene-gff file for genbank feature lists
  featureList<-.readGFF(outGFFUGENE)

  #write genbank file
  .writeGenbank(outfile=outGENBANK,fasta=fasta,featureList=featureList)
  cat(paste("Please use",outGENBANK," for UGENE. You can delete other files, if you want."))
}


#' inputGFF3OutputGenbank
#'
#' genbank file will be made.
#' output genbank file is ugene-compatible, may not be compatible for other software.
#' @param toxoDBGFF input file path
#' @export
#' @examples
#'
inputGFF3OutputGenbank<-function(toxoDBGFF){
  #FILE IO
  in_f<-toxoDBGFF
  cat(paste("start converting", in_f, "\n"))
  outGENBANK<-paste(in_f,".gb",sep="")

  genbank<-list(seq=c(),featureList=c())
  #get seq and feature from gff3
  genbank<-list(
    seq=.getFastaFromGFF3(inF=in_f),
    featureList=.getFeatureFromGFF3(inF=in_f)
    )

  if(is.null(genbank$featureList)) stop ("gff part missing")
  if(is.null(genbank$seq)) stop ("fasta part missing")
   #write genbank file
  .writeGenbank(outfile=outGENBANK,fasta=genbank$seq,featureList=genbank$featureList)
  cat(paste("Please use",outGENBANK," for UGENE."))
}


#' UI
#'
#' UI for inputGFF3OutputGenbank
#' @export
#'
UI<-function(){
  in_F<-c()
  cat("let's select gff3 input file (or any file in the directory where you want to run the batch conversion.")
  in_F<-file.choose()
  cat("only .gff3 files will be converted. please add .gff3 suffix to your target file, if not.")
  batch<-T
  if(readline("do you want to convert .gff3 files in the same directory? yes/no[yes ENTER] \n")=="no"){
    batch<-F
  }else{
  }
  if(batch){
    targetDir<-dirname(in_F)
    files<-paste(targetDir,dir(targetDir,pattern = "gff3$"),sep="/")
    cat("convert gff3 files...\n")
    cat(paste(files,"\n"))
    if(length(files)>1){
      sapply(files, inputGFF3OutputGenbank)
    }else if (length(files)==1){
      inputGFF3OutputGenbank(files)
    }
  }else{
    inputGFF3OutputGenbank(in_F)
  }
}


