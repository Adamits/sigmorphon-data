# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Lookup the data for multiple files and generate a single one
in that same directory with the contents of all the input files
"""

if __name__=='__main__':
  if len(argv) != 7:
        stderr.write(("USAGE: python3 %s input_dir languages mode(train dev test) setting(low, medium, high) outfile_name merge_type(lang_agnostic or lang_distinct)") % argv[0])
        exit(1)

  input_dir = argv[1]
  languages = argv[2]
  mode = argv[3]
  setting = argv[4]
  outfile_name = argv[5]
  merge_type = argv[6]


  if mode == "train":
    end = "-" + mode + "-" + setting
  elif mode == "dev":
    end = "-" + mode
  elif mode == "test":
    end = "-covered-" + test

  if merge_type == "lang_agnostic":
    with codecs.open(input_dir + outfile_name + end + "-" + merge_type, "w", 'utf-8') as out:
      for lang in languages.split(" "):
        FN = input_dir + lang + end
        out.write(codecs.open(FN, "r").read())

  elif merge_type == "lang_distinct":
    with codecs.open(input_dir + outfile_name + end + "-" + merge_type, "w", 'utf-8') as out:
      for lang in languages.split(" "):
        FN = input_dir + lang + end
        data = [l.strip().split('\t') for l in codecs.open(FN, 'r', 'utf-8') if l.strip() != '']
        out.write("\n".join(["%s\t%s\t%s;%s" % (lemma, wf, label, lang) for lemma, wf, label in data]) + "\n")
  else:
    raise Exception("Please choose a merge_type of either lang_agnostic or lang_distinct")
