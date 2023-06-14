#!/usr/bin/env python3
import os


def upgrade_example_version(path: str):
    with open(path, 'r') as f:
        lines = f.readlines()
        result = []
        for line in lines:
            if line.startswith('version:'):
                version: str = line.split(':')[1].strip()

                version_list = version.split('+')
                version_list[1] = str(int(version_list[1]) + 1)
                new_version = '+'.join(version_list)

                result.append(f'version: {new_version}')
            else:
                result.append(line)
    with open(path, 'w') as f:
        f.writelines(result)


script_dir = os.path.dirname(os.path.realpath(__file__))

# change cwd to example directory
os.chdir(script_dir)
upgrade_example_version(f'{script_dir}/pubspec.yaml')

# # build apk
cmd = f'flutter build apk --release --split-per-abi'
os.system(cmd)

# files = os.listdir('build/app/outputs/flutter-apk')

# upload github
