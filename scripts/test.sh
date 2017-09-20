#! /bin/sh
# Test a traned model on some data

source ~/virtual-envs/OpenNMT-py-env/bin/activate

ROOT="$1"
MODEL="$2"
LANG="$3"
SETTING="$4"

python ~/OpenNMT-py/translate.py -model "$MODEL" -src ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-src.txt -tgt ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt  -output ~/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt -replace_unk -verbose
python ~/sigmorphon_data/scripts/evalm.py --gold ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt --guess ~/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt
