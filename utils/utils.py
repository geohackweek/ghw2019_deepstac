def GetExtent(gt,cols,rows):
    ''' Return list of corner coordinates from a geotransform

        @type gt:   C{tuple/list}
        @param gt: geotransform
        @type cols:   C{int}
        @param cols: number of columns in the dataset
        @type rows:   C{int}
        @param rows: number of rows in the dataset
        @rtype:    C{[float,...,float]}
        @return:   coordinates of each corner

    this was taken from: https://gis.stackexchange.com/questions/57834/how-to-get-raster-corner-coordinates-using-python-gdal-bindings

    '''
    ext=[]
    xarr=[0,cols]
    yarr=[0,rows]

    for px in xarr:
        for py in yarr:
            x=gt[0]+(px*gt[1])+(py*gt[2])
            y=gt[3]+(px*gt[4])+(py*gt[5])
            ext.append([x,y])
            print(x,y)
        yarr.reverse()
    return ext   

def ventana(signal=None, kernel_size=(100, 100), stride=(20, 20), **kwargs):
    '''Description: This function will window a 3D array along axis = [0, 1]
    --------
    Inputs:
        signal - (np.array)
        kernel_size - (tuple)
        stride - (tuple)

        [optional]
        function_name - (function)
    --------
    Outputs:
        sample - (list of windows) 

    Note: the list is row oriented

    '''

    if 'function' in kwargs.keys():
        function = kwargs['function']
    else:
        def function(x): return x

    sample = []

    start_y = 0
    end_y = kernel_size[0]
    start_x = 0
    end_x = kernel_size[1]
    # First move through the y-axis ------------------

    while (end_y <= signal.shape[0]):

        while end_x <= signal.shape[1]:
            sample.append(
                function(
                    signal[start_y:end_y, start_x:end_x, :]
                )
            )

            # Increment X direction by stride -------------

            start_x = start_x + stride[1]
            end_x = end_x + stride[1]
#             print('start_x: {0} \n end_x: {1} \n start_y: {2} \n end_y:{3} \n\n'.format(
#                   start_x, end_x, start_y, end_y
#             ))
        # Increment Y direction by stride --------------

        start_y = start_y + stride[0]
        end_y = end_y + stride[0]

        # Restart the X Location and Stride ------------------

        start_x = 0
        end_x = kernel_size[1]

    return sample

