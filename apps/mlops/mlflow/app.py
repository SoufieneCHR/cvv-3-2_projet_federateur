import os
import numpy as np
import shap
from sklearn.datasets import load_diabetes
from sklearn.linear_model import LinearRegression

import mlflow
from mlflow.artifacts import download_artifacts
from mlflow.tracking import MlflowClient

# Prepare the Training Data
X, y = load_diabetes(return_X_y=True, as_frame=True)
X = X.iloc[:50, :4]
y = y.iloc[:50]

# Train a model
model = LinearRegression()
model.fit(X, y)

with mlflow.start_run() as run:
    mlflow.shap.log_explanation(model.predict, X)

client = MlflowClient()
artifact_path = "model_explanations_shap"
artifacts = [x.path for x in client.list_artifacts(run.info.run_id, artifact_path)]
print("# artifacts:")
print(artifacts)

dst_path = download_artifacts(run_id=run.info.run_id, artifact_path=artifact_path)
base_values = np.load(os.path.join(dst_path, "base_values.npy"))
shap_values = np.load(os.path.join(dst_path, "shap_values.npy"))

shap.initjs()   
shap.force_plot(float(base_values), shap_values[0, :], X.iloc[0, :], matplotlib=True)
