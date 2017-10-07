#! /bin/sh
#  s to input data, Preproceses, generates files, and trains on the data
# Assumes that dev data is already there and formatted in the ONMT_data folder

ROOT="$1"
INFILE="$2"
DEVFILE="$3"
FACTOR="$4"
EPOCHS="5"

python "$ROOT"/sigmorphon-data/scripts/augment.py "$ROOT"/sigmorphon-data/data/"$INFILE" "$FACTOR"
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$INFILE"-augmented "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/sigmorphon-data/ONMT_data/"$INFILE"-augmented-src.txt -train_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$INFILE"-augmented-tgt.txt -valid_src  "$ROOT"/sigmorphon-data/ONMT_data/"$DEVFILE"-src.txt -valid_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$DEVFILE"-tgt.txt -save_data "$ROOT"/sigmorphon-data/models/"$INFILE"-augmented
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/sigmorphon-data/models/"$INFILE"-augmented -save_model "$ROOT"/sigmorphon-data/models/"$INFILE"-augmented -epochs "$EPOCHS"
