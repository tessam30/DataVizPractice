---
title: "StataTraining"
author: "Tim Essam"
date: "December 15, 2015"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r, echo = FALSE, message = FALSE}
require(knitr)
statapath <- "C:/Program Files (x86)/Stata14/StataSE-64.exe"
opts_chunk$set(engine="stata", engine.path=statapath, comment="")
```


You can also embed plots, for example:

```{r}
sysuse auto
gen gpm = 1/mpg
summarize price gpm
```
