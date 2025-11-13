if (!require("readxl")) {
  install.packages("readxl", repos="https://cloud.r-project.org/")
  library(readxl)
}
patients <- read_excel("Пациенты.xlsx")
head(patients)
str(patients)  

# =========================
# 1
str(patients[, c("Возраст", "глюкоза")])

# =========================
# 2
patients$Пол <- factor(patients$Пол, levels = c("м", "ж"))
levels(patients$Пол)

# =========================
# 3
patients$возраст_группа_2 <- ifelse(patients$Возраст <= 60, "Молодые", "Старшие")
patients$возраст_группа_2 <- factor(patients$возраст_группа_2, 
                                    levels = c("Молодые","Старшие"))

# =========================
# 4
subset(patients, Возраст > 75)

# =========================
# 5
head(patients[, c("лейкоциты", "глюкоза")])
summary(patients[, c("лейкоциты", "глюкоза")])

# =========================
# 6
aggregate(глюкоза ~ Пол, data = patients, FUN = mean, na.rm = TRUE)

# =========================
# 7
aggregate(лейкоциты ~ Пол + возраст_группа_2, data = patients, FUN = mean, na.rm = TRUE)

# =========================
# 8
gluc_stats <- aggregate(глюкоза ~ Пол, data = patients,
                        FUN = function(x) c(mean = mean(x, na.rm=TRUE),
                                            sd   = sd(x,   na.rm=TRUE),
                                            n    = sum(!is.na(x))))
gluc_stats <- do.call(data.frame, gluc_stats)
names(gluc_stats) <- c("Пол", "глюкоза_срзнач", "глюкоза_стоткл", "глюкоза_колво")
gluc_stats

# =========================
# 10
# Создаем график и сохраняем в файл
png("глюкоза_по_полу.png")
boxplot(глюкоза ~ Пол, data = patients,
        main = "Распределение глюкозы в зависимости от пола",
        xlab = "Пол", ylab = "глюкоза")
dev.off()
cat("График сохранен в глюкоза_по_полу.png\n")

# =========================
# 11
# H0: ср уровень лейкоцитов у мужчин == ср уровень лейкоцитов у женщин
# HA: ср уровень лейкоцитов у мужчин != ср уровень лейкоцитов у женщин
t_test <- t.test(лейкоциты ~ Пол, data = patients)
t_test
# p-value < 0.05 => отклоняем H0 т.е. различия значимы

# =========================
patients_task <- patients
patients_task$глюкоза[c(3, 15, 45)] <- NA

# =========================
# 12
sum(is.na(patients_task))

# =========================
# 13
which(is.na(patients_task$глюкоза))

# =========================
# 14
patients_no_na <- na.omit(patients_task)
dim(patients_task); dim(patients_no_na)

# =========================
# 15
m <- median(patients_task$глюкоза, na.rm = TRUE)
patients_task$глюкоза[is.na(patients_task$глюкоза)] <- m

# =========================
# 16
x  <- tapply(patients_task$лейкоциты,  patients_task$Пол,  mean, na.rm = TRUE)
y <- tapply(patients_no_na$лейкоциты, patients_no_na$Пол, mean, na.rm = TRUE)
x
y

# =========================
# 17
stats <- aggregate(гемоглобин ~ возраст_группа_2, data = patients, 
                        FUN = function(x) c(mean = mean(x, na.rm=TRUE),
                                            sd   = sd(x,   na.rm=TRUE)))
final_result <- do.call(data.frame, stats)
names(final_result) <- c("Возрастная_группа", "Гемоглобин_среднее_значение", "Гемоглобин_стандартное_отклонение")
final_result

# =========================
# 18
write.csv(final_result, file = "анализ_гемоглобина.csv", row.names = FALSE)