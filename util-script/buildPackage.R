#make package of your own
# install.packages("devtools")
library("devtools")
#for documentation
devtools::install_github("klutometis/roxygen")
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
  License='MIT',
  URL=github_repo,
  BugReports=paste0(github_repo, '/issues'))
)
devtools::check(pkgname)

#create document
setwd("./EpDB2UG")
devtools::document()

#install in local #for test
setwd("..")
getwd()
devtools::install("EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)
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

#to close the branch
$git checkout master
$git merge dev
$git branch -d dev
