#testthat test
context(getwd())
#####
test_that("toxodb2ugene normal function for refactoring", {
  checksumExpect<-md5sum("./testdata/expect/testTGME49_chrX_1032284_1067339.gff3.gb")
  #test
  toxodb2ugene("./testdata/input/testTGME49_chrX_1032284_1067339.gff3")
  checksupTest<-md5sum("./testdata/input/testTGME49_chrX_1032284_1067339.gff3.gb")
  file.remove("./testdata/input/testTGME49_chrX_1032284_1067339.gff3.gb")
  expect_that(checksupTest, equals(checksumExpect))
})
