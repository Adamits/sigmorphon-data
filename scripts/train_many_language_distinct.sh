#! /bin/sh
#Preproceses, generates files, and trains on the data
#Accepts a list of languages to train on, and considers all languages as the same

ROOT="$1"
SETTING="$2"
FN="$3"

read -p "Which languages? " LANGS

LANGSTRING=$( IFS=$','; echo "${LANGS[*]}" )

if [ $LANGSTRING = "all" ]
then
  # just harcode all languages in the dataset, space delimited
  LANGSTRING="albanian arabic armenian basque bengali bulgarian catalan czech danish dutch english estonian faroese finnish french georgian german haida hebrew hindi hungarian icelandic irish italian khaling kurmanji latin latvian lithuanian lower-sorbian macedonian navajo northern-sami norwegian-bokmal norwegian-nynorsk persian polish portuguese quechua romanian russian scottish-gaelic serbo-croatian slovak slovene sorani spanish swedish turkish ukrainian urdu welsh"

python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGSTRING" "train" "$SETTING" "$FN" "lang_distinct"
python "$ROOT"/sigmorphon-data/scripts/merge_data.py "$ROOT"/sigmorphon-data/data/ "$LANGSTRING" "dev" "$SETTING" "$FN" "lang_distinct"
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-train-"$SETTING"-lang_distinct "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/sigmorphon-data/scripts/conll2onmt.py "$ROOT"/sigmorphon-data/data/"$FN"-dev-lang_distinct "$ROOT"/sigmorphon-data/ONMT_data
python "$ROOT"/OpenNMT-py/preprocess.py -train_src  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-train-"$SETTING"-lang_distinct-src.txt -train_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-train-"$SETTING"-lang_distinct-tgt.txt -valid_src  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-dev-lang_distinct-src.txt -valid_tgt  "$ROOT"/sigmorphon-data/ONMT_data/"$FN"-dev-lang_distinct-tgt.txt -save_data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct
python "$ROOT"/OpenNMT-py/train.py -data "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct -save_model "$ROOT"/sigmorphon-data/models/"$FN"-"$SETTING"-lang_distinct-model
