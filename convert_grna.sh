#!/bin/bash

# Input and output file names
INPUT_FILE="GSE120861_grna_groups.at_scale.txt"
OUTPUT_FILE="GSE120861_grna_groups.at_scale.csv"
TEMP_FILE="GSE120861_grna_groups.at_scale_temp.txt"

# Ensure a clean output file
rm -f "$OUTPUT_FILE"
echo "id,name,feature_type,read,pattern,sequence" > "$OUTPUT_FILE"

# Initialize temp file
rm -f "$TEMP_FILE"
touch "$TEMP_FILE"

# Read input file line by line
while read -r id sequence; do
    # Count occurrences of the ID (including the first one)
    count=$(grep -c "^$id$" "$TEMP_FILE" 2>/dev/null)
    count=$((count + 1))  # First occurrence should be _1

    # Append "_1", "_2", etc., to the id
    unique_id="${id}_${count}"

    # Track this ID in the temp file
    echo "$id" >> "$TEMP_FILE"

    # Write to CSV
    echo "$unique_id,$id,CRISPR Guide Capture,R2,5PNNNNNNNNNN(BC),$sequence" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# Clean up
rm -f "$TEMP_FILE"

echo "Conversion completed! Output file: $OUTPUT_FILE"

