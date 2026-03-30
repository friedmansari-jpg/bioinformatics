#!/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -o assembly.test.log
#SBATCH --account=sfriedman7466
#SBATCH --partition=silver
'''
module load biological/samtools_1.23
module load biological/java

export PROJ_DIR=/export/home/bio_class/sfriedman7466/Lab_nine
cd $PROJ_DIR
export SRR=SRR5324768


if [ ! -f genome/Thermus_thermophilus_TTHNAR1.dict ]; then
    java -jar /export/share/software/biological/picard/picard.jar \
    	CreateSequenceDictionary \
    	REFERENCE=genome/Thermus_thermophilus_TTHNAR1.fa \
    	OUTPUT=genome/Thermus_thermophilus_TTHNAR1.dict
fi

/export/share/software/biological/bowtie2-2.4.2-sra-linux-x86_64/bowtie2-build \
	genome/Thermus_thermophilus_TTHNAR1.fa \
	genome/Thermus_thermophilus_TTHNAR1

 
/export/share/software/biological/bowtie2-2.4.2-sra-linux-x86_64/bowtie2 -x \
		genome/Thermus_thermophilus_TTHNAR1 \
        -1 fastq/${SRR}_pass_1.fastq.gz \
        -2 fastq/${SRR}_pass_2.fastq.gz --sensitive-local \
        --rg-id ${SRR} --rg SM:${SRR} --rg PL:ILLUMINA \
        > alignment/${SRR}.sam 


samtools view -hb alignment/${SRR}.sam | samtools sort -l 5 -o alignment/${SRR}.bam
samtools index alignment/${SRR}.bam


/export/share/software/biological/bowtie2-2.4.2-sra-linux-x86_64/bowtie2 -x \
		genome/Thermus_thermophilus_TTHNAR1 \
        -1 fastq/${SRR}_pass_1.fastq.gz \
        -2 fastq/${SRR}_pass_2.fastq.gz --sensitive-local \
        --rg-id ${SRR} --rg SM:${SRR} --rg PL:ILLUMINA \
	   | samtools view -hb - | samtools sort -l 5 -o alignment/${SRR}.bam


/export/share/software/biological/gatk-4.6.2.0/gatk \
   --java-options "-Xmx8g" HaplotypeCaller  \
   --reference genome/Thermus_thermophilus_TTHNAR1.fa \
   --sample-ploidy 1 \
   --input alignment/${SRR}.bam \
   --output variants/${SRR}.vcf



export PROJ_DIR=/export/home/bio_class/sfriedman7466/Lab_nine
cd $PROJ_DIR
export SRR=SRR5324768

mkdir -p alignment
mkdir -p variants

bowtie2-build ncbi_dataset/ncbi_dataset/data/GCA_900604845.1/GCA_900604845.1_TTHNAR1_genomic.fna genome_index

bowtie2 -x genome_index \
-1 fastq/fastq/${SRR}_pass_1.fastq.gz \
-2 fastq/fastq/${SRR}_pass_2.fastq.gz \
--sensitive-local \
--rg-id ${SRR} --rg SM:${SRR} --rg PL:ILLUMINA \
| samtools view -hb - \
| samtools sort -l 5 -o alignment/${SRR}.bam

samtools index alignment/${SRR}.bam
'''

module load biological/samtools_1.23
samtools consensus -f fasta -o SRR5324768_consensus.fasta alignment/SRR5324768.sorted.bam
