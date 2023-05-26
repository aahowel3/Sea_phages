#phirbo 
module load blast_plus/2.12.0
#mkdir -p gordonia_hostsblast
#create blast entry for each host - compile all in one directory
#for x in gordonia_hosts/*
#	do
#	base=$(basename "$x" .fasta)
#	blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query $x -outfmt '6 scomnames' > gordonia_hostsblast/${base}.blastn.txt
#	awk '!x[$0]++' gordonia_hostsblast/${base}.blastn.txt > gordonia_hostsblast/${base}.blastn.uniq.txt
#done

#create blast directory for each virus and then run phirbo 
mkdir -p gordonia_phirbo
for x in G*/*
do
	base=$(basename "$x" .fasta)
	mkdir -p ${base}_blast
        blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query $x -outfmt '6 scomnames' > ${base}_blast/${base}.blastn.txt
        awk '!x[$0]++' ${base}_blast/${base}.blastn.txt > ${base}_blast/${base}.blastn.uniq.txt
	phirbo/phirbo.py ${base}_blast/ gordonia_hostsblast/ gordonia_phirbo/${base}_predictions.csv
done

#PHIST - requires host directory and seperate directory for every virus 
for x in G*/*
do
base=$(basename "$x" .fasta)
PHIST/phist.py ${base}/ gordonia_hosts/ ${base}_phist
done 

#VHM 
for x in G*/*
do
base=$(basename "$x" .fasta)
python VirHostMatcher/vhm.py -v ${base}/ -b gordonia_hosts/ -o ${base}_VHMoutput
done 


##WISH
mkdir -p gordonia_hosts_modelDir
WIsH/WIsH -c build -g gordonia_hosts/ -m gordonia_hosts_modelDir
mkdir -p gordonia_hosts_outputNullModelResultDir
WIsH/WIsH -c predict -g null/ -m gordonia_hosts_modelDir -r gordonia_hosts_outputNullModelResultDir -b 1000
cd gordonia_hosts_outputNullModelResultDir
Rscript ../WIsH/computeNullParameters.R
cd ../


for x in G*/*
do
base=$(basename "$x" .fasta)
mkdir -p ${base}_outputResultDir
WIsH/WIsH -c predict -g $base/ -m gordonia_hosts_modelDir -r ${base}_outputResultDir -b 1000 -n gordonia_hosts_outputNullModelResultDir/nullParameters.tsv
done


####PHP
python3 PHP/countKmer.py -f gordonia_hosts -d gordonia_hosts_PHPkmer -n gordonia_hosts_PHPHostKmer -c -1

for x in G*/*
do
base=$(basename "$x" .fasta)
python3 PHP/PHP.py -v ${base}/ -o ${base}_PHPout -d gordonia_hosts_PHPkmer -n gordonia_hosts_PHPHostKmer
done










