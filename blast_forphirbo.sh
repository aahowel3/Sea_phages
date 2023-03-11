#!/bin/bash
#SBATCH -N 1            # number of nodes
#SBATCH -n 1            # number of "tasks" (default: 1 core per task)
#SBATCH -t 7-00:00:00   # time in d-hh:mm:ss
#SBATCH --mem=16000mb
#SBATCH -o slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --export=NONE   # Purge the job-submitting shell environment

module load blast_plus/2.12.0
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query KFS-EC3_virus/KFS-EC3.fasta -outfmt '6 scomnames' > KFS-EC3_virusblast/KFS-EC3.blastn.txt
awk '!x[$0]++' KFS-EC3_virusblast/KFS-EC3.blastn.txt > KFS-EC3_virusblast/KFS-EC3.blastn.uniq.txt

for file in KFS-EC3_hosts/*
do
base=$(basename "$file")
echo $base
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query KFS-EC3_hosts/${base} -outfmt '6 scomnames' > KFS-EC3_hostsblast/${base}.blastn.txt
awk '!x[$0]++' KFS-EC3_hostsblast/${base}.blastn.txt > KFS-EC3_hostsblast/${base}.blastn.uniq.txt
done


module load blast_plus/2.12.0
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query HY01_virus/HY01.fasta -outfmt '6 scomnames' > HY01_virusblast/HY01.blastn.txt
awk '!x[$0]++' HY01_virusblast/HY01.blastn.txt > HY01_virusblast/HY01.blastn.uniq.txt

for file in HY01_hosts/*
do
base=$(basename "$file")
echo $base
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query HY01_hosts/${base} -outfmt '6 scomnames' > HY01_hostsblast/${base}.blastn.txt
awk '!x[$0]++' HY01_hostsblast/${base}.blastn.txt > HY01_hostsblast/${base}.blastn.uniq.txt
done


module load blast_plus/2.12.0
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query SFP10_virus/SFP10.fasta -outfmt '6 scomnames' > SFP10_virusblast/SFP10.blastn.txt
awk '!x[$0]++' SFP10_virusblast/SFP10.blastn.txt > SFP10_virusblast/SFP10.blastn.uniq.txt

for file in SFP10_hosts/*
do
base=$(basename "$file")
echo $base
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query SFP10_hosts/${base} -outfmt '6 scomnames' > SFP10_hostsblast/${base}.blastn.txt
awk '!x[$0]++' SFP10_hostsblast/${base}.blastn.txt > SFP10_hostsblast/${base}.blastn.uniq.txt
done


module load blast_plus/2.12.0
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query SFP10_virus/SFP10.fasta -outfmt '6 scomnames' > SFP10_virusblast/SFP10.blastn.txt
awk '!x[$0]++' SFP10_virusblast/SFP10.blastn.txt > SFP10_virusblast/SFP10.blastn.uniq.txt

for file in SFP10_hosts/*
do
base=$(basename "$file")
echo $base
blastn -db /scratch/cversoza/sea_phages_spring_2022/phirbo/databases/ref_prok_rep_genomes -query SFP10_hosts/${base} -outfmt '6 scomnames' > SFP10_hostsblast/${base}.blastn.txt
awk '!x[$0]++' SFP10_hostsblast/${base}.blastn.txt > SFP10_hostsblast/${base}.blastn.uniq.txt
done

