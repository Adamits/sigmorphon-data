#! /bin/sh
#Train one model for all Germanic languages, and augment to be ~ 52000 training examples

ROOT="$1"
SETTING="medium"
FN="germanic"
LANGSTRING="norwegian-bokmal english icelandic norwegian-nynorsk dutch german swedish danish faroese"
FACTOR="6"
EPOCHS="20"

python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGSTRING" "train" "$SETTING" "$FN" "lang_distinct"
python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGSTRING" "dev" "$SETTING" "$FN" "lang_distinct"
python "$ROOT"/sigmorphon-data/scripts/augment.py "$ROOT"/sigmorphon-data/data/"$FN"-train-"$SETTING"-lang_distinct "$FACTOR"
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-train-"$SETTING"-lang_distinct-augmented "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-dev-lang_distinct "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-train-"$SETTING"-lang_distinct-augmented-src.txt -train_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-train-"$SETTING"-lang_distinct-augmented-tgt.txt -valid_src  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-dev-lang_distinct-src.txt -valid_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-dev-lang_distinct-tgt.txt -save_data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct-augmented
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct-augmented -save_model "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct-model-augmented -epochs "$EPOCHS"
