
# PHASE = 1, 2, or 3. 3 is the average over 1 and 2.
library(BayesFactor)
library(psycho)
library(tidyverse)
#start with RM ANOVA (within= PHASE, btwn = CONDITION)

wider_Use = subset(wider,remove==0)
wider_Use = add_column(wider_Use,Partnum = c(1:82))
Baby_Bayes = wider_Use %>% pivot_longer(cols = c(face_O1, obj_O1, face_O2, obj_O2, face_T5, obj_T5, face_T6, obj_T6), names_to=c("face_obj", "ROI"), names_sep = "_", values_to = "BCA")
head(Baby_Bayes)
Baby_Bayes = add_column(Baby_Bayes,Occ_Temp=0,.after=6)
Baby_Bayes = add_column(Baby_Bayes,Left_Right=0,.after=7)
Baby_Bayes = Baby_Bayes %>% mutate(Occ_Temp = replace(Occ_Temp,ROI=='O1' | ROI=='O2', "Occ"))
Baby_Bayes = Baby_Bayes %>% mutate(Occ_Temp = replace(Occ_Temp,ROI=='T5' | ROI=="T6", "Temp"))
Baby_Bayes = Baby_Bayes %>% mutate(Left_Right = replace(Left_Right,ROI=='O1' | ROI=='T5', "Left"))
Baby_Bayes = Baby_Bayes %>% mutate(Left_Right = replace(Left_Right,ROI=='O2'| ROI=='T6', "Right"))
Baby_Bayes$face_obj = factor(Baby_Bayes$face_obj)
Baby_Bayes$Occ_Temp = factor(Baby_Bayes$Occ_Temp)
Baby_Bayes$Left_Right = factor(Baby_Bayes$Left_Right)
Baby_Bayes$Age = factor(Baby_Bayes$Age)
Anova(lm(BCA~ face_obj + Left_Right + Occ_Temp + Age + face_obj:Left_Right + face_obj:Age + face_obj:Occ_Temp + face_obj:Left_Right:Occ_Temp + face_obj:Left_Right:Occ_Temp:Age+ Left_Right:Age + Occ_Temp:Age + face_obj:Left_Right:Age + face_obj:Occ_Temp:Age + Left_Right:Occ_Temp + Left_Right:Occ_Temp:Age, data=Baby_Bayes), type="III")
Anova(lm(BCA~ face_obj + Left_Right + Occ_Temp + face_obj:Left_Right + face_obj:Occ_Temp + face_obj:Left_Right:Occ_Temp + Left_Right:Occ_Temp, data=TWELVE), type="III")

#Get exact same results as SPSS when I do this:
summary(aov(BCA~ face_obj*Occ_Temp*Left_Right + Error(part/(face_obj*Occ_Temp*Left_Right)), data = Adultpirate_Use))
#Get different results from SPSS when I do this:
tapply(Babypirate_Use$BCA,Babypirate_Use$Age, mean)
summary(aov(BCA~ face_obj*Occ_Temp*Left_Right*Age + Error(Partnum/(face_obj*Occ_Temp*Left_Right)), data = Baby_Bayes))
summary(aov(BCA~ face_obj*ROI + Error(part/(face_obj*ROI)), data = SIX))


Adultpirate_Use$face_obj = factor(Adultpirate_Use$face_obj)
Adultpirate_Use$Occ_Temp = factor(Adultpirate_Use$Occ_Temp)
Adultpirate_Use$Left_Right = factor(Adultpirate_Use$Left_Right)

bf = anovaBF(BCA~face_obj*Occ_Temp*Left_Right, data = Adultpirate_Use, whichModels="withmain",
             whichRandom="part", iterations = 100000)

bf = sort(bf, decreasing=TRUE)



bf1 = anovaBF(BCA ~ face_obj*Occ_Temp*Left_Right, data = Adultpirate_Use)
bf1

