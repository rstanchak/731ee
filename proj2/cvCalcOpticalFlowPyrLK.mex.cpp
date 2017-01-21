#include <stdio.h>
#include <mex.h>
#include <cv.h>
#include <highgui.h>



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
	CvMat img1, img2, pts1, pts2;
   	CvMat status, track_error_stub;
	CvMat *track_error=NULL;
	int count;
	int m,n;

	CvSize win_size=cvSize(10,10);
	CvTermCriteria term_crit = cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 1000, 0.001);
	int level = 3;
	int flags = 0;

	if(nlhs != 2 && nlhs != 3 && nrhs != 3){
		mexWarnMsgTxt("Expected 3 input arguments and 2 or 3 outputs\n");
		return;
	}
		
	// matlab stores arrays col-major, opencv is row-major, so array is transposed
	cvInitMatHeader( &img1, mxGetN( prhs[0] ), mxGetM( prhs[0] ), 
			mxToCvType( prhs[0] ), mxGetPr( prhs[0] ));
	cvInitMatHeader( &img2, mxGetN( prhs[1] ), mxGetM( prhs[1] ), 
			mxToCvType( prhs[1] ), mxGetPr( prhs[1] ));
	cvInitMatHeader( &pts1, mxGetN( prhs[2] ), mxGetM( prhs[2] ), 
			mxToCvType( prhs[2] ), mxGetPr( prhs[2] ));
	
	assert(CV_MAT_DEPTH(img1.type)==CV_8U);
	assert(CV_MAT_DEPTH(img2.type)==CV_8U);

	if(CV_MAT_DEPTH(pts1.type)!=CV_32F){
		mexWarnMsgTxt("points must be single precision");
		return;
	}
	if(pts1.cols!=2){
		mexWarnMsgTxt("points must be a 2xN single precision matrix");
		return;
	}

	count = pts1.rows;

	// output arguments
	plhs[0] = mxCreateNumericMatrix( 2, count, mxSINGLE_CLASS, mxREAL );
	cvInitMatHeader(&pts2, count, 2, CV_32F, mxGetPr( plhs[0] ));
	plhs[1] = mxCreateNumericMatrix( 1, count, mxUINT8_CLASS, mxREAL );
	cvInitMatHeader(&status, count, 1, CV_8U, mxGetPr( plhs[1] ));

	if(nlhs==3){
		plhs[2] = mxCreateNumericMatrix( 1, count, mxSINGLE_CLASS, mxREAL );
		track_error = cvInitMatHeader(&track_error_stub, count, 1, CV_32F, mxGetPr( plhs[2] ));
	}

	cvCalcOpticalFlowPyrLK( &img1, &img2, NULL, NULL, 
			(CvPoint2D32f *)pts1.data.fl, (CvPoint2D32f *)pts2.data.fl, 
			count, win_size, level, (char *) status.data.ptr, 
			track_error ? track_error->data.fl : NULL, term_crit, flags );	

}
