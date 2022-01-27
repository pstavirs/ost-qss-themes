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
    'density_scale': -2,
}

customqrc = True

app = PyQt5.QtWidgets.QApplication(sys.argv)

for xmlfile,qssfile in themes:
    prefix = f':/ostinato.org/themes'
    resdir = f'{qssfile[:-4]}'
    qrcfile = qssfile.replace('.qss', '.qrc')
    export_theme(xmlfile,
                 qssfile,
                 rcc = None if customqrc else qrcfile,
                 output=resdir,
                 prefix=f'{prefix}/{resdir}/',
                 invert_secondary=True if 'light' in qssfile else False,
                 extra=extra)

    if customqrc:
        files = glob.glob(resdir + '/**', recursive=True)
        with open(qrcfile, 'w') as qrc:
            qrc.write('<!DOCTYPE RCC>\n<RCC version="1.0">\n')
            qrc.write(f'  <qresource prefix="{prefix[2:]}">\n')
            for f in files:
                if not os.path.isdir(f):
                    f2 = f.replace('\\', '/')
                    qrc.write(f'    <file>{f2}</file>\n')
            qrc.write('  </qresource>\n')
            qrc.write('</RCC>\n')

    rccfile = qrcfile.replace('.qrc', '.rcc')
    subprocess.run(['rcc', '--binary', '-o', rccfile, qrcfile])
