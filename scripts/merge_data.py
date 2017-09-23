# -*- coding: utf-8 -*-

from sys import argv, stderr
import codecs

"""
Lookup the data for multiple files and generate a single one
in that same directory with the contents of all the input files
"""

if __name__=='__main__':
  if len(argv) != 6:
        stderr.write(("USAGE: python3 %s input_dir languages mode(train dev test) setting(low, medium, high) outfile_name") % argv[0])
        exit(1)

  input_dir = argv[1]
  languages = argv[2]
  mode = argv[3]
  outfile_name = argv[4]

  if setting == "train":
    end = "-" + setting + "-" + mode
  elif setting == "dev":
    end = "-" + setting
  elif setting == "test":
    end = "-covered-" + test

  with codecs.open(input_dir + "/" + outfile_name, "w", 'utf-8') as out:
    for lang in languages:
      FN = input_dir + "/" + lang + end
      out.write(FN.read())
