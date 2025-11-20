import os
import numpy as np
import pandas as pd

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
INPUT_DIR = os.path.join(BASE_DIR, "input")
os.makedirs(INPUT_DIR, exist_ok=True)

np.random.seed(42)
n_samples = 15

sample_ids = [f"S{i:03d}" for i in range(1, n_samples + 1)]

# 1. Метаданные образцов
metadata = pd.DataFrame({
    "sample_id": sample_ids,
    "patient_id": np.random.randint(1000, 1100, size=n_samples),
    "group": np.random.choice(["control", "treated"], size=n_samples),
    "collection_date": pd.date_range("2024-01-01", periods=n_samples).strftime("%Y-%m-%d")
})
metadata.to_csv(os.path.join(INPUT_DIR, "sample_metadata.csv"), index=False)

# 2. Результаты масс-спектрометрии
ms_results = pd.DataFrame({
    "sample_id": np.random.choice(sample_ids, size=n_samples, replace=True),
    "feature_id": [f"F{i:03d}" for i in range(1, n_samples + 1)],
    "intensity": (np.random.rand(n_samples) * 1e5).round(2)
})
ms_results.to_csv(os.path.join(INPUT_DIR, "ms_results.csv"), index=False)

# 3. Данные о качестве
quality = pd.DataFrame({
    "sample_id": np.random.choice(sample_ids, size=n_samples, replace=True),
    "qc_flag": np.random.choice(["pass", "fail"], size=n_samples),
    "signal_to_noise": (np.random.rand(n_samples) * 100).round(2)
})
quality.to_csv(os.path.join(INPUT_DIR, "quality_data.csv"), index=False)

print("Файлы успешно сгенерированы !!!")
