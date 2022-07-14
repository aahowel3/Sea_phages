# Sea_phages

#July 2022 reruns 
Cluster DR phages in folder /work/aahowel3/DR_paper_rerun
New gene specific CDS files created via seqkit commands - MarioKart Hic gene added manually since its unlabeled 
seqkit grep -r -n -p '.*Hic.*' DRphages_CDS.txt > DRphages_Hic.fasta
seqkit grep -r -n -p '.*gene=70.*' Mariokart_CDS.txt >> DRphages_Hic.fasta
