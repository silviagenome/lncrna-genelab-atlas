import pandas as pd
import numpy as np

columns = ['sample_num', 'genelab_id', 'condition', 'filename', 'read', 'replicate']
data_dict = {col: [] for col in columns}

with open("/home/alumno15/TFM/raw_data.txt", 'r') as file:
    for line in file:
        line = line.strip().split(' ')
        for i, col in enumerate(columns):
            data_dict[col].append(line[i])
print(data_dict)

df = pd.DataFrame(data_dict)

# Crear un nuevo dataframe con la información agregada
new_data = {'sample_name': ['A1', 'B1', 'A2', 'B2'],
            'condition': ['control', 'spaceflight', 'control', 'spaceflight']}
new_df = pd.DataFrame(new_data)

# Agregar al nuevo dataframe la información correspondiente a cada muestra
index = 0
while index <= 2:
    for i, row in new_df.iterrows():
        sample_name = row['sample_name']
        print(sample_name)
        condition = row['condition']
        filenames = df[(df['genelab_id'] == 'OSD-168') & (df['condition'] == condition)]['filename'].tolist()
        print(filenames)
        if sample_name.startswith("A"):
            print("aquí A")
            print(index)
            index = index
            new_df.at[i, 'fq1'] = "/home/alumno15/TFM/rawReads/"+filenames[index]
            new_df.at[i, 'fq2'] = "/home/alumno15/TFM/rawReads/"+filenames[index+1]
        else:
            print("aquí B")
            print(index)
            new_df.at[i, 'fq1'] = "/home/alumno15/TFM/rawReads/"+filenames[index]
            new_df.at[i, 'fq2'] = "/home/alumno15/TFM/rawReads/"+filenames[index+1]
            index+=2

# Mostrar el nuevo dataframe con la información agregada
new_df.insert(1, "unit_name", [1,1,1,1], True)
new_df.insert(5, "sra", np.nan, True)
new_df.insert(6, "adapters", np.nan, True)
new_df.insert(7, "strandedness", np.nan, True)
print(new_df)

header1 = ["sample_name", "condition"]
new_df.to_csv("samples.tsv", sep="\t", columns = header1, index = False)

header2 = ["sample_name", "unit_name", "fq1", "fq2", "sra", "adapters", "strandedness"]
new_df.to_csv("units.tsv", sep="\t", columns = header2, index = False)
