#include <stdio.h>
#include <mex.h>
#include <cv.h>
#include <highgui.h>

extern "C" {

int cvMexErrReport( int status, const char* func_name,
                    const char* err_msg, const char* file_name, int line, void * ){
	const char * errstr = cvErrorStr( status );
	mexPrintf("Internal OpenCV error in function '%s' in %s:%d\n%s\n", func_name, file_name, line, err_msg);
	mexWarnMsgTxt("OpenCV error");
}

int mxToCvType( const mxArray * array_ptr ){
	mxClassID category = mxGetClassID(array_ptr);
	switch (category)  {
		case mxINT8_CLASS:   return CV_8S;
		case mxUINT8_CLASS:  return CV_8U;
		case mxINT16_CLASS:  return CV_16S;
		case mxUINT16_CLASS: return CV_16U;
		case mxINT32_CLASS:  return CV_32S;
		case mxUINT32_CLASS: return CV_32S;
		case mxSINGLE_CLASS: return CV_32F;
		case mxDOUBLE_CLASS: return CV_64F; 
	} 
	return -1;
}

void mexFunction( int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	CvMat pts1, pts2;
   	CvMat status_stub;
	CvMat fundamental_matrix;
	int m,n;
	int ret;
	CvMat image;
  	CvMat * eig_image;
	CvMat * temp_image;
                            
	CvPoint2D32f* corners;
   	int corner_count;
	int corners_found;
	double quality_level=0.01;
   	double min_distance=10;
   	const CvArr* mask=NULL;
   	int block_size=3;
   	int use_harris=0;
   	double k=0.04;

	cvRedirectError( (CvErrorCallback) cvMexErrReport );

	if(nlhs != 1 && nlhs != 2 && nrhs < 2){
		mexWarnMsgTxt("points = cvGoodFeaturesToTrack( image, num_corners )\n");
		return;
	}
		
	// matlab stores arrays col-major, opencv is row-major, so array is transposed
	
	// input arguments
	cvInitMatHeader( &image, mxGetN( prhs[0] ), mxGetM( prhs[0] ), 
			mxToCvType( prhs[0] ), mxGetPr( prhs[0] ));
	corner_count = corners_found = (int) *(mxGetPr(prhs[1]));
		
	if(CV_MAT_DEPTH(image.type)!=CV_8U){
		mexWarnMsgTxt("image must be uint8 or single precision\n");
		return;
	}

	//mexPrintf("%d %d %d %d\n", pts1.rows,pts1.cols, pts2.rows, pts2.cols);
	// output arguments
	plhs[0] = mxCreateNumericMatrix( 2, corner_count, mxSINGLE_CLASS, mxREAL );

	corners = (CvPoint2D32f*) mxGetPr(plhs[0]);


	eig_image = cvCreateMat( image.rows, image.cols, CV_32F );
	temp_image = cvCreateMat( image.rows, image.cols, CV_32F );

	cvGoodFeaturesToTrack( &image, eig_image, temp_image, corners, &corners_found,
			quality_level, min_distance, mask, block_size, use_harris, k );

	cvFindCornerSubPix( &image, corners, corners_found, cvSize(10,10), cvSize(-1,-1), 	
			            cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, 0.03) );

	cvReleaseMat( &eig_image );
	cvReleaseMat( &temp_image );

	if( corners_found < corner_count ){
		mxArray * tmp_array = mxCreateNumericMatrix( 2, corners_found, mxSINGLE_CLASS, mxREAL );
		memcpy( mxGetPr(tmp_array), corners, sizeof(CvPoint2D32f)*corners_found );
		mxDestroyArray( plhs[0] );
		plhs[0] = tmp_array;
	}

}

} // extern "C"
