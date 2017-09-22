#! /bin/sh
#Preproceses, generates files, and trains on the data

ROOT="$1"
LANG="$2"
SETTING="$3"

python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$LANG"-train-"$SETTING" "$ROOT"/sigmorphon-data/data/"$LANG"-dev "$ROOT"/sigmorphon-data/answers/"$LANG"-uncovered-test "$ROOT"/sigmorphon-data/ONMT_data "$LANG"-"$SETTING"
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/sigmorphon-data/ONMT_data/train-"$LANG"-"$SETTING"-src.txt -train_tgt  "$ROOT"/sigmorphon-data/ONMT_data/train-"$LANG"-"$SETTING"-tgt.txt -valid_src  "$ROOT"/sigmorphon-data/ONMT_data/val-"$LANG"-"$SETTING"-src.txt -valid_tgt  "$ROOT"/sigmorphon-data/ONMT_data/val-"$LANG"-"$SETTING"-tgt.txt -save_data "$ROOT"/sigmorphon-data/models/"$LANG"-"$SETTING"
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/sigmorphon-data/models/"$LANG"-"$SETTING" -save_model "$ROOT"/sigmorphon-data/models/"$LANG"-"$SETTING"-model
