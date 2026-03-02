import pandas as pd
import numpy as np

def generate():
    # 1. Load your dataset
    df = pd.read_csv('newdataset.csv')
    df.columns = df.columns.str.strip().str.lower()
    df['disease'] = df['disease'].str.strip().str.lower()

    symptoms = [c for c in df.columns if c != 'disease']
    diseases = df['disease'].unique()

    print("\n--- 🧠 COPY THIS MAP INTO FLUTTER ---")
    print("static final Map<String, Map<String, double>> _probMatrix = {")

    for d in diseases:
        d_df = df[df['disease'] == d]
        print(f'    "{d}": {{')
        for s in symptoms:
            # Calculate probability with Laplace smoothing (alpha=1)
            # This is the exact math used in professional Naive Bayes AI
            prob = (d_df[s].sum() + 1) / (len(d_df) + 2)
            print(f'      "{s}": {round(prob, 4)},')
        print('    },')
    print("};")

if __name__ == "__main__":
    generate()