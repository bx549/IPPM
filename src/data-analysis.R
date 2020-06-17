## scratch file for chapter on data analysis

Speed <- read.csv("../data/speed_gender_height.csv")
ggplot(Speed) + geom_boxplot(aes(x=gender, y=speed), na.rm=TRUE)

ggplot(Speed) + geom_point(aes(x=height, y=speed, color=gender), na.rm=TRUE)

fm <- lm(speed ~ height + gender, data = Speed)
summary(fm)


