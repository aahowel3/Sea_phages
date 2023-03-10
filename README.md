# Sea_phages

#July 2022 reruns 
Cluster DR phages in folder /work/aahowel3/DR_paper_rerun
New gene specific CDS files created via seqkit commands - MarioKart Hic gene added manually since its unlabeled 
seqkit grep -r -n -p '.*Hic.*' DRphages_CDS.txt > DRphages_Hic.fasta
seqkit grep -r -n -p '.*gene=70.*' Mariokart_CDS.txt >> DRphages_Hic.fasta

For RuvC had to add in the one from Sour
seqkit grep -r -n -p '.*gene=9.*' Sour_CDS.txt >> DRphages_RuvC.fasta 
And then manually remove Abt2grad - don't need that out group 
Totals should be 12 - whole genome 11 - ruvC 6 - HIcA 

location of comparitive paper viruses
/work/aahowel3/VirHostMatcher_results/onlyDandP_viruses

NEW YEAR NEW DIRECTORY BABY
SOL - /scratch/hostrange
source activate hostrange


HostPhinder: not good - link dead - http://cge.cbs.dtu.dk/services/HostPhinder 
sources 1 and 2 in the paper https://www.mdpi.com/1999-4915/8/5/116 

PHP - https://github.com/congyulu-bioinfo/PHP
also has a GUI http://computationalbiology.cn/phageHostPredictor/home.html
PHP: (hostrange) [aahowel3@c005:/scratch/aahowel3/hostrange]$ 
Only use if you want to use as confirmatory: python3 PHP/countKmer.py --fastaFileDir  ./KFS-EC3_hosts/ --kmerFileDir ./exampleOutput --kmerName HostKmer  --coreNum -1

to use as exploratory: python3 PHP/PHP.py --virusFastaFileDir ./KFS-EC3_virus/  --outFileDir ./exampleOutput  --bacteriaKmerDir ./PHP  --bacteriaKmerName hostKmer_60105_kmer4.tar.gz
to use as confrimatory: python3 PHP/PHP.py --virusFastaFileDir ./KFS-EC3_virus/  --outFileDir ./exampleOutput  --bacteriaKmerDir ./exampleOutput  --bacteriaKmerName HostKmer

WISH - has to be run on agave - thats where CYs null directories are
new superdiverse null directory created by copying these directories of Cy into my /scratch/hostrange/null
[aahowel3@agave3:/scratch/aahowel3/hostrange/null]$ cp /scratch/cversoza/sea_phages_spring_2022/wish/null/* .
[aahowel3@agave3:/scratch/aahowel3/hostrange/null]$ cp /scratch/cversoza/sea_phages_spring_2022/wish/cluster_P/* .
[aahowel3@agave3:/scratch/aahowel3/hostrange/null]$ cp /scratch/cversoza/sea_phages_spring_2022/wish/paper_gordonia_phages/* .
[aahowel3@agave3:/scratch/aahowel3/hostrange/null]$ cp /scratch/cversoza/sea_phages_spring_2022/wish/hhmi_gordonia_phages/* .
***youve also copied every test virus from the VMH 352 test folder into null to train it as well

Create host model directory 
WIsH/WIsH -c build -g KFS-EC3_hosts/ -m modelDir 
Run on null to get llikelihood.matrix in outputNullModelResultDir to feed into computeNullParameters.R 
WIsH/WIsH -c predict -g null/ -m modelDir -r outputNullModelResultDir -b 1000
[aahowel3@cg47-1:/scratch/aahowel3/hostrange/outputNullModelResultDir]$ Rscript ../WIsH/computeNullParameters.R
[aahowel3@cg47-1:/scratch/aahowel3/hostrange]$ WIsH/WIsH -c predict -g KFS-EC3_virus/ -m modelDir -r outputResultDir -b 1000 -n outputNullModelResultDir/nullParameters.tsv
change b to 1000 or larger to list all the hosts 

VHM - realized you dont need a taxonomizer file

VHMN
ssh aahowel3@login05.osgconnect.net
apptainer build my-container.sif image.def (only once if it complies right)
apptainer shell my-container.sif
cd /opt/miniconda/bin 
. activate 
cd
python /opt/VirHostMatcher-Net/VirHostMatcher-Net.py -q /opt/VirHostMatcher-Net/test/VGs -o output -i tmp -n 3 -t 8
if you need older: https://repo.anaconda.com/miniconda/
