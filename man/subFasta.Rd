% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fasta-gff-io.R
\name{subFasta}
\alias{subFasta}
\title{subFasta}
\usage{
subFasta(gLocus = list(chr = "", start = 0, end = 0, complement = F),
  fasta = "filepath")
}
\arguments{
\item{gLocus}{genome locus list(start=0, end=0, complement=F)}

\item{multi}{character vectors}
}
\description{
return subregion of an input fasta as a seq object
seq(name="CHR_START_END",seq="ATGC...")
}
\examples{

}

