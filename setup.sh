
PROJECT_NAME="carpricer"
CONDA_ENV_NAME="carpricer"
CONDA_ENV_PYTHON="3.8.5"
CONDA_FILE=""
PIP_REQUIREMENTS=".aml/jobs/docker-context/requirements.txt"

echo "Creating a conda environment"
if [ -z "$CONDA_FILE" ]; then
    conda create -y -n $CONDA_ENV_NAME Python=$CONDA_ENV_PYTHON
else
    conda env create --name $CONDA_ENV_NAME -f $CONDA_FILE
fi
. $(conda info --json | jq -r '.root_prefix')/etc/profile.d/conda.sh
conda activate $CONDA_ENV_NAME
conda install -y jupyter ipykernel
if [ -n "$PIP_REQUIREMENTS" ]; then
    pip install -r $PIP_REQUIREMENTS --quiet
fi
python -m ipykernel install --user --name $CONDA_ENV_NAME --display-name "Python ($CONDA_ENV_NAME)"

echo "Configuring PYTHONPATH for the project"
PYTHON_SITE=$(python -m site --user-site)
mkdir -p $PYTHON_SITE
cat >> $PYTHON_SITE/$PROJECT_NAME.pth <<EOF
$PWD/src
EOF
