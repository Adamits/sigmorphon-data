#! /bin/bash
#Preproceses, generates files, and trains on the data, and tests
#One model for each language

# THIS USES THE MODEL FOR THE LANG SETTING AT EPOCH 13, IF THERE ARE MULTIPLE MODELS
# AT EPOCH 13 (i.e. this is a second, or more, round of training), THE SCRIPT WILL MESS UP

ROOT="$1"
SETTING="$2"

for l in albanian arabic armenian basque bengali bulgarian catalan czech danish dutch english estonian faroese finnish french georgian german haida hebrew hindi hungarian icelandic irish italian khaling kurmanji latin latvian lithuanian lower-sorbian macedonian navajo northern-sami norwegian-bokmal norwegian-nynorsk persian polish portuguese quechua romanian russian scottish-gaelic serbo-croatian slovak slovene sorani spanish swedish turkish ukrainian urdu welsh; do
  echo "$l"
  /bin/bash "$ROOT"/sigmorphon-data/scripts/train.sh "$ROOT" "$l" "$SETTING"
  models=$(find "$ROOT"/sigmorphon-data/models -name "$l"-"$SETTING"-model_acc_*.pt)
  last_acc=0.0
  for model in ${models[@]}; do
    model_acc=$(echo "$model" | cut -d'_' -f3)
    model_int=$(echo "$model_acc" | cut -d'.' -f1)
    model_dec=$(echo "$model_acc" | cut -d'.' -f2)
    last_int=$(echo "$last_acc" | cut -d'.' -f1)
    last_dec=$(echo "$last_acc" | cut -d'.' -f2)
    if [ $model_int -lt $last_int ]; then
      model_acc=$last_acc
    elif [ $model_int == $last_int ] && [ $model_dec -lt $last_dec ]; then
      model_acc=$last_acc
    fi
    last_acc=$model_acc
  done
  BESTMODEL=$(find "$ROOT"/sigmorphon-data/models -name "$l"-"$SETTING"-model_acc_"$model_acc"*)
  # If there are multiple models with the same acc, just take the first one
  OLDIFS="$IFS"
  IFS="\n"
  BESTMODEL_ARRAY=( $BESTMODEL )
  BESTMODEL=${BESTMODEL_ARRAY[0]}
  IFS=$OLDIFS
  /bin/bash "$ROOT"/sigmorphon-data/scripts/test.sh "$ROOT" "$BESTMODEL" "$l" "$SETTING"
done
