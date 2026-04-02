#!/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -o assembly.test.log
#SBATCH --account=sfriedman7466
#SBATCH --partition=silver

#Load in tools needed
module load biological/samtools_1.23

#Set working directory
export PROJ_DIR=/export/home/bio_class/sfriedman7466/Lab_nine
cd $PROJ_DIR
export SRR=SRR5324768

#Make folders
mkdir -p genome
mkdir -p alignment
mkdir -p variants

#Make sequence directory if does not exist
if [ ! -f genome/Thermus_thermophilus_TTHNAR1.dict ]; then
    java -jar /export/share/software/biological/picard/picard.jar \
    	CreateSequenceDictionary \
    	REFERENCE=genome/Thermus_thermophilus_TTHNAR1.fa \
    	OUTPUT=genome/Thermus_thermophilus_TTHNAR1.dict
fi

#Bowtie2 index set up
bowtie2-build ncbi_dataset/ncbi_dataset/data/GCA_900604845.1/GCA_900604845.1_TTHNAR1_genomic.fna genome_index

 #Make SAM file
/export/share/software/biological/bowtie2-2.4.2-sra-linux-x86_64/bowtie2 -x \
		genome/Thermus_thermophilus_TTHNAR1 \
        -1 fastq/${SRR}_pass_1.fastq.gz \
        -2 fastq/${SRR}_pass_2.fastq.gz --sensitive-local \
        --rg-id ${SRR} --rg SM:${SRR} --rg PL:ILLUMINA \
        > alignment/${SRR}.sam 

#SAM to BAM file
samtools view -hb alignment/${SRR}.sam | samtools sort -l 5 -o alignment/${SRR}.bam

#Index BAM file
samtools index alignment/${SRR}.bam

#Make pileup file
samtools mpileup -f ncbi_dataset/ncbi_dataset/data/GCA_900604845.1/GCA_900604845.1_TTHNAR1_genomic.fna alignment/${SRR}.bam > variants/${SRR}.pileup

#Make .vcf file
echo "##fileformat=VCFv4.2" > variants/${SRR}.vcf
echo -e "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO" >> variants/${SRR}.vcf
head -n 20 variants/${SRR}.pileup | awk '{print $1"\t"$2"\t.\t"$3"\tN\t.\t.\t."}' >> variants/${SRR}.vcf

#Make consensus file
samtools consensus -f fasta -o ${SRR}_consensus.fasta alignment/${SRR}.bam

