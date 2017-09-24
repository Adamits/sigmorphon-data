#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"
MODEL_FN="$(basename $MODEL)"

#Don't need to use merge to do "language_agnostic" change since that is the default behavior
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$LANG"-uncovered-test "test" "$ROOT"/sigmorphon-data/ONMT_data "$LANG"-"$SETTING"
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-src.txt -tgt "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt  -output "$ROOT"/sigmorphon-data/predictions/"$LANG-$SETTING-$MODEL_FN"-pred.txt -replace_unk -verbose
python "$ROOT"/sigmorphon-data/scripts/evalm.py --gold "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt --guess "$ROOT"/sigmorphon-data/predictions/"$LANG-$SETTING-$MODEL_FN"-pred.txt
