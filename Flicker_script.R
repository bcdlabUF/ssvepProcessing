setwd("/Volumes/Ryan Data/FLICKER/BEES flicker/")
Baby = read.csv("Baby_BCA_PRE_March2020.csv")
head(Baby)
### Control + Shift + M to insert %>% ###
### Option + - to insert  <-  ###

library(tidyr)
library(magrittr)
library(dplyr)
library(readr)
library(tidyverse)
library(ggpubr)

#create ROIs
Baby$OZ = rowMeans(Baby[c('X74','X75','X82')])
Baby$O1 = rowMeans(Baby[c('X69','X70','X65')])
Baby$O2 = rowMeans(Baby[c('X90','X83','X89')])
Baby$T5 = rowMeans(Baby[c('X58','X59','X64')])
Baby$T6 = rowMeans(Baby[c('X91','X95','X96')])


#create new df without all of the electrodes
BabyROI = Baby[,c(1:4, 114:118)]
head(BabyROI)

# pivot from wide to Long
Long = BabyROI %>% pivot_longer(cols = c(OZ,O1,O2,T5,T6), names_to = "ROI", values_to = "BCA")
head(Long)

# pivot back to wide
wider = Long %>% pivot_wider(names_from=c(face_obj, ROI), values_from=BCA)
head(wider)

# mark the outliers.
wider =add_column(wider, Outlier = 0, .after=4)
wider = wider %>% mutate(Outlier = replace(Outlier,(part==192 & Age==12) | (part==141 & Age==6) | (part==115) | part==155,1))

#remove the outliers
wider = subset(wider,Outlier==0)

#save this data to a csv file that can be used in Spss
write.csv(wider,"Baby_BCA_March2020_spss.csv")



# Analysis ----------------------------------------------------------------

library(yarrr)
dev.off()
par(family="sans")
library(RColorBrewer)
library(afex)
library(emmeans)

# pivot back to long format so you can do analyses
BabyLong = wider %>% pivot_longer(cols = c(face_OZ, face_O1, face_O2, face_T5, face_T6, obj_OZ, obj_O1, obj_O2, obj_T5, obj_T6), names_to=c("face_obj", "ROI"), names_sep = "_", values_to = "BCA")
head(BabyLong)

# ANOVA using same settings as SPSS
Baby_afex <- aov_car(BCA ~ CB*Age*face_obj*ROI + Error(part/face_obj*ROI), data=BabyLong, anova_table = list(es = "pes"))
Baby_afex

# ADULT -------------------------------------------------------------------

setwd("/Volumes/Ryan Data/FLICKER/BEES Adult flicker .set/")
Adult = read.csv("Adult_BCA_PRE_Oct2019.csv")
head(Adult)


#create ROIs



Adult$OZ = rowMeans(Adult[c('X74','X75','X82')])
Adult$O1 = rowMeans(Adult[c('X69','X70','X65')])
Adult$O2 = rowMeans(Adult[c('X90','X83','X89')])
Adult$T5 = rowMeans(Adult[c('X58','X59','X64')])
Adult$T6 = rowMeans(Adult[c('X91','X95','X96')])

#create new df without all of the electrodes
AdultROI = Adult[,c(1:3, 133:137)]
head(AdultROI)

library(tidyr)
library(magrittr)
library(dplyr)
library(readr)
library(tidyverse)


Long = AdultROI %>% pivot_longer(cols = c(OZ,O1,O2,T5,T6), names_to = "ROI", values_to = "BCA")
head(Long)

wider = Long %>% pivot_wider(names_from=c(face_obj, ROI), values_from=BCA)
head(wider)


write.csv(wider,"Adult_BCA_PRE_wide_Oct.csv")


# pirate plot -------------------------------------------------------------
library(yarrr)
dev.off()
par(family="sans")
library(RColorBrewer)

#pivot to long format for plotting
Babypirate = wider %>% pivot_longer(cols = c(face_OZ, face_O1, face_O2, obj_OZ, obj_O1, obj_O2), names_to=c("face_obj", "ROI"), names_sep = "_", values_to = "BCA")
head(Babypirate)

