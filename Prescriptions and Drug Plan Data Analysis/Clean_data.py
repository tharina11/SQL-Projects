# Import libraries
import pandas as pd

# Step 1: Load the CSV file, treat all values as strings
df = pd.read_csv("insulin_beneficiary_cost_20250630.csv", encoding="cp1252", dtype=str, header=None)

# Step 2: Strip leading/trailing spaces and replace pure space or empty with 'NULL'
df = df.applymap(lambda x: 'NULL' if pd.isna(x) or x.strip() == '' else x.strip())

# Step 3: Replace . in cells with NULL
df = df.applymap(lambda x: 'NULL' if x == '.' else x)

# Step 4: Save cleaned file (no index, no header)
df.to_csv("cleaned_file.csv", header=False, index=False)