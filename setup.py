from setuptools import setup, find_packages
from setuptools.extension import Extension
from distutils.command.build_ext import build_ext as du_build_ext

class build_ext(du_build_ext):
    def run(self):
        from Cython.Build.Dependencies import cythonize
        self.distribution.ext_modules[:] = cythonize(
            self.distribution.ext_modules,
            include_path = ["primecount"],
            language_level=3)
        du_build_ext.run(self)


with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

extensions = [
    Extension(
        "primecount.primecount",
#        include_dirs = ["/usr/local/include"],
        sources=["primecount/primecount.pyx"],
        language="c++",
        libraries=["primecount"]),
#    Extension(
#        "primecount.test",
#        sources=["primecount/test.pyx"]),
    ]

setup(
    name='primecount',
    version='0.1.2',
    description='bla',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/dimpase/primecount',
    author='Vincent',
    author_email='sage-devel@googlegroups.com',
    license='GPLv3',
#    language_level=3,
    packages=find_packages(),
#    include_dirs = ["/usr/local/include"],
    ext_modules=extensions,
    zip_safe=False,
    python_requires='>=3.7',
    package_dir={'primecount': 'primecount'},
    install_requires=["Cython"],
    package_data={"primecount": ["*.pxd"]},
    cmdclass={'build_ext': build_ext},
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Programming Language :: Python :: 3',
        'Topic :: Scientific/Engineering :: Mathematics']
    )
