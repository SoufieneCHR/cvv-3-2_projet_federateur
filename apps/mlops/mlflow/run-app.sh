#!/bin/bash


python3 -m pip install --upgrade pip

#Create python venv
python3 -m venv .venv
source .venv/bin/activate
#install dependencies
pip install mlflow scikit-learn shap matplotlib
sleep 200
export MLFLOW_EXPERIMENT_NAME='my-sample-experiment'
export MLFLOW_TRACKING_URI='http://192.168.56.7' # change port
