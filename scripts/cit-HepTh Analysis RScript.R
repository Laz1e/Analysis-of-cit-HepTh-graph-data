#abstract file
readLines("./data/cit-HepTh-abstracts.tar.gz", n = 50)

#dates file
readLines("./data/cit-HepTh-dates.txt.gz", n = 50)

# nodes and edges file
readLines("./data/cit-HepTh.txt.gz", n = 50)

# Loading the citation network
citations <- read.table("./data/cit-HepTh.txt.gz", comment.char = "#", col.names = c("From", "To"))

# Loading the publication dates
dates <- read.table("./data/cit-HepTh-dates.txt.gz", col.names = c("PaperId", "Dates"))

# Extracting abstracts into a seperate folder
untar("./data/cit-HepTh-abstracts.tar.gz", exdir = "abstract_data")