#change the names of the ROIs so they'll plot in the correct order
Babypirate = Babypirate %>% mutate(ROI = replace(ROI,ROI=='T5', 'aT5'))
Babypirate = Babypirate %>% mutate(ROI = replace(ROI,ROI=='O1', 'bO1'))
Babypirate = Babypirate %>% mutate(ROI = replace(ROI,ROI=='OZ', 'cOZ'))
Babypirate = Babypirate %>% mutate(ROI = replace(ROI,ROI=='O2', 'dO2'))
Babypirate = Babypirate %>% mutate(ROI = replace(ROI,ROI=='T6', 'eT6'))

#average over ROI to plot face vs object
NoROI = group_by(Babypirate,part,Age,face_obj) %>% summarise(mean = mean(BCA))

#subset by age
six = susbet(Babypirate, Age==6)
nine = susbet(Babypirate, Age==9)
twelve = subset(Babypirate, Age==12)

#Create averages to plot the main effect of ROI
six_ROI = group_by(six,part,ROI) %>% summarise(mean = mean(BCA))
nine_ROI = group_by(nine,part,ROI) %>% summarise(mean = mean(BCA))
twelve_ROI = group_by(twelve,part,ROI) %>% summarise(mean = mean(BCA))

#Create averages to plot the counterbalance x face_obj interaction
six_CB = group_by(six, part, CB, face_obj) %>% summarise(mean = mean(BCA))
nine_CB = group_by(nine, part, CB, face_obj) %>% summarise(mean = mean(BCA))
twelve_CB = group_by(twelve, part, CB, face_obj) %>% summarise(mean = mean(BCA))

pirateplot(formula = mean ~ face_obj + Age,
           data=NoROI,
           main = 'face_obj x Age',
           theme= 5,  # Start with theme 2
           #pal = c("#f1a340",  "#998ec3"),
           pal = c("#d00101",  "#0006c3"),
           #pal = c("#0072BD", "#4daf4a"),
           ylim=c(-.2, 0.9),
           ylab = "BCA",
           inf.method = 'ci',
           inf.f.o = 0.25, # Turn off inf fill
           inf.b.o = 1, # Turn off inf border
           point.o = 1,   # Turn up points
           bar.f.o = 1, # Turn up bars
           bar.b.o = 0,
           bean.f.o = .5, # Light bean filling
           bean.b.o = 1, # Light bean border
           avg.line.o = 1, # Turn off average line
           point.cex=1,
           jitter.val = .1
)




pirateplot(formula = mean ~ ROI,
           data=six_ROI,
           main = '6 months ROI',
           theme= 1,  # Start with theme 2
           pal = c("#a6cee3",  "#1f78b4", "#b2df8a", '#33a02c', '#fb9a99'),
           ylim=c(-.3, 1),
           ylab = "BCA",
           inf.method = 'ci',
           inf.f.o = 0.25, # Turn off inf fill
           inf.b.o = 1, # Turn off inf border
           point.o = 1,   # Turn up points
           bar.f.o = 1, # Turn up bars
           bar.b.o = 0,
           bean.f.o = .5, # Light bean filling
           bean.b.o = 1, # Light bean border
           avg.line.o = 1, # Turn off average line
           point.cex=1,
           jitter.val = .1
)



# Adult pirate ------------------------------------------------------------
wider =add_column(wider, Outlier = 0, .after=2)
wider = wider %>% mutate(Outlier = replace(Outlier,part == 313,1))

wider = subset(wider,Outlier==0)
widerAdult=wider
Adultpirate = widerAdult %>% pivot_longer(cols = c(face_OZ,obj_OZ,face_O1, obj_O1, face_O2, obj_O2, face_T5, obj_T5, face_T6, obj_T6), names_to=c("face_obj", "ROI"), names_sep = "_", values_to = "BCA")
head(Adultpirate)

Adultpirate = Adultpirate %>% mutate(ROI = replace(ROI,ROI=='T5', 'aT5'))
Adultpirate = Adultpirate %>% mutate(ROI = replace(ROI,ROI=='O1', 'bO1'))
Adultpirate = Adultpirate %>% mutate(ROI = replace(ROI,ROI=='OZ', 'cOZ'))
Adultpirate = Adultpirate %>% mutate(ROI = replace(ROI,ROI=='O2', 'dO2'))
Adultpirate = Adultpirate %>% mutate(ROI = replace(ROI,ROI=='T6', 'eT6'))

