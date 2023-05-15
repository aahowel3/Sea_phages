# Sea_phages

Where is our assembly data? /scratch/spfeife1/bacterial_hosts

Where are our tree outputs? 10.210.91.237 - conda activate gtotree - do not run in tmux will not work

ANI outputs in under /scratch/aahowel3/hostrange/ANI/HY01_ANI ANIb_percentage_identity.names.txt 

prokka is in /scratch/aahowel3/hostrange/KFS-EC3_hosts 

April 2023 plotting - all likelihood plots are in wish.R which is in /hostrange/WISH 
upsetRcomparitive is also in /hostrange/WISH

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
[aahowel3@cg47-1:/scratch/aahowel3/hostrange]$ python VirHostMatcher/vhm.py -v HY01_virus/ -b HY01_hosts/ -o HY01_VHMoutput

VHMN
ssh aahowel3@login05.osgconnect.net
apptainer build my-container.sif image.def (only once if it complies right)
apptainer shell my-container.sif
cd /opt/miniconda/bin 
. activate 
cd
python /opt/VirHostMatcher-Net/VirHostMatcher-Net.py -q /opt/VirHostMatcher-Net/test/VGs -o output -i tmp -n 3 -t 8
if you need older: https://repo.anaconda.com/miniconda/

Phirbo:
to prep the databases use: blast_forphirbo.sh 
you need to have taxdb.btd, taxdb.bti, taxdb.tar.gz downloaded
python phirbo/phirbo.py KFS-EC3_virusblast/ KFS-EC3_hostsblast/ KFS-EC3_phirbo/predictions.csv 

PHP - https://github.com/congyulu-bioinfo/PHP
(hostrange) [aahowel3@agave1:/scratch/aahowel3/hostrange]$ python3 PHP/countKmer.py -f KFS-EC3_hosts -d KFS-EC3_PHPkmer -n KFS-EC3_PHPHostKmer -c -1
(hostrange) [aahowel3@agave1:/scratch/aahowel3/hostrange]$ python3 PHP/PHP.py -v KFS-EC3_virus -o KFS-EC3_PHPout  -d KFS-EC3_PHPkmer -n KFS-EC3_PHPHostKmer

PHIST
copied HY01_hosts into HY01hosts_indiv
create directory for each fasta file:
cd ParentFolder
for x in ./*.txt; do
  mkdir "${x%.*}" && mv "$x" "${x%.*}"
done

Run phist on each file in that directroy 
for x in *; do python ../PHIST/phist.py ../HY01_virus $x ${x}_out; done
combine all predictions.csv
find . -name 'predictions.csv' -exec cat {} \; > allpredictions.csv

^^^actually dont do this - every prediction comes out weird just run it all together and take the top prediction and list that as a limitation 

A note on HostG/CHERRY/PHAIST that need to be run on OSG - have to do all the conda installs in the spin up and then git clone tools in home directory since you can't touch those directories created in the spin up after the fact

HostG absolute pain 
1. add phage to nuc.fasta (cat genome onto it) and add protein to protein.fasta (obtained ncbi) 
2. add to database_gene_togenome file - use commands below to create same format to tack onto d
grep "^>" KFS-EC3.protein.fasta > KFS-EC3.protein.names.txt
column1cd /op 
awk  'BEGIN { FS = "prot_" } ; { print $2 }' KFS-EC3.protein.names.txt |  awk  'BEGIN { FS = " " } ; { print $1 }' | head 
column2 
awk  'BEGIN { FS = "|" } ; { print $2 }' KFS-EC3.protein.names.txt |  awk  'BEGIN { FS = "_prot" } ; { print $1 }' | head
column 3
awk  'BEGIN { FS = "protein=" } ; { print $2 }' KFS-EC3.protein.names.txt |  awk  'BEGIN { FS = "\]" } ; { print $1 }' | head 
merge with
paste -d',' column1.txt column2.txt column3.txt

mv outs to actual filename - file with header in it HAS to be appended first
awk 1 dataset/nucl.fasta /home/aahowel3/KFS-EC3_virus/KFS-EC3.fasta > out
awk 1 dataset/protein.fasta /home/aahowel3/KFS-EC3.protein.fasta > out
awk 1 dataset/database_gene_to_genome.csv /home/aahowel3/KFS-EC3.protein.names.sorted.txt > out
    
In hostG folder: python run_Speed_up.py --contigs ../KFS-EC3_virus/KFS-EC3.fasta --len 8000 --t 0

CHERRY
Add hosts to new_prokaryote directory 
Delete everything inside prokaryote directory first - saves time
awk 1 CHERRY/dataset/prokaryote.csv KFS-EC3_taxonomy.csv > out 
mv out prokaryote.csv - file with header in it HAS to be appended first 
Inside the CHERRY folder: python run_Speed_up.py --contigs ../KFS-EC3_virus/KFS-EC3.fasta --mode prokaryote --t 0.0

PHIAF: In PHIAF directroy: python code/compute_dna_features.py (no other arguments just have allphage_dna_seq.fasta and allhost_dna_seq.fasta in PHAIF folder - those are what your input viruses and hosts need to be renamed to) 
dies at this step with connection reset cant tell if its finishing or not - may have to do a slurm job send off to work

VHMN in main directory: python /opt/VirHostMatcher-Net/VirHostMatcher-Net.py -q KFS-EC3_virus/ -o vhmn_output -n 1000 
*specifiy output directory or youoll never find it

HostG in hostg directory:  python run_Speed_up.py --contigs ../KFS-EC3_virus/KFS-EC3.fasta --t 0 
*can only do to genus level and only output 1 result - mildly dissapointing 

RAFAH in rafah directory: perl RaFAH.pl --predict --genomes_dir ../KFS-EC3_virus/ --extension .fasta --file_prefix RaFAH_1 
perl RaFAH.pl --predict --genomes_dir Genomes/ --extension .fasta --valid_ogs_file HP_Ranger_Model_3_Valid_Cols.txt --hmmer_db_file_name HP_Ranger_Model_3_Filtered_0.9_Valids.hmm --r_script_predict_file_name RaFAH_Predict_Host.R --r_model_file_name MMSeqs_Clusters_Ranger_Model_1+2+3_Clean.RData

CHERRY in cherry: python run_Speed_up.py --contigs ../KFS-EC3_virus/KFS-EC3.fasta --model pretrain --topk 1000 

Deephost in DeepHost/DeepHost_scripts: python DeepHost.py ../KFS-EC3_virus/KFS-EC3.fasta --out Output_name.txt --rank species 

Vhulk:  python vHULK.py -i ../KFS-EC3_virus/ -o OUTPUT_DIR --all
