
import numpy as np
import pandas as pd
import os
import glob

import netCDF4 as nc
import subprocess as sp

# ------------------------------------------------------------------------------
# Basic Functions
# Function 1 - clip tif to shape

def tif_to_nc(input, output, shp=None):

    # if shp is None: #no shapefile, this just converts tif to netCDF
    #     sp.check_output("gdal_translate -of netCDF {} {}".format(input, output), shell=True)

    if shp != None:    # if there is a shapefile, generate tmp_output, clip it, call it input
        output_tmp = output.split('.')[0]+'_tmp.tif' #parses output name and adds tmp.tif file
        sp.check_output("gdalwarp -of GTiff -dstnodata None -cutline {} -crop_to_cutline {} {}".format(shp, input, output_tmp), shell=True)
    else: #if no shapefile is called, just convert to netCDF
        output_tmp = input

    sp.check_output("gdal_translate -of netCDF {} {}".format(output_tmp, output), shell=True)

    if shp != None:
        sp.check_output('rm {}'.format(output_tmp), shell= True) #removes output_tmp items


#...............................................................................
# .........................   CALL FUNCTIONS   .................................
#...............................................................................

path = '/home/meganmason/Documents/projects/thesis/data/processing_lidar/depths_3m/equal_extent_data_downsize/{}/*.tif'
shp = '/home/meganmason/Documents/projects/thesis/maps/map_layers/tuolumne_delineation/corrected_tuolumne_subbasin.shp'

years = range(2013,2019)

for year in sorted(years):
    print('~~YEAR~~', year)
    flist_by_year = glob.glob(path.format(year))

    for f in sorted(flist_by_year):
        dir = os.path.dirname(f)
        dir_splt = os.path.split(dir)[0]
        dt_str = f.split("/")[-1] #splits on / and saves the last one
        dt_str = "".join([c for c in dt_str if c.isnumeric()]) #grabs numeric values for date info
        out_fname = dir_splt + '/nc/' + dt_str[:4] + '/' + dt_str[:8] + '_SUPERsnow_depth_3m.nc'
        print('out_fname', out_fname)

        # CALL FUNCTION
        tif_to_nc(f, out_fname, shp=shp)