face = subset(Adultpirate, face_obj=="face")
obj = subset(Adultpirate, face_obj=="obj")

pirateplot(formula = BCA ~ ROI,
           data=face,
           main = 'Adults faces',
           theme= 5,  # Start with theme 2
           #pal = c("#f1a340",  "#998ec3"),
           pal = c("#a6cee3",  "#1f78b4", "#b2df8a", '#33a02c', '#fb9a99'),
           #pal = c("#0072BD", "#4daf4a"),
           ylim=c(-.2, 1),
           ylab = "BCA",
           inf.method = 'ci',
           inf.f.o = 0.25, # Turn off inf fill
           inf.b.o = 1, # Turn off inf border
           point.o = 1,   # Turn up points
           bar.f.o = 1, # Turn up bars
           bar.b.o = 0,
           bean.f.o = .5, # Light bean filling
           bean.b.o = 1, # Light bean border
           avg.line.o = 1, # Turn off average line
           point.cex=1,
           jitter.val = .1
)



# freq --------------------------------------------------------------------
# Use this section to create freq x Counterbalance plots

Baby = read.csv("Baby_BCA_PRE_March2020.csv")
head(Baby)
### Control + Shift + M to insert %>% ###
### Option + - to insert  <-  ###

#create ROIs

Baby$OZ = rowMeans(Baby[c('X74','X75','X82')])
Baby$O1 = rowMeans(Baby[c('X69','X70','X65')])
Baby$O2 = rowMeans(Baby[c('X90','X83','X89')])
Baby$T5 = rowMeans(Baby[c('X58','X59','X64')])
Baby$T6 = rowMeans(Baby[c('X91','X95','X96')])

#create new df without all of the electrodes
BabyROI = Baby[,c(1:4, 114:118)]
head(BabyROI)

BabyROI =add_column(BabyROI, Freq = 5, .after=4)
BabyROI = BabyROI %>% mutate(Freq = replace(Freq,(CB== 'CB1' & face_obj=='face') | (CB =='CB2' & face_obj=='obj'), 6))

BabyROI %>% group_by(face_obj) %>% tally()

Long = BabyROI %>% pivot_longer(cols = c(OZ,O1,O2,T5,T6), names_to = "ROI", values_to = "BCA")
head(Long)

Long = subset(Long, select = -face_obj)

wider = Long %>% pivot_wider(names_from=c(Freq, ROI), values_from=BCA)
head(wider)

wider =add_column(wider, Outlier = 0, .after=3)
wider = wider %>% mutate(Outlier = replace(Outlier,(part==192 & Age==12) | (part==141 & Age==6) | (part==115) | part==155,1))

wider = subset(wider,Outlier==0)

BabyLong = wider %>% pivot_longer(cols = c('6_OZ', '6_O1', '6_O2', '6_T5', '6_T6', '5_OZ', '5_O1', '5_O2', '5_T5', '5_T6'), names_to=c("freq", "ROI"), names_sep = "_", values_to = "BCA")
head(BabyLong)

NoROI = group_by(BabyLong,part,Age,freq, CB) %>% summarise(mean = mean(BCA))
head(NoROI)

Six = subset(NoROI, Age==6)
head(Six)

Twelve = subset(NoROI, Age==12)
head(Twelve)
CB1_12 = subset(NoROI, CB=='CB1')
CB2_12 = subset(NoROI, CB=='CB2')
t.test(CB1_12$mean~CB1_12$freq)
t.test(CB2_12$mean~CB2_12$freq)


pirateplot(formula = mean ~ freq + CB + Age,
           data=NoROI,
           main = 'Freq x CB',
           theme= 1,  # Start with theme 2
           pal = c("#9D4479",  "#ADB9BA"),
           ylim=c(-.2, 0.8),
           ylab = "BCA",
           inf.method = 'ci',
           inf.f.o = 0.25, # Turn off inf fill
           inf.b.o = 1, # Turn off inf border
           point.o = 1,   # Turn up points
           bar.f.o = 1, # Turn up bars
           bar.b.o = 0,
           bean.f.o = .5, # Light bean filling
           bean.b.o = 1, # Light bean border
           avg.line.o = 1, # Turn off average line
           point.cex=2,
           jitter.val = .1
)
