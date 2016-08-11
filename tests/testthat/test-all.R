#testthat test
context(getwd())
#####
#file output should be separated from package function.
#package function will be modified to return file object only.
#Or split function to make object and write file.
#making object can be tested easily.
test_that("toxodb2ugene normal function", {
  #expect_that(toxodb2ugene("./testdata/input/testTGME49_chrX_1032284_1067339.gff3"), equals(1))
})
test_that("toxodb2ugene input file error", {
})
test_that("toxodb2ugene input file format error", {
})
test_that("toxodb2ugene output file error", {
})
