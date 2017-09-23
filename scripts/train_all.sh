#! /bin/sh
#Preproceses, generates files, and trains on the data
#Accepts a list of languages to train on

ROOT="$1"
SETTING="$2"
FN="$3"
LANGS=("albanian" "arabic" "armenian" "basque" "bengali" "bulgarian" "catalan" "czech" "danish" "dutch" "english" "estonian" "faroese" "finnish" "french" "georgian" "german" "haida" "hebrew" "hindi" "hungarian" "icelandic" "irish" "italian" "khaling" "kurmanji" "latin" "latvian" "lithuanian" "lower-sorbian" "macedonian" "navajo" "northern-sami" "norwegian-bokmal" "norwegian-nynorsk" "persian" "polish" "portuguese" "quechua" "romanian" "russian" "scottish-gaelic" "serbo-croatian" "slovak" "slovene" "sorani" "spanish" "swedish" "turkish" "ukrainian" "urdu" "welsh")

python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGS" "train" "$FN"
python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGS" "dev" "$FN"
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-train-"$SETTING" "train" "$ROOT"/sigmorphon-data/ONMT_data "$FN"-"$SETTING"
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-dev "dev" "$ROOT"/sigmorphon-data/ONMT_data "$FN"-"$SETTING"
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/sigmorphon-data/ONMT_data/train-"$FN"-"$SETTING"-src.txt -train_tgt  "$ROOT"/sigmorphon-data/ONMT_data/train-"$FN"-"$SETTING"-tgt.txt -valid_src  "$ROOT"/sigmorphon-data/ONMT_data/val-"$FN"-"$SETTING"-src.txt -valid_tgt  "$ROOT"/sigmorphon-data/ONMT_data/val-"$FN"-"$SETTING"-tgt.txt -save_data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING" -save_model "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-model
