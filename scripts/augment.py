# -*- coding: utf-8 -*-
from language_models import n_gram
from sys import argv, stderr
import codecs

"""
Augment to a data file using a language model, and then output that to a file
by the same name + "-augmented"
"""

if __name__=='__main__':
  if len(argv) != 3:
        stderr.write(("USAGE: python3 %s data_file factor") % argv[0])
        exit(1)

  FN = argv[1]
  FACTOR = argv[2]

  data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']
  data_aug = []
  print("Augmenting data...")
  for l in data:
      lemma, wf, tags = l
      tags = tuple(tags.split(";"))
      data_aug.append((lemma, wf, tags))

  with codecs.open(FN + "-augmented", "w", 'utf-8') as out:
    out.write("\n".join(["\t".join([lemma, wf, ";".join(tags)]) for lemma, wf, tags in n_gram.augment(data_aug, int(FACTOR))]))
