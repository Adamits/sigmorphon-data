# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT
"""

if __name__=='__main__':
  if len(argv) != 6:
        stderr.write(("USAGE: python3 %s train_file dev_file test_file output language-setting") % argv[0])
        exit(1)

  TRAIN_FN=argv[1]
  DEV_FN=argv[2]
  TEST_FN = argv[3]
  output = argv[4]
  lang_setting = argv[5]

  train_data = [l.strip().split('\t') for l in codecs.open(TRAIN_FN, 'r', 'utf-8') if l.strip() != '']
  dev_data = [l.strip().split('\t') for l in codecs.open(DEV_FN, 'r', 'utf-8') if l.strip() != '']
  test_data = [l.strip().split('\t') for l in codecs.open(TEST_FN, 'r', 'utf-8') if l.strip() != '']

  with codecs.open(output + "/train-" + lang_setting + "-src.txt", "w", 'utf-8') as t_out_src:
    t_out_src.write("\n".join([" ".join([l for l in t_lemma]) + " " + " ".join(t_label.split(";")) for t_lemma, _, t_label in train_data]))

  with codecs.open(output + "/train-" + lang_setting + "-tgt.txt", "w", 'utf-8') as t_out_tgt:
    t_out_tgt.write("\n".join([" ".join([w for w in t_wf]) for _, t_wf, _ in train_data]))

  with codecs.open(output + "/val-" + lang_setting + "-src.txt", "w", 'utf-8') as v_out_src:
    v_out_src.write("\n".join([" ".join([l for l in v_lemma]) + " " + " ".join(v_label.split(";")) for v_lemma, _, v_label in dev_data]))

  with codecs.open(output + "/val-" + lang_setting + "-tgt.txt", "w", 'utf-8') as v_out_tgt:
    v_out_tgt.write("\n".join([" ".join([w for w in v_wf]) for _, v_wf, _ in dev_data]))

  with codecs.open(output + "/test-" + lang_setting + "-src.txt", "w", 'utf-8') as test_out_src:
    test_out_src.write("\n".join([" ".join([l for l in t_lemma]) + " " + " ".join(t_label.split(";")) for t_lemma, _, t_label in test_data]))

  with codecs.open(output + "/test-" + lang_setting + "-tgt.txt", "w", 'utf-8') as test_out_tgt:
    test_out_tgt.write("\n".join([" ".join([w for w in t_wf]) for _, t_wf, _ in test_data]))
