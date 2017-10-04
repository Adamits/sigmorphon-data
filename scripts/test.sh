#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"
MODEL_FN="$(basename $MODEL)"

python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$LANG"-uncovered-test "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon-data/ONMT_data/"$LANG"-uncovered-test-src.txt -tgt "$ROOT"/sigmorphon-data/ONMT_data/"$LANG"-uncovered-test-tgt.txt  -output "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN"-pred.txt -replace_unk
ACC=$(python "$ROOT"/sigmorphon-data/scripts/evalm.py --gold "$ROOT"/sigmorphon-data/ONMT_data/"$LANG"-uncovered-test-tgt.txt --guess "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN"-pred.txt)
ACCFILE="$ROOT"/sigmorphon-data/accuracies/"$MODEL_FN".acc

if [ -e "$ACCFILE" ]
then
    rm "$ACCFILE"
fi
echo "$LANG: $ACC" >> "$ACCFILE"
