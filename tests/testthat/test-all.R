#testthat test
context(paste("test for refactoring, output file should be consistent, test working dir is", getwd()))
cat("\nloading \"tools\" package for md5sum\n")
library(tools)#for md5 check, only for testthat
#####
test_that("legacy", {
  input<-"./testdata/input/"
  checksumExpect<-md5sum(files = "./testdata/expect/testTGME49_chrX_1032284_1067339.gff3.gb")
  #test
  toxodb2ugene("./testdata/input/testTGME49_chrX_1032284_1067339.gff3")
  checksupTest<-md5sum("./testdata/input/testTGME49_chrX_1032284_1067339.gff3.gb")
  fs<-dir(input)
  fs<-paste(input,fs[!grepl("gff3$",fs)],sep="")
  file.remove(fs)
  expect_that(as.character(checksupTest[1]), equals(as.character(checksumExpect[1])))
})

test_that("no temp file", {
  input<-"./testdata/input/"
  checksumExpect<-md5sum(files = "./testdata/expect/testTGME49_chrX_1032284_1067339.gff3.gb")
  #test
  inputGFF3OutputGenbank("./testdata/input/testTGME49_chrX_1032284_1067339.gff3")
  checksupTest<-md5sum("./testdata/input/testTGME49_chrX_1032284_1067339.gff3.gb")
  fs<-dir(input)
  fs<-paste(input,fs[!grepl("gff3$",fs)],sep="")
  file.remove(fs)
  expect_that(as.character(checksupTest[1]), equals(as.character(checksumExpect[1])))
})
