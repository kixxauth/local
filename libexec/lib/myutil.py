import sys


def key_usb_path():
    if sys.platform == 'darwin':
        return '/Volumes/KEYS'
    if sys.platform == 'linux2':
        return '/media/KEYS'
    return None
