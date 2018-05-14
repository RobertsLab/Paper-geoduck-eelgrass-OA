# Execute this script to prepare a .txt file listing  .mzML data files names

DIA.mzML.files <- list.files(path="data/DIA/2017-Geoduck-DIA-raw/", pattern="*.mzML")
write(DIA.mzML.files, file = "analyses/DIA/DNR_Geoduck_mzMLpath.txt",
      ncolumns = 1,
      append = FALSE, sep = " ")

