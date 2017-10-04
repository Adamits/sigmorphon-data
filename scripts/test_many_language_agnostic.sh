#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
SETTING="$3"
MODEL_FN="$(basename $MODEL)"

MODEL_FN="${MODEL_FN%.*}"

read -p "Which languages? " LANGS

LANGSTRING=$( echo "${LANGS[*]}" )

if [ "$LANGSTRING" = "all" ]
then
  # just harcode all languages in the dataset, space delimited
  LANGSTRING="albanian arabic armenian basque bengali bulgarian catalan czech danish dutch english estonian faroese finnish french georgian german haida hebrew hindi hungarian icelandic irish italian khaling kurmanji latin latvian lithuanian lower-sorbian macedonian navajo northern-sami norwegian-bokmal norwegian-nynorsk persian polish portuguese quechua romanian russian scottish-gaelic serbo-croatian slovak slovene sorani spanish swedish turkish ukrainian urdu welsh"
fi

IFS=' ' read -r -a LANGSARRAY <<< "$LANGSTRING"

ACCFILE="$ROOT"/sigmorphon-data/accuracies/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}".acc

if [ -e "$ACCFILE" ]
then
    rm "$ACCFILE"
fi

for lang in "${LANGSARRAY[@]}"
do
  python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/answers/ "$lang" "test" "$SETTING" "$lang" "lang_agnostic"
  python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$lang"-uncovered-test-lang_agnostic "$ROOT"/sigmorphon-data/ONMT_data
  python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_agnostic-src.txt -tgt "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_agnostic-tgt.txt  -output "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}"-pred.txt -replace_unk
  # Write to the accuracies file
  ACC=$(python "$ROOT"/sigmorphon-data/scripts/evalm.py --gold "$ROOT"/sigmorphon-data/ONMT_data/"$lang"-uncovered-test-lang_agnostic-tgt.txt --guess "$ROOT"/sigmorphon-data/predictions/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}"-pred.txt)
  echo "$lang: $ACC" >> "$ACCFILE"
done

python "$ROOT"/sigmorphon-data/scripts/calculate_total_accuracies.py "$ROOT"/sigmorphon-data/accuracies/"$MODEL_FN-${LANGSTRING//[[:blank:]]/}".acc
