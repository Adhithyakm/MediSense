import pandas as pd
from .models import LocalBody

def run():
    df = pd.read_excel("final.xlsx")

    for _, row in df.iterrows():
        LocalBody.objects.create(
            district_name=row["District_Name"],
            local_body_type=row["Local_Body_Type"],
            local_body_name=row["Local_Body_Name"]
        )
