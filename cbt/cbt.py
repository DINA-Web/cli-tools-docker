#!/bin/env python

from collectionbatchtool import *
import argparse

parser = argparse.ArgumentParser(
    description = "Script to upload data from csv into DINA")

#parser.add_argument("infile", help = "csv formatted file, see docs for the exact format")

parser.add_argument("-c", "--config", 
    help = "path to config file", 
    type = argparse.FileType('rU'),
    default = "dina.cfg")

args = parser.parse_args()

apply_user_settings(args.config.name)

print("hello world")

