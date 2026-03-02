import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import joblib

# 1. Load your CSV
df = pd.read_csv('finaldataset.csv')

# 2. Split features (symptoms) and target (disease)
X = df.drop('Disease', axis=1)
y = df['Disease']

# 3. Train the model
# We use RandomForest because it works best with 1/0 data
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)

# 4. Save the model and the column names
joblib.dump(model, 'disease_model.pkl')
joblib.dump(X.columns.tolist(), 'symptom_features.pkl')

print("Model trained and saved!")