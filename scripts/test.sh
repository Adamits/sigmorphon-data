#! /bin/sh
# Test a traned model on some data

source ~/virtual-envs/OpenNMT-py-env/bin/activate

MODEL="$1"
LANG="$2"
SETTING="$3"

python ~/OpenNMT-py/translate.py -model "$MODEL" -src ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-src.txt -tgt ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt  -output ~/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt -replace_unk -verbose
python ~/sigmorphon_data/scripts/evalm.py --gold ~/sigmorphon_data/ONMT_data/test-"$LANG"-"$SETTING"-tgt.txt --guess ~/sigmorphon_data/predictions/"$LANG-$SETTING"-pred.txt
