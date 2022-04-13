# Models with nested, random effects

## Background

- GLMM model recommended by ABCD: [link](http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html)
- Get p values from nested random effect models:[link](https://github.com/runehaubo/lmerTestR)
- Protocol paper for ABCD analysis: [link](https://www.biorxiv.org/content/10.1101/2020.02.10.942011v1.full)

## Summary & caution

- It is tricky to get p-values for a model with multiple, nested random effects. The p-values may vary, depending on how degree of freedom (DF) is defined. There are various of ways of approaching this issue, but the uncertainty of df should have little impact if the N is massive.
- The package *lmerTestR* is one of the solutions. See its reference paper for more stats and descriptions. It is selected because of its simplicity: 1) built on an established R package 'lmer', 2) does not require additional packages and 3) gives simple outputs that are similar to fixed effect glm models.
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

- Function can be found [here](https://github.com/xshen796/CodingClubPsych/blob/master/util/lme_models/reg_phewasStyle_NestedRandom.R). Note that variable names for family ID, scanner ID, etc have to be precisely the same as the example script.
    