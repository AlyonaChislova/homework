motifs2 <- matrix(c(
  "a", "C", "g", "G", "T", "A", "A", "t", "t", "C", "a", "G",
  "t", "G", "G", "G", "C", "A", "A", "T", "t", "C", "C", "a",
  "A", "C", "G", "t", "t", "A", "A", "t", "t", "C", "G", "G",
  "T", "G", "C", "G", "G", "G", "A", "t", "t", "C", "C", "C",
  "t", "C", "G", "a", "A", "A", "A", "t", "t", "C", "a", "G",
  "A", "C", "G", "G", "C", "G", "A", "a", "t", "T", "C", "C",
  "T", "C", "G", "t", "G", "A", "A", "t", "t", "a", "C", "G",
  "t", "C", "G", "G", "G", "A", "A", "t", "t", "C", "a", "C",
  "A", "G", "G", "G", "T", "A", "A", "t", "t", "C", "C", "G",
  "t", "C", "G", "G", "A", "A", "A", "a", "t", "C", "a", "C"
), nrow = 10, byrow = TRUE)

print(motifs2)

motifs2 <- toupper(motifs2)

print(motifs2)

count_matrix <- apply(
  motifs2, 2,
  function(col) table(factor(col, levels = c("A","C","G","T")))
)
count_matrix <- as.matrix(count_matrix)

print(count_matrix)

profile_matrix <- count_matrix / nrow(motifs2)

print(profile_matrix)

scoreMotifs <- function(matrix) {
  counts <- apply(matrix, 2, function(col) table(factor(col, levels = c("A","C","G","T"))))
  counts <- as.matrix(counts)
  sum(nrow(matrix) - apply(counts, 2, max))
}

score <- scoreMotifs(motifs2)

print(score)

getConsensus <- function(matrix) {
  counts <- apply(matrix, 2, function(col) table(factor(col, levels = c("A","C","G","T"))))
  counts <- as.matrix(counts)
  i <- apply(counts, 2, which.max)
  consensus <- c("A","C","G","T")[i]
  paste0(consensus, collapse = "")
}

consensus <- getConsensus(motifs2)

print(consensus)

barplot(count_matrix[,1],
        col  = "skyblue",
        main = "Частоты нуклеотидов в 1-м столбце",
        xlab = "Нуклеотид", ylab = "Частота", ylim = c(0, nrow(motifs2)))
