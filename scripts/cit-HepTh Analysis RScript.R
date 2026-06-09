# Extracting abstracts into a seperate folder
untar("./data/cit-HepTh-abstracts.tar.gz", exdir = "abstract_data")

dates <- read.csv("./data/hep-th-slacdates.tar.gz",
                  sep = "",
                  header = F,
                  skip = 1,
                  colClasses = c("character", "character"))

names(dates) <- c("paperId", "date")

citations <- read.csv("./data/hep-th-citations.tar.gz",
                      sep = "", 
                      header = F,
                      skip = 1,
                      colClasses = c("character", "character"))

names(citations) <- c("From", "To")



################################################################################################
# Script which checks how many paper metadata is present in abstract folder.

# 1. Define the path to your main abstracts directory
# (R handles subdirectories automatically if we set recursive = TRUE)
abs_dir <- "abstract_data/" 

# 2. List all files ending in .abs across all subfolders
all_abs_files <- list.files(path = abs_dir, 
                            pattern = "\\.abs$", 
                            recursive = TRUE, 
                            full.names = FALSE)

# 3. Clean the file names to get raw Paper IDs
# This extracts just the filename (e.g., "9503122") regardless of what year-folder it is in
abs_paper_ids <- tools::file_path_sans_ext(basename(all_abs_files))
abs_paper_ids <- unique(as.character(abs_paper_ids))

# 4. Use your existing code to get the 16,329 problem nodes
all_edge_nodes <- unique(c(as.character(citations$From), as.character(citations$To)))
vertices_nodes <- as.character(dates_clean2$PaperId)
problem_nodes <- setdiff(all_edge_nodes, vertices_nodes)

# 5. CROSS-REFERENCE: How many problem nodes actually exist in the abs folder?
found_in_abs <- intersect(problem_nodes, abs_paper_ids)
still_missing_completely <- setdiff(problem_nodes, abs_paper_ids)

# 6. Print the Audit Summary
cat("--- ABSTRACT FOLDER AUDIT RESULTS ---\n")
cat("Total offending nodes causing the crash:       ", length(problem_nodes), "\n")
cat("Nodes successfully FOUND in the .abs folders:  ", length(found_in_abs), "\n")
cat("Nodes completely missing from files and folders: ", length(still_missing_completely), "\n\n")

if(length(found_in_abs) > 0) {
  cat("Sample of problem nodes verified to exist as .abs files:\n")
  print(head(found_in_abs, 10))
}

