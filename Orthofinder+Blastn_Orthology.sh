#!/bin/bash

#SBATCH -J pipeline # change this with the name of your job
#SBATCH --account=leisnerlpb
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --mem=64G
#SBATCH --time=48:00:00 # change this with desired wall time limit
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gih0004@vt.edu

# Load OrthoFinder module
#module load OrthoFinder/2.5.4-foss-2020b

# Run OrthoFinder
#orthofinder -f ./ortho-genomes/

# Load BLAST+ module
#module load BLAST+/2.13.0-gompi-2022a

# Create BLAST database
#makeblastdb -in CDS_genome_b_[ATL].fa -dbtype nucl -out CDS_genome_b[ATL].fa_db


# Run BLASTN
#blastn -query Genes_of_interest.fa -db CDS_genome_b[ATL].fa_db -perc_identity 95  -evalue 1e-5 -out Ortho+BLASTn_results.txt -outfmt "6 sacc qsedid qacc evalue sallseqid pident ppos"


cp ./ortho-genomes/OrthoFinder/*/Orthogroups/Orthogroups.tsv . 


# Run the Python script for further analysis
python3 <<EOF
import pandas as pd

# Set the working directory (not needed in Python generally, specify full path in read_csv)
# Change directory paths as needed when deploying or sharing the script.

# Read the tables
orthogroups_path = "./Orthogroups.tsv"
GOI_path = "./Ortho+BLASTn_results.txt"

orthogroups_df = pd.read_csv(orthogroups_path, sep='\t')
GOI_df = pd.read_csv(GOI_path, sep='\t')

# Rename columns to make them more generic
GOI_df.columns = ['Subject_accession', 'Query_sequence', 'E_value', 'Subject_all_sequence_identifier', 'Percentage_identity', 'Percentage_positives']

# Merge the data frames based on common columns
merged_df = pd.merge(GOI_df, orthogroups_df, how='left', left_on=['Subject_accession', 'Query_sequence'], right_on=['Peptides_genome_b_[ATL]', 'Peptide_genome_a_[PSGC]'])

# Second merge that excludes rows with no match in the orthogroups
exact_match_df = pd.merge(GOI_df, orthogroups_df, how='inner', left_on=['Subject_accession', 'Query_sequence'], right_on=['Peptides_genome_b_[ATL]', 'Peptide_genome_a_[PSGC]'])

# Print the merged data frames
print(merged_df)
print(exact_match_df)

# Save the exact matches to a CSV file
exact_match_df.to_csv('Genome_A_GOIs_in_Genome_B_with_OGs', index=False)

# Read additional gene annotations and merge
GOI_annotations_path = "./Gene_annotations.txt"
GOI_annotations_df = pd.read_csv(GOI_annotations_path, sep='\t')

final_GOI_df = pd.merge(exact_match_df, GOI_annotations_df, how='inner', left_on='Query_sequence', right_on='TF_ID')

# Save the final transcription factor results to a CSV file
final_GOI_df.to_csv('GOI_in_genome_b_results.csv', index=False)

# Extract and save the Transcription Factor loci data
final_GOI_loci = final_GOI_df[['Subject_accession']]
final_GOI_loci.to_csv('Final_GOI_in_Genome_b.csv', index=False)
