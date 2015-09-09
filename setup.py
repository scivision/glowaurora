#!/usr/bin/env python3
import setuptools #needed to enable develop
from numpy.distutils.core import setup,Extension
from os.path import join,expanduser,basename
from glob import glob
from shutil import move
from os import symlink,chdir,environ,getcwd

# f2py -m aurora -c egrid.f maxt.f glow.f vquart.f gchem.f ephoto.f solzen.f rcolum.f etrans.f exsect.f ssflux.f snoem.f snoemint.f geomag.f nrlmsise00.f qback.f fieldm.f iri90.f aurora_sub.f

fortranfiles=['egrid.f','maxt.f','glow.f',
              'vquart.f','gchem.f','ephoto.f','solzen.f','rcolum.f',
              'etrans.f','exsect.f','ssflux.f','snoem.f','snoemint.f',
              'geomag.f','nrlmsise00.f','qback.f','fieldm.f','iri90.f',
              'aurora_sub.f']

root='fortran'

fortranpaths = [join(root,f) for f in fortranfiles]
fortdata = glob(join(root,'*.dat'))

#%%
with open('README.rst') as f:
	long_description = f.read()

ext=[Extension(name='glowfort',
               sources=fortranpaths,
               f2py_options=['--quiet'],
)]
               #include_dirs=[root],
               #library_dirs=[root])]

#%% install
setup(name='glowaurora',
      version='0.1',
	  description='Python wrapper for Stan Solomon GLOW auroral model',
	  long_description=long_description,
	  author='Michael Hirsch',
	  author_email='hirsch617@gmail.com',
	  url='https://github.com/scienceopen/glowaurora',
      packages=['glowaurora'],
#      package_dir={'glowaurora': 'glowaurora'}, #not working
 #     package_data={'glowaurora': ['fortran/*.dat']}, #not working, use data_files
      include_package_data=True,
      ext_modules=ext,
      data_files=[('glowaurora',fortdata) ], #must have data_files to copy *.dat to site-packages

	  install_requires=['msise00','pymap3d', 'histutils',
                         'numpy','pandas','astropy'],
      dependency_links = ['https://github.com/scienceopen/msise00/tarball/master#egg=msise00',
                          'https://github.com/scienceopen/histutils/tarball/master#egg=histutils',
                          'https://github.com/scienceopen/pymap3d/tarball/master#egg=pymap3d'
                            ],
      )
#%% TODO hack to pickup .dat files
EXE='glowfort.so'

print('hacking in ' +getcwd())
for f in fortdata:
    print('linking ' + f)
    symlink(f,basename(f))


#%% FIXME manual monkeypatch of fortran data due to missing path
chdir(environ['HOME']) #to ensure installed package is loaded, NOT the local dir
import glowaurora
P = glowaurora.__path__[0]
print('package path {}'.format(P))

#print('copying executable '+EXE)
#copy2(join(P,EXE))

for f in glob(join(P,'glowfort.*')):
    print('moving ' + f)
    move(f,P+'/glowaurora')

