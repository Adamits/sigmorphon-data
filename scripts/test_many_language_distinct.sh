#! /bin/sh
# Test a traned model on some data

ROOT="$1"
MODEL="$2"
SETTING="$3"
MODEL_FN="$(basename $MODEL)"

read -p "Which languages? " LANGS

LANGSTRING=$( echo "${LANGS[*]}" )

if [ "$LANGSTRING" = "all" ]
then
  # just harcode all languages in the dataset, space delimited
  LANGSTRING="albanian arabic armenian basque bengali bulgarian catalan czech danish dutch english estonian faroese finnish french georgian german haida hebrew hindi hungarian icelandic irish italian khaling kurmanji latin latvian lithuanian lower-sorbian macedonian navajo northern-sami norwegian-bokmal norwegian-nynorsk persian polish portuguese quechua romanian russian scottish-gaelic serbo-croatian slovak slovene sorani spanish swedish turkish ukrainian urdu welsh"
fi

IFS=' ' read -r -a LANGSARRAY <<< "$LANGSTRING"

cat "$ROOT"/accuracies/"$MODEL_FN".acc

for lang in LANGSARRAY
do
  python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANG" "test" "$SETTING" "$FN" "lang_distinct"
  python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/answers/"$LANG"-uncovered-test "test" "$ROOT"/sigmorphon-data/ONMT_data "$LANG"-"$SETTING"
  python "$ROOT"/OpenNMT-py/translate.py -model "$MODEL" -src "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-src.txt -tgt "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt  -output "$ROOT"/sigmorphon-data/predictions/"$LANG-$SETTING-$MODEL_FN"-pred.txt -replace_unk -verbose
  python "$ROOT"/sigmorphon-data/scripts/evalm.py --gold "$ROOT"/sigmorphon-data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt --guess "$ROOT"/sigmorphon-data/predictions/"$LANG-$SETTING-$MODEL_FN"-pred.txt
  echo "$lang": "$ACC"\n >> "$ROOT"/accuracies/"$MODEL_FN".acc
done

python "$ROOT"/sigmorphon-data/scripts/calculate_total_accuracies.py "$ROOT"/accuracies/"$MODEL_FN".acc
