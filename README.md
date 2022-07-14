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
