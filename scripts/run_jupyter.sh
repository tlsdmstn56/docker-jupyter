#!/bin/sh

SPARKENV_PATH="/root/volume/scripts/spark-env.sh"
REQUIREMENTS_PATH="/root/volume/docker/requirements.txt"
JUPYTERLOG_PATH="/root/volume/logs/jupyter.log"

mkdir -p /root/volume/logs

#Spark Env
echo "setting spark environment" >$JUPYTERLOG_PATH
cp $SPARKENV_PATH /usr/local/spark/conf/spark-env.sh

echo "install python modules in requirement.txt" >$JUPYTERLOG_PATH
pip2 install -r $REQUIREMENTS_PATH >> $JUPYTERLOG_PATH 2>&1
pip3 install -r $REQUIREMENTS_PATH >> $JUPYTERLOG_PATH 2>&1

mkdir /root/.jupyter >> $JUPYTERLOG_PATH 2>&1
cp /root/volume/docker/jupyter_notebook_config.py /root/.jupyter/ >> $JUPYTERLOG_PATH 2>&1
jupyter contrib nbextension install --user >> $JUPYTERLOG_PATH 2>&1
jupyter nbextensions_configurator enable --user >> $JUPYTERLOG_PATH 2>&1
jupyter nbextension enable tree-filter/index >> $JUPYTERLOG_PATH 2>&1
jupyter nbextension enable toggle_all_line_numbers/main >> $JUPYTERLOG_PATH 2>&1
jupyter nbextension enable toc2/main >> $JUPYTERLOG_PATH 2>&1
jupyter nbextension enable code_prettify/code_prettify >> $JUPYTERLOG_PATH 2>&1
jupyter nbextension enable codefolding/edit >> $JUPYTERLOG_PATH 2>&1
jupyter notebook --allow-root >> $JUPYTERLOG_PATH 2>&1
