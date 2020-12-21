Use SBayesR to create PRS
================
X Shen
04 December, 2020

-----

## Set up GCTB

  - Wiki for [GCTB](https://cnsgenomics.com/software/gctb/#Overview)

  - System requirements: Linux system, memory \> 150G

  - Download a copy of the latest package (currently v 2.02) from
    [here](https://cnsgenomics.com/software/gctb/#download/) using
    commands:
    
    ``` bash
    wget https://cnsgenomics.com/software/gctb/download/gctb_2.02_Linux.zip 
    unzip gctb_2.02_Linux 
    cd gctb_2.02_Linux 
    ls
    ```

  - Go back to the project home folder
    
    ``` bash
     cd ../
    ```
    
    > Prepared input 1: gtcb\_2.02\_Linux/gctb The ‘gctb’ file is an
    > executable file that will be used in the analysis.

-----

## Download shrunk sparse LD matrices

  - Available LD matrices can be found
    [here](https://cnsgenomics.com/software/gctb/#LDmatrices). In this
    example, we will use the big set with 2.8M common SNPs.

  - Download LD matrices
    
    \!\! Note: size = 226G
    
    ``` bash
    # Download partitioned files
    wget https://zenodo.org/record/3375373/files/ukb_50k_bigset_2.8M.zip.partaa
    wget https://zenodo.org/record/3376357/files/ukb_50k_bigset_2.8M.zip.partab
    wget https://zenodo.org/record/3376456/files/ukb_50k_bigset_2.8M.zip.partac
    wget https://zenodo.org/record/3376628/files/ukb_50k_bigset_2.8M.zip.partad
    wget https://zenodo.org/record/3376628/files/ukb_50k_bigset_2.8M.zip.partae
    
    # Concatenate file parts
    cat ukb_50k_bigset_2.8M.zip.part* > ukb_50k_bigset_2.8M.zip 
    
    # Unzip
    unzip ukb_50k_bigset_2.8M.zip
    
    # Clean up partitioned files
    rm ukb_50k_bigset_2.8M.zip.part*
    ```
    The file which contains the list of LD matrices `ukb_50k_begset_2.8M/ukb50k_2.8M_shrunk_sparse.mldmlist` is incorrect and contains wrongly named files. Run the following to create a new list which will be used in SBayesR (these must be in order of chromosomes 1 to 22):
    ```
    for i in {1..22}
    do
    echo ukb_50k_bigset_2.8M/ukb50k_shrunk_chr${i}_mafpt01.ldm.sparse >> ukb_50k_bigset_2.8M/ukb50k_2.8M_shrunk_sparse.new.mldmlist
    done
    ```

  - Find the input file with a list of LD matrices downloaded can now be
    found in :
    
    > Prepared input 2:
    > ukb\_50k\_begset\_2.8M/ukb50k\_2.8M\_shrunk\_sparse.new.mldmlist

-----

## Prepare GWAS summary statistics

  - GWAS summary statistics need to match [the
    example](https://cnsgenomics.com/software/gctb/#Tutorial) in section
    ‘GCTB summary statistics input format’. <span class="ul">It should
    be a plain text file with **.ma** as file extension</span>.
    
    > Prepared input 3: summstats.ma (example file name)

-----

## Run SBayesR analysis

  - Check gctb
    [tutotial](https://cnsgenomics.com/software/gctb/#Tutorial) and
    [options](https://cnsgenomics.com/software/gctb/#Options) for
    detailed descriptions for parametres.

  - Below is an example script using the prepared inputs 1-3 above:
    
    ``` bash
    
    .gctb_2.02_Linux/gctb --sbayes R \
         --mldm ukb_50k_begset_2.8M/ukb50k_2.8M_shrunk_sparse.new.mldmlist \
         --pi 0.95,0.02,0.02,0.01 \
         --gamma 0.0,0.01,0.1,1 \
         --ambiguous-snp \
         --impute-n \
         --gwas-summary summstats.ma \
         --chain-length 10000 \
         --burn-in 2000 \
         --out-freq 10 \
         --out summstats.SBayesR
    ```
    
    > Output summary stats for calculating PRS: summstats.SBayesR.snpRes
