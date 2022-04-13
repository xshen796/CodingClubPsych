# Models with nested, random effects

## Background

- GLMM model recommended by ABCD: [http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html](http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html)
- Get p values from nested random effect models:

[https://github.com/runehaubo/lmerTestR](https://github.com/runehaubo/lmerTestR)

- Protocol paper for ABCD analysis: [https://www.biorxiv.org/content/10.1101/2020.02.10.942011v1.full](https://www.biorxiv.org/content/10.1101/2020.02.10.942011v1.full)

## Summary & caution

- It is tricky to get p-values for a model with multiple, nested random effects. The p-values may vary, depending on how degree of freedom (DF) is defined. There are various of ways of approaching this issue, but the uncertainty of df should have little impact if the N is massive.
- The package *lmerTestR* is one of the solutions. See its reference paper for more stats and descriptions. It is selected because of its simplicity: 1) built on an established R package â€˜lme4â€™, 2) doesnâ€™t require additional packages and 3) gives simple outputs that are similar to fixed effect glm models.
- Note that running models with multiple, nested random factors can easily have model convergence issues.

## Example scripts

- Main models: testing the association between insular volume and parental dep (ASR)
    
    ```jsx
    library(dplyr)
    library(lmerTest)
    
    ### testing the association between right hemisphere insular volume and ASR dep (short-format data)
    gm1 <- lmer(rh.vol.APARC.insula~age_years+asr_scr_depress_r+(1 | rel_family_id/scanner_id)+(1 | scanner_id), data = targetdata,na.action=na.exclude)
    summary(gm1)
    
    ### testing the association between insular volume and ASR dep, controlling for hemisphere (long-format data)
    gm2 <- lmer(vol.APARC.insula~age_years+asr_scr_depress_r+hemi+(1 | rel_family_id/scanner_id)+(1 | scanner_id) + (1 | f.eid), data = dat_long,na.action=na.exclude)
    summary(gm2)
    ```
    
- Comparing lmer and lme functions
    
    The association between insular volume and ASR is tested. Hemisphere is controlled for as a fixed, within-participant effect. Individual ID is treated as a random effect.
    
    We shall be able to see that the estimates for the fixed effects are identical.
    
    ```jsx
    library(dplyr)
    library(lmerTest)
    library(nlme)
    
    ### old function
    lme(vol.APARC.insula~age_years+hemi+asr_scr_depress_r,data = dat_long,na.action=na.exclude,random=list(f.eid=~1)) %>%
    summary
    
    ### new function
    lmer(vol.APARC.insula~age_years+asr_scr_depress_r+hemi+(1 | f.eid),
                 data = dat_long,na.action=na.exclude,control = lmerControl(optimizer ="Nelder_Mead")) %>%
    summary
    ```
    

## Updated function (beta)

- Function can be found [here](https://github.com/xshen796/CodingClubPsych/blob/master/util/lme_models/NestedRandomLME.md). Note that variable names for family ID, scanner ID, etc have to be precisely the same as the example script.
    

- Or you can create a plain text file and paste the content below:

```jsx
run_model <- function(ls.mod,mod.dat_short,mod.dat_long){
   # define vars
   mod.dep = as.character(ls.mod[1])
   mod.factor = as.character(ls.mod[2])
   mod.covs = as.character(ls.mod[3])
   mod.type = as.character(ls.mod[4])
   
   # run model
   if (mod.type=='lme'){
      # model.expression
      fh_r=1:(nrow(mod.dat_long)/2)
      sh_r=(nrow(mod.dat_long)/2+1):nrow(mod.dat_long)
      
      mod.dat_long[fh_r,mod.dep]=scale(mod.dat_long[fh_r,mod.dep])
      mod.dat_long[sh_r,mod.dep]=scale(mod.dat_long[sh_r,mod.dep])
      if(is.numeric(mod.dat_long[,mod.factor])){
         mod.dat_long[fh_r,mod.factor]=scale(mod.dat_long[fh_r,mod.factor])
         mod.dat_long[sh_r,mod.factor]=scale(mod.dat_long[sh_r,mod.factor])
      }
      
      mod=paste0(mod.dep,'~',mod.covs,'+(1 | rel_family_id/scanner_id)+(1 | scanner_id) + (1 | f.eid)+',mod.factor)
      
      fit=lmer(as.formula(as.character(mod)),data=mod.dat_long,
              na.action=na.exclude,control = lmerControl(optimizer ="Nelder_Mead"))
      # tmp.ci = intervals(fit,which='fixed')$fixed %>% as.data.frame %>% 
      #    dplyr::select(Lower_95CI=lower,Upper_95CI=upper) %>% 
      #    tail(1)
      tmp.res = summary(fit)$tTable %>% 
         as.data.frame %>% 
         dplyr::select(beta=Estimate,std=`Std. Error`,t.value=`t value`,p.value=`Pr(>|t|)`) %>% 
         tail(1) %>% 
         mutate(mod_name = paste0(mod.dep,'~',mod.factor)) %>% 

         dplyr::select(mod_name, everything())
      
      
   }else{
      dep.dat=mod.dat_short[,mod.dep]            
      if (length(table(dep.dat))==2){
         mod=paste0(mod.dep,'~',mod.covs,'+(1 | rel_family_id/scanner_id)+(1 | scanner_id)+scale(',mod.factor,')')
         fit=glmer(as.formula(as.character(mod)),data=mod.dat_short,na.action=na.exclude,
                   control = glmerControl(optimizer ="Nelder_Mead"),family = 'binomial')
      }else{
         mod=paste0('scale(',mod.dep,')~',mod.covs,'+(1 | rel_family_id/scanner_id)+(1 | scanner_id)+scale(',mod.factor,')')
         fit=lmer(as.formula(as.character(mod)),data=mod.dat_short,na.action=na.exclude,control = lmerControl(optimizer ="Nelder_Mead"))
      }            
      # tmp.ci = confint(fit) %>% as.data.frame %>% 
      #    dplyr::select(Lower_95CI=`2.5 %`,Upper_95CI=`97.5 %`) %>% 
      #    tail(1)
      tmp.res = summary(fit)$coefficients %>% 
         as.data.frame %>% 
         dplyr::select(beta=Estimate,std=`Std. Error`,t.value=`t value`,p.value=`Pr(>|t|)`) %>% 
         tail(1)%>% 

         mutate(mod_name = paste0(mod.dep,'~',mod.factor)) %>% 

         dplyr::select(mod_name, everything())
   }
   
   return(tmp.res)
}

reg_phewasStyle <- function (ls.models,dat_short,dat_long,correctByFactor=F){
  
  result.table = ls.models %>% split(.,seq(nrow(.))) %>% 
    pblapply(.,FUN = run_model,
             mod.dat_short=dat_short,mod.dat_long=dat_long) %>% 
    bind_rows %>% 
    as.data.frame %>% 
    mutate(ls.models[,1:2])
  
  ls.factor=unique(ls.models$p_batch)
  result.table$p.corrected=99999
  if (correctByFactor==T){
    for (f in ls.factor){
      loc=grep(f,ls.models$p_batch)
      result.table$p.corrected[loc]=p.adjust(result.table$p.value[loc],method='fdr')
    }
  }else{
    result.table$p.corrected=p.adjust(result.table$p.value,method='fdr')
  }
  rownames(result.table)=NULL
  return(result.table)
}
```