#!/usr/bin/env python3
import os


script_dir = os.path.dirname(os.path.realpath(__file__))

# change cwd to example directory
os.chdir(script_dir)

# build apk
cmd = f'flutter build apk --release --split-per-abi'
os.system(cmd)

files = os.listdir('build/app/outputs/flutter-apk')

# upload github
