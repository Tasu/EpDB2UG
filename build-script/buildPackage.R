#make package of your own
# install.packages("devtools")
library("devtools")
#for documentation
devtools::install_github("klutometis/roxygen")
library(roxygen2)
document()#or run build source Packages from the RStudio

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

#locate source in R directory

#create document
setwd("./EpDB2UG")
document()

#install in local #for test
setwd("..")
install("EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)
detach("package:EpDB2UG", unload = T)
remove.packages("EpDB2UG")
library(EpDB2UG)#this should give you error message 'there is no package called....'
#you can manage version control from RStudio->Tools->Version control.

#git command for first command
#echo "# EpDB2UG" >> README.md
#git init
#git add README.md
#git commit -m "first commit"
#git remote add origin https://github.com/Tasu/EpDB2UG.git
#git push -u origin master

#test installing from github
devtools::install_github("Tasu/EpDB2UG")
library(EpDB2UG)
help(package = EpDB2UG)