#create a new column where you've constrained face to equal obj
Adultpirate_Use$face.eq.obj = as.character(Adultpirate_Use$face_obj)
Adultpirate_Use$face.eq.obj[Adultpirate_Use$face_obj == "face"] = "face/obj"
Adultpirate_Use$face.eq.obj[Adultpirate_Use$face_obj == "obj"] = "face/obj"
Adultpirate_Use$face.eq.obj = factor(Adultpirate_Use$face.eq.obj)

bf2 = anovaBF(BCA ~ face.eq.obj*Occ_Temp*Left_Right, data = Adultpirate_Use)
bf2

bf_both_tests = c(bf1, bf2)
bf_both_tests

#determine how much better your constrained data is than the original data
bf_both_tests[2]/bf_both_tests[1]

AI_avg$INACC.eq.ACC = as.character(AI_avg$CONDITION)
AI_avg$INACC.eq.ACC[AI_avg$CONDITION == "INACC"] = "INACC/ACC"
AI_avg$INACC.eq.ACC[AI_avg$CONDITION == "ACC"] = "INACC/ACC"
AI_avg$INACC.eq.ACC = factor(AI_avg$INACC.eq.ACC)

bf3 = anovaBF(NOV_TEST~INACC.eq.ACC, data = AI_avg)
bf3

bf_both_tests = c(bf1, bf3)
bf_both_tests

bf_both_tests[1]/bf_both_tests[2]



## TRAIN phase Bayes
AI = read.csv("ACC2wide.csv")
AI_train = subset(AI, CONDITION != "DIST")
AI_train$TRAIN_AVG = as.numeric(as.character(AI_train$TRAIN_AVG))
AI_train$CONDITION = factor(AI_train$CONDITION)

ACC_train = subset(AI_train, CONDITION == "ACC")
INACC_train = subset(AI_train, CONDITION == "INACC")
WM_train = subset(AI_train, CONDITION == "WM")

tapply(AI_train$TRAIN_AVG, AI_train$CONDITION, mean)
tapply(AI_train$TRAIN_AVG, AI_train$CONDITION, sd)

#null model (ACC=INACC=WM compared to full ACC!=INACC!=WM)
bf4 = anovaBF(TRAIN_AVG ~ CONDITION, data = AI_train)
bf4

#create a new column where you've constrained INACC to equal WM
AI_train$INACC.eq.WM = as.character(AI_train$CONDITION)
AI_train$INACC.eq.WM[AI_train$CONDITION == "INACC"] = "INACC/WM"
AI_train$INACC.eq.WM[AI_train$CONDITION == "WM"] = "INACC/WM"
AI_train$INACC.eq.WM = factor(AI_train$INACC.eq.WM)

bf5 = anovaBF(TRAIN_AVG~INACC.eq.WM, data = AI_train)
bf5

bf_both_tests = c(bf4, bf5)
bf_both_tests

bf_both_tests[2]/bf_both_tests[1]

#Testing order hypotheses (our hypothesis is ACC>INACC=WM)
#for TRAIN
samples = posterior(bf4, iterations =100)
head(samples)

consistent = (samples[, "CONDITION-ACC"] > samples[, "CONDITION-INACC"]) &
        (samples[, "CONDITION-INACC"] = samples[, "CONDITION-WM"])
N_consistent = sum(consistent)
bf_restriction_against_full = (N_consistent/1000)/(1/6)
bf_restriction_against_full

## Convert bf4 to a number so that we can multiply it
bf_full_against_null = as.vector(bf4)
## Use transitivity to compute desired Bayes factor
bf_restriction_against_null = bf_restriction_against_full * bf_full_against_null
bf_restriction_against_null


#for TEST
samples = posterior(bf1, iterations =100)
head(samples)

consistent = (samples[, "CONDITION-ACC"] > samples[, "CONDITION-INACC"]) &
        (samples[, "CONDITION-INACC"] = samples[, "CONDITION-WM"])
N_consistent = sum(consistent)
bf_restriction_against_full = (N_consistent/1000)/(1/6)
bf_restriction_against_full

## Convert bf1 to a number so that we can multiply it
bf_full_against_null = as.vector(bf1)
## Use transitivity to compute desired Bayes factor
bf_restriction_against_null = bf_restriction_against_full * bf_full_against_null
bf_restriction_against_null
