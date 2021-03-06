#according to the http://rstudio.github.io/rstudioaddins/
#We have to start from making file inst/rstudio/addins.dcf in the package.
#open shell from project. Tools->Shell..
#$mkdir -p ./inst/rstudio
#$touch addins.dcf
name<-"\nName: GFF3toGenabnk"
description<-"Description: Convert ToxoDB GFF3 with seq to genbank format for UGENE."
binding<-"Binding: inputGFF3OutputGenbank"
interactive<-"Interactive: true"
addins<-c(name,description,binding,interactive)
write(x=addins,file="./inst/rstudio/addins.dcf",sep = "")

#welcom to Hadley's R dev world
install.packages("devtools")
install.packages("testthat")
#for documentation
install.packages("roxygen2")
library(devtools)
library(roxygen2)

#create EpDB2UG package in local directory and commit it.
pkgname = 'EpDB2UG'
title_desc = 'Utility to convert global gff from eupathdb to local annotation file'
github_repo = sprintf('https://github.com/Tasu/%s', pkgname)
devtools::create(pkgname, description=list(
  Package=pkgname,
  Title=title_desc,
  Description=paste0(title_desc, '.'),
  `Authors@R`="person('Ta.', 'Su.', email='ex@example.com', role=c('aut', 'cre'))",
  License='MIT + file',
  URL=github_repo,
  BugReports=paste0(github_repo, '/issues'))
)
devtools::check(pkgname)

#install in local #for test
setwd("..")
getwd()
devtools::install("EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)
#uninstall
detach("package:EpDB2UG", unload = T)
remove.packages("EpDB2UG")
library(EpDB2UG)#this should give you error message 'there is no package called....'
#test installing from github
devtools::install_github("Tasu/EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)

#git commands
#first commit. can we do this form RStudio with GUI?
$echo "# EpDB2UG" >> README.md
$git init
$git add README.md
$git commit -m "first commit"
$git remote add origin https://github.com/Tasu/EpDB2UG.git
$git push -u origin master

#if you forget to switch branch from master to dev...
#don't worry, you can add -b option
$git checkout -b dev
$git push -u origin dev

#to close the branch
$git checkout master
$git merge dev
$git branch -d dev
