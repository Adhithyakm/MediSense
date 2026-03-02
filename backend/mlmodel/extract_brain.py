import pandas as pd
import os

def train_and_extract():
    # 🟢 Automatically find the file in the same folder as this script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, 'newdataset.csv')

    if not os.path.exists(file_path):
        print(f"❌ Error: Could not find {file_path}")
        print("Make sure your CSV is named exactly 'newdataset.csv'")
        return

    # 1. Load the dataset
    df = pd.read_csv(file_path)

    # 2. Clean column names (remove spaces and make lowercase)
    df.columns = df.columns.str.strip().str.lower()

    # 3. Clean the 'disease' column data (Normalizing AIDS/aids)
    df['disease'] = df['disease'].str.strip().str.lower()

    # 4. Calculate the mathematical weights (The "Brain")
    weights = df.groupby('disease').mean()

    print("\n--- 🧠 COPY THIS INTO FLUTTER (federated_engine.dart) ---")
    print("static final Map<String, Map<String, double>> _modelWeights = {")
    for disease, row in weights.iterrows():
        print(f'    "{disease}": {{')
        for symptom, val in row.items():
            if val > 0.1: # Only export symptoms that are medically relevant
                print(f'      "{symptom}": {round(val, 3)},')
        print('    },')
    print("};")
    print("--- END OF CODE ---")

if __name__ == "__main__":
    train_and_extract()