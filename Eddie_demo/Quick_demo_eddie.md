A quick demo for eddie
================
X Shen
18 May, 2022

``` r
library(knitr)
```

# Eddie

## Local set up

  - [Register](https://www.ed.ac.uk/information-services/computing/desktop-personal/vpn/vpn-service-registration)
    your VPN service

  - Connect to VPN using
    [FortiClinet](https://www.ed.ac.uk/information-services/computing/desktop-personal/vpn/forticlient-vpn)

  - Download and set up
    [MobaXterm](https://mobaxterm.mobatek.net/download.html)

<img src="/gpfs/igmmfs01/eddie/GenScotDepression/shen/ActiveProject/CodingClubPsych/Eddie_demo/screenshots/eddie_demo/Slide1.PNG" width="1280" />

  - Download and set up
    [WinSCP](https://winscp.en.softonic.com/download?utm_source=SEM&utm_medium=paid&utm_campaign=EN_desktop_UK_conversions_DSA&gclid=Cj0KCQjwspKUBhCvARIsAB2IYus2vr4tG52r090sgZ7XlNQh5FuFbxa5p9kuW9GoFBL3iyIYzs5oXUgaAhP2EALw_wcB)

<img src="/gpfs/igmmfs01/eddie/GenScotDepression/shen/ActiveProject/CodingClubPsych/Eddie_demo/screenshots/eddie_demo/Slide2.PNG" width="1280" />

## Two ways of using Eddie

  - Log on an interactive node

<!-- end list -->

``` bash
qlogin -l h_vmem=8G
```

You can specify how much memory is needed by specifying the ‘h\_vmem’
option. The larger the dataset you work with and the more complex your
analysis is, the larger momery is needed. It is difficult to know
precisely how much memory is needed before running a script, even if you
are very familiar with Eddie. It requires a bit of trail and error.

  - Submit a code job to Eddie

Find an example script
[here](https://github.com/xshen796/CodingClubPsych/blob/master/Eddie_demo/Eddie_job)
or copy and paste the script below in an empty plain text file you
created:

``` bash
#!/bin/sh
#$ -N eddie_demo
#$ -cwd
#$ -m beas
#$ -M s1517658@ed.ac.uk
#$ -l h_vmem=32G
#$ -pe sharedmem 2
#$ -l h_rt=24:00:00
. /etc/profile.d/modules.sh
source ~/.bash_profile

module load igmm/apps/R/4.1.0

echo 'You are a genius' >> test.txt
```

If you submit a code job to Eddie, the job will run without your
immediate monitor. It will start running as long as a node that meets
your requirements is available. This is particularly helpful if you
require a large node for your job.

The total memory required in the example script is 32G (per node) \* 2
(number of nodes) = 64G

## Working directories that are available to you

  - Group space (which you will create):
    /exports/igmm/eddie/GenScotDepression/<userfolder>
  - Home space: /home/<UII>
  - Personal scratch space: /exports/eddie/scratch/<UII>

## Share your files with others

By default, files you created will be accessible only to you. Before
sharing it with others, you will need to specify the rights of the files
to make it read-able to others. To do this (for an example file
test\_file.txt), use the example script as below:

``` bash
# Add read permission
chmod +r test_file.txt
# Add write permission
chmod +w test_file.txt
# Add execute permission
chmod +x test_file.txt

# Usually, if you'd like to share a file, it's useful to add both read and execute permission to the file

chmod +rx test_file.txt
```

## Other references

  - A complete guide for Eddie can be found
    [here](https://www.wiki.ed.ac.uk/pages/viewpage.action?spaceKey=ResearchServices&title=Eddie)

# Methylation data for Generation Scotland

## Access data on Eddie

### Access data on High Performance Computing (HPC) cluster

/exports/igmm/eddie/GenScotDepression/data/genscot/

In this folder, subfolders contain methylation data (methylation),
phenotypes (phenotypes) and genetic data
(genotypes/GS20K\_PLINK\_files/).

Specific files:

  - DNA methylation data: M-values by chromosome:
    methylation/methylation\_by\_carmen/mvalues\_epic/mvalues\_epic\_chroms/

  - BMI and MDD phenotypes: phenotypes/masterDB.Rdata

  - Data dictionary for **masterDB.Rdata**: phenotypes/phenotypes.csv

  - Genotypes:
genetics/imputed/HRC/updated\_bims

### Access data in datastore (this is where most of the data is safely stored)

You’ll need to log on a ‘staging node’ to access datastore, in a way
that is similar with logging on an interactive node. Use the script
below:

``` bash
qlogin -q staging

cd /exports/igmm/datastore/GenScotDepression/data
```

Usually, after finding the data you need, you’ll copy the data over to
your scratch space for further analysis.
