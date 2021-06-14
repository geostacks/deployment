{
  current ? import (builtins.fetchTarball {
              url = "https://github.com/NixOS/nixpkgs/archive/ae1c8ede09b53007ba9b3c32f926c9c03547ae8b.tar.gz";
              sha256 = "1lpphn9dcf8vh8ia38f472i7cqggp3knpfa2jwlc6z5ldbvrw7ki";
             }) {}
}:

with current;

stdenv.mkDerivation rec {

  name = "env" ;
  builder = builtins.toFile "builder.sh" ''
  source $stdenv/setup; ln-s $env $out
  '';

  buildInputs = [ git hdf4 gcc wget libjpeg openjpeg python38
    (python38.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python38Packages; [
        numpy
        scipy
        jupyterlab
        traittypes
        branca
        flake8
        matplotlib
        boto3
        intake
        (dask.override { withExtraComplete = true; })
	    pip
        notebook
        cython
        pandas
        wheel
        setuptools
        pyrsistent
        nbconvert
        seaborn
        gdal
        h5py
        datashader
        netcdf4
	    shapely
	    pyproj
        lib
	    numba
        flask
        joblib
        geos
        scikitlearn
        xarray
        six
	    time
	    pillow
	    gzip
	    setuptools
	    cycler
        rasterio
	    ipython
	    nbformat
	    ipywidgets
      ];
     })
    ];

    shellHook = ''
            alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
            export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.8/site-packages:$PYTHONPATH"
            export PREFIX_PATH="$(pwd)/_build/pip_packages"
            pip install  ipyleaflet --prefix=$PREFIX_PATH
            jupyter nbextension install --py --symlink --user ipyleaflet
            jupyter nbextension enable --py --user ipyleaflet
      '';
}
