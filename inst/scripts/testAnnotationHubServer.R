## So this is what I did to get it running (as root)
## sudo -s
## cd /var/FastRWeb/code
## killall -INT Rserve # if Rserve is already running
## ./start


#############################################################################
## Here is code to start up AnnotationHub client as pointed to temp-server.

options(AnnotationHub.debug=TRUE) # print debug messages
options(AnnotationHub.Host="http://gamay") # use gamay as our server
library(AnnotationHub)
ah <- AnnotationHub()
## mall <- metadata(ah)





### To test from within R
library(AnnotationHubServer)
res <- getAllResourcePaths(BiocVersion="2.14", RDataDateAdded="2013-06-28")
library(rjson)
res2 <- fromJSON(res[[2]])
head(res2)



## test to make sure that a URL is being processed correctly:
l <- AnnotationHubServer:::getUrl("/ah/2.14/2013-06-28/query/cols/Title/cols/Species/cols/TaxonomyId/cols/Genome/cols/Description/cols/Tags/cols/RDataClass/cols/RDataPath")
l

ret <- do.call(l$fun, l$params)
obj <- fromJSON(ret[[2]])
cd .





### MORE debugging? (after putting a file in correct place)

## debug(AnnotationHub:::.getResource)
## debug(AnnotationHub:::.parseJSONMetadataList)
## foo = ah$dbSNP.organisms.human_9606.VCF.ByChromosome.22.12157.CHB.RData



## problem now lies with .metadata() in AnnotationHub client?  1) I need to better handle cases with only one record comes back (not turn them sideways), 2) I need to have the code in .getResource grab only the column that matters and 3) I need to visit all places where .metadata() is called so that it always does the right thing (is called in right way).

## test code
options(AnnotationHub.debug=TRUE) # print debug messages
options(AnnotationHub.Host="http://gamay") # use gamay as our server
library(AnnotationHub)
ah <- AnnotationHub()
## one item:
name <- "dbSNP.organisms.human_9606.VCF.ByChromosome.22.12157.CHB.RData"
path <- snapshotPaths(ah)[name] 
m1 <- AnnotationHub:::.metadata(snapshotUrl(ah),filters=list(RDataPath=path),cols="RDataClass")
## right now I get THREE things back, and I only aim to get one.
## ALSO: I need for that thing to NOT be sideways.

m2 <- AnnotationHub:::.metadata(snapshotUrl(ah),filters=list(RDataPath=path),cols=c("RDataClass","Species"))

m2many <- AnnotationHub:::.metadata(snapshotUrl(ah),cols=c("RDataClass","Species")) ## makes a matrix...


## 1st lets see if we are supposed to get three things back (why are SourceUrl and RDataDateAdded being added back in every time? - FIXED.
## 2nd lets change our DataFrame code so that it does the right thing when there is one record...


## ms <- metadata(ah, cols="RDataClass")













##############################################################################
## minimal files to support
##############################################################################


## goldenpath.hg19.encodeDCC.wgEncodeUwTfbs.wgEncodeUwTfbsMcf7CtcfStdPkRep1.narrowPeak_0.0.1.RData

## goldenpath.hg19.database.oreganno_0.0.1.RData


## move them from
## cd /var/FastRWeb/web
## on
## ssh ubuntu@annotationhub.bioconductor.org
## to the same dir on gamay (with the same path etc.)

## Then change permissions as needed
## sudo chgrp -R rusers /var/FastRWeb/web
