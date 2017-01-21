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

struct CvFmMethod {
	const char * desc;
    int method;
} FM_METHODS[] = {
	{"7point", CV_FM_7POINT},
	{"8point", CV_FM_8POINT},
	{"ransac", CV_FM_RANSAC},
	{"lmeds", CV_FM_LMEDS},
	{NULL, -1}
};

void mexFunction( int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	CvMat pts1, pts2;
   	CvMat status_stub;
	CvMat fundamental_matrix;
	int m,n;
	int ret;

	int method=CV_FM_LMEDS;
	double param1=1.0;
	double param2=0.99;
	CvMat* status=NULL;

	
	cvRedirectError( (CvErrorCallback) cvMexErrReport );

	if(nlhs != 1 && nlhs != 2 && nrhs < 2){
		mexWarnMsgTxt("fundamental_mat = cvFindFundamentalMat( pts1, pts2, method, param1, param2 )\n");
		return;
	}
		
	// matlab stores arrays col-major, opencv is row-major, so array is transposed

	// input arguments
	cvInitMatHeader( &pts1, mxGetN( prhs[0] ), mxGetM( prhs[0] ), 
			mxToCvType( prhs[1] ), mxGetPr( prhs[0] ));
	cvInitMatHeader( &pts2, mxGetN( prhs[1] ), mxGetM( prhs[1] ), 
			mxToCvType( prhs[1] ), mxGetPr( prhs[1] ));
	
	//mexPrintf("%d %d %d %d\n", pts1.rows,pts1.cols, pts2.rows, pts2.cols);
	// output arguments
	plhs[0] = mxCreateNumericMatrix( 3, 3, mxGetClassID(prhs[1]), mxREAL );
	cvInitMatHeader(&fundamental_matrix, 3, 3, pts1.type, mxGetPr( plhs[0] ));
	if(nrhs>=3 ){
		char input_buf[64];
		struct CvFmMethod * fm_method = FM_METHODS;
		mxGetString(prhs[2], input_buf, 64);
		while(fm_method->desc){
			if(strcmp(fm_method->desc, input_buf)==0){
				method = fm_method->method;
				break;
			}
			fm_method++;
		}

		if(fm_method->desc==NULL){
			mexPrintf("Warning: method '%s' not recognized, using 'lmeds' instead\n");
		}
	}
	/*printf("pts1=[");
	for(int i=0; i<pts1.rows; i++){
		for(int j=0; j<pts1.cols; j++){
			printf("%f ", cvGetReal2D(&pts1, i, j));
		}
		printf(";\n");
	}
	printf("]\n");
*/
	ret = cvFindFundamentalMat( &pts1, &pts2, &fundamental_matrix, method, param1, param2, status );
/*	for(int i=0; i<3; i++){
		for(int j=0; j<3; j++){
			printf("%f ", cvGetReal2D(&fundamental_matrix, i, j));
		}
		printf("\n");
	}
*/
	if(ret==0){
		mexWarnMsgTxt("No fundamental matrix found\n");
		return;
	}
}

} // extern "C"
