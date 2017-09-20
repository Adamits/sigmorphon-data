#! /bin/sh
#Preproceses, generates files, and trains on the data

source ~/virtual-envs/OpenNMT-py-env/bin/activate

LANG="$1"
SETTING="$2"

python ~/sigmorphon_data/scripts/conll2onmt.py ~/sigmorphon_data/data/"$LANG"-train-"$SETTING" ~/sigmorphon_data/data/"$LANG"-dev ~/sigmorphon_data/answers/"$LANG"-uncovered-test ~/sigmorphon_data/ONMT_data "$LANG"-"$SETTING"
python ~/OpenNMT-py/preprocess.py -train_src  ~/sigmorphon_data/ONMT_data/train-"$LANG"-"$SETTING"-src.txt -train_tgt  ~/sigmorphon_data/ONMT_data/train-"$LANG"-"$SETTING"-tgt.txt -valid_src  ~/sigmorphon_data/ONMT_data/val-"$LANG"-"$SETTING"-src.txt -valid_tgt  ~/sigmorphon_data/ONMT_data/val-"$LANG"-"$SETTING"-tgt.txt -save_data ~/sigmorphon_data/models/"$LANG"-"$SETTING"
python ~/OpenNMT-py/train.py -data ~/sigmorphon_data/models/"$LANG"-"$SETTING" -save_model ~/sigmorphon_data/models/"$LANG"-"$SETTING"-model
