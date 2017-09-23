# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Convert data from ConLL Sigmorph shared task on morphological reinflection
to format necessary to use OpenNMT
"""

if __name__=='__main__':
  if len(argv) != 6:
        stderr.write(("USAGE: python3 %s data_file mode(train, dev, test) output language-setting") % argv[0])
        exit(1)

  FN = argv[1]
  mode = argv[2]
  output = argv[3]
  lang_setting = argv[4]

  data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']

  with codecs.open(output + "/" + mode + "-" + lang_setting + "-src.txt", "w", 'utf-8') as out_src:
    out_src.write("\n".join([" ".join([l for l in lemma]) + " " + " ".join(label.split(";")) for lemma, _, label in data]))

  with codecs.open(output + "/train-" + lang_setting + "-tgt.txt", "w", 'utf-8') as out_tgt:
    out_tgt.write("\n".join([" ".join([w for w in wf]) for _, wf, _ in data]))
