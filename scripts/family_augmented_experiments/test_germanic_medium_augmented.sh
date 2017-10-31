#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
SETTING="$3"
MODEL_FN="$(basename $MODEL)"

MODEL_FN="${MODEL_FN%.*}"
LANGSTRING="norwegian-bokmal english icelandic norwegian-nynorsk dutch german swedish danish faroese"


IFS=' ' read -r -a LANGSARRAY <<< "$LANGSTRING"

ACCFILE="$ROOT"/sigmorphon-data/accuracies/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}".acc

if [ -e "$ACCFILE" ]
then
    rm "$ACCFILE"
fi

for lang in "${LANGSARRAY[@]}"
do
  python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/answers/ "$lang" "test" "$SETTING" "$lang" "lang_distinct"
  python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$lang"-uncovered-test-lang_distinct "$ROOT"/sigmorphon-data/ONMT_data
  python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_distinct-src.txt -tgt "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_distinct-tgt.txt  -output "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN-${lang//[[:blank:]]/}"-pred.txt -replace_unk
  # Write to the accuracies file
  ACC=$(python "$ROOT"/sigmorphon-data/scripts/evalm.py --gold "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_distinct-tgt.txt --guess "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN-${lang//[[:blank:]]/}"-pred.txt)
  echo "$lang: $ACC" >> "$ACCFILE"
done

python "$ROOT"/sigmorphon-data/scripts/calculate_total_accuracies.py "$ROOT"/sigmorphon-data/accuracies/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}".acc
