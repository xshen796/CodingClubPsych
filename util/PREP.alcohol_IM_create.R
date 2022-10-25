library(dplyr)
data <- readRDS("/sdata/images/projects/UKBIOBANK/users/Shen/i.IDP_UKB_nonGenetic/IDP_4thrls_20k/2018-10-phenotypes-ukb24262/Touchscreen.rds")

#alcohol <- data[,c(1,34,204,36,38,40,42,44,300,242,244,246,248,250,252,35,205,243,37,245,39,247,41,249,43,251,45,253,301)]
alcohol =  
      data %>%
      select(f.eid,
             starts_with("f.1568."),starts_with('f.1578.'),starts_with('f.1588.'),
             starts_with('f.1598.'),starts_with('f.5364.'),starts_with('f.1608.'),
             starts_with('f.4407.'),starts_with('f.4418.'),starts_with('f.4429.'),
             starts_with('f.4440.'),starts_with('f.4451.'),starts_with('f.4462.')
      )
# change -3 and -1, prefer not to answer and don't know to NA in no. of glasses of alcohol
alcohol$f.1568.2.0[alcohol$f.1568.2.0=="-1" | alcohol$f.1568.2.0=="-3"]<-NA
alcohol$f.1578.2.0[alcohol$f.1578.2.0=="-1" | alcohol$f.1578.2.0=="-3"]<-NA
alcohol$f.1588.2.0[alcohol$f.1588.2.0=="-1" | alcohol$f.1588.2.0=="-3"]<-NA
alcohol$f.1598.2.0[alcohol$f.1598.2.0=="-1" | alcohol$f.1598.2.0=="-3"]<-NA
alcohol$f.5364.2.0[alcohol$f.5364.2.0=="-1" | alcohol$f.5364.2.0=="-3"]<-NA
alcohol$f.1608.2.0[alcohol$f.1608.2.0=="-1" | alcohol$f.1608.2.0=="-3"]<-NA
alcohol$f.4407.2.0[alcohol$f.4407.2.0=="-1" | alcohol$f.4407.2.0=="-3"]<-NA
alcohol$f.4418.2.0[alcohol$f.4418.2.0=="-1" | alcohol$f.4418.2.0=="-3"]<-NA
alcohol$f.4429.2.0[alcohol$f.4429.2.0=="-1" | alcohol$f.4429.2.0=="-3"]<-NA
alcohol$f.4440.2.0[alcohol$f.4440.2.0=="-1" | alcohol$f.4440.2.0=="-3"]<-NA
alcohol$f.4451.2.0[alcohol$f.4451.2.0=="-1" | alcohol$f.4451.2.0=="-3"]<-NA
alcohol$f.4462.2.0[alcohol$f.4462.2.0=="-1" | alcohol$f.4462.2.0=="-3"]<-NA



# calculate total units
alcohol$weekly_rw <- alcohol$f.1568.2.0*1.67
alcohol$weekly_ww <- alcohol$f.1578.2.0*1.67
alcohol$weekly_pint <- alcohol$f.1588.2.0*2.3
alcohol$weekly_sp <- alcohol$f.1598.2.0*1
alcohol$weekly_other <- alcohol$f.5364.2.0*1.1
alcohol$weekly_fw <- alcohol$f.1608.2.0*2.25

alcohol$units_week <- rowSums(alcohol[,grep('^weekly_',colnames(alcohol))], na.rm=T)


alcohol$monthly_rw <- alcohol$f.4407.2.0*1.67
alcohol$monthly_ww <- alcohol$f.4418.2.0*1.67
alcohol$monthly_pint <- alcohol$f.4429.2.0*2.3
alcohol$monthly_sp <- alcohol$f.4440.2.0*1
alcohol$monthly_other <- alcohol$f.4462.2.0*1.1
alcohol$monthly_fw <- alcohol$f.4451.2.0*2.25

alcohol$units_month <- rowSums(alcohol[,grep('^monthly_',colnames(alcohol))], na.rm=T)
alcohol$units_weekfrommonth <- alcohol$units_month/4.25

alcohol$units_combined <- rowSums(alcohol[,c(44,52)],na.rm=T)


# set all former drinkers to NA in units weekly, monthly and combined
alcohol$units_week[alcohol$f.3731.2.0=="Yes"]<-NA
alcohol$units_month[alcohol$f.3731.2.0=="Yes"]<-NA
#alcohol$units_combined[alcohol$f.3731.2.0=="Yes"]<-NA


# remove impossible values
# mean units_combined from wave 1 = 14.57 (17.41) [ greater than 5 s.d. from mean = 101.62 units/week]
# mean units_combined from wave 2 = 13.70 (15.03) [ greather than 5 s.d. from mean = 88.85 units/week]
alcohol$units_week_clean <- alcohol$units_combined
alcohol$units_week_clean[alcohol$units_combined > 101.62]<-NA

saveRDS(alcohol,file='data/behav/alcohol_phenotype_IM.rds')
