import PyQt5
from qt_material import export_theme

import glob
import os
import subprocess
import sys

themes = [
    ('light_blue.xml', 'material-light.qss'),
    ('dark_amber.xml', 'material-dark.qss')
]

extra = {
}

app = PyQt5.QtWidgets.QApplication(sys.argv)

for xmlfile,qssfile in themes:
    prefix = 'theme:/'
    resdir = 'icons'
    export_theme(xmlfile,
                 qssfile,
                 output=resdir,
                 prefix=prefix,
                 invert_secondary=False,
                 extra=extra)

    files = glob.glob(resdir + '/**', recursive=True)
    qrcfile = qssfile.replace('.qss', '.qrc')
    with open(qrcfile, 'w') as qrc:
        qrc.write('<!DOCTYPE RCC><RCC version="1.0">\n')
        qrc.write(f'  <qresource prefix="{prefix}">\n')
        for f in files:
            if not os.path.isdir(f):
                f2 = f.replace('\\', '/')
                qrc.write(f'    <file>{f2}</file>\n')
        qrc.write('  </qresource>\n')
        qrc.write('</RCC>\n')

    rccfile = qrcfile.replace('.qrc', '.rcc')
    subprocess.run(['rcc', '--binary', '-o', rccfile, qrcfile])
