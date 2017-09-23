#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"

python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$LANG"-uncovered-test "test" "$ROOT"/sigmorphon-data/ONMT_data "$LANG"-"$SETTING"
python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-src.txt -tgt "$ROOT"/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt  -output "$ROOT"/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt -replace_unk -verbose
python "$ROOT"/sigmorphon_data/scripts/evalm.py --gold "$ROOT"/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt --guess "$ROOT"/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt
