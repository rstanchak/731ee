#include <stdio.h>
#include <mex.h>
#include <cv.h>
#include <highgui.h>

int mxToCvType( const mxArray * arr ){
	return CV_64F;
}

void icvReverseConvert( CvMat * src, CvMat * dst ){
    if(src->cols==dst->cols){
		for(int i=0; i<
        CvMat col64, row32;
        // need to swap indices b/c of transposition
        cvGetCol(&pts1_64, &col64, 0);
        cvGetRow(pts1_32, &row32, 1);
        cvReshape(&row32, &row32, 1, row32.cols);
        printf("Nx2 %d %d %d %d\n", col64.rows, col64.cols, row32.rows, row32.cols);
        cvConvert( &col64, &row32 );

        cvGetCol(&pts1_64, &col64, 1);
        cvGetRow(pts1_32, &row32, 0);
        cvReshape(&row32, &row32, 1, row32.cols);
        cvConvert( &col64, &row32 );
    }
    // pts is 2xN
    else{
        CvMat row64, row32;
        // need to swap indices b/c of transposition
        cvGetRow(&pts1_64, &row64, 0);
        cvGetRow(pts1_32, &row32, 1);
        printf("2xN %d %d %d %d\n", row64.rows, row64.cols, row32.rows, row32.cols);
        cvConvert( &row64, &row32 );

        cvGetRow(&pts1_64, &row64, 1);
        cvGetRow(pts1_32, &row32, 0);
        cvConvert( &row64, &row32 );
    }
}

void mexFunction( int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	CvMat img1_64, img2_64, pts1_64, pts2_64;
	CvMat * img1_8u, *img2_8u, *pts1_32;
   	CvMat pts2_32, status, track_error_stub;
	CvMat *track_error=NULL;
	int count;
	int m,n;

	CvSize win_size=cvSize(7,7);
	CvTermCriteria term_crit = cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 1000, 0.001);
	int level = 5;
	int flags = 0;

	if(nlhs != 2 && nlhs != 3 && nrhs != 3){
		mexErrMsgTxt("Expected 3 input arguments and 2 or 3 outputs\n");
		return;
	}
		
	// matlab stores arrays col-major, opencv is row-major, so array is transposed
	cvInitMatHeader( &img1_64, mxGetN( prhs[0] ), mxGetM( prhs[0] ), mxToCvType( prhs[0] ), 
			mxGetPr( prhs[0] ));
	cvInitMatHeader( &img2_64, mxGetN( prhs[1] ), mxGetM( prhs[1] ), mxToCvType( prhs[1] ), 
			mxGetPr( prhs[1] ));
	cvInitMatHeader( &pts1_64, mxGetN( prhs[2] ), mxGetM( prhs[2] ), mxToCvType( prhs[2] ), 
			mxGetPr( prhs[2] ));
	
	if(pts1_64.cols!=2 && pts1_64.rows!=2){
		mexErrMsgTxt("points must be a 2xN or Nx2 matrix");
		return;
	}

	count = pts1_64.cols==2 ? pts1_64.rows : pts1_64.cols;

	// convert to 32F format
	img1_8u = cvCreateMat( img1_64.rows, img1_64.cols, CV_8U );
	img2_8u = cvCreateMat( img2_64.rows, img2_64.cols, CV_8U );
	pts1_32 = cvCreateMat( 2, count, CV_32F );
	pts2_32 = cvCreateMat( 2, count, CV_32F );

	cvConvert( &img1_64, img1_8u );
	cvConvert( &img2_64, img2_8u );

	// pts is Nx2
	if(pts1_64.cols==2){
		CvMat col64, row32;
		// need to swap indices b/c of transposition
		cvGetCol(&pts1_64, &col64, 0); 
		cvGetRow(pts1_32, &row32, 1);
		cvReshape(&row32, &row32, 1, row32.cols);
		printf("Nx2 %d %d %d %d\n", col64.rows, col64.cols, row32.rows, row32.cols);
		cvConvert( &col64, &row32 );

		cvGetCol(&pts1_64, &col64, 1); 
		cvGetRow(pts1_32, &row32, 0);
		cvReshape(&row32, &row32, 1, row32.cols);
		cvConvert( &col64, &row32 );
	}
	// pts is 2xN
	else{
		CvMat row64, row32;
        // need to swap indices b/c of transposition
        cvGetRow(&pts1_64, &row64, 0);
        cvGetRow(pts1_32, &row32, 1);
		printf("2xN %d %d %d %d\n", row64.rows, row64.cols, row32.rows, row32.cols);
        cvConvert( &row64, &row32 );

        cvGetRow(&pts1_64, &row64, 1);
        cvGetRow(pts1_32, &row32, 0);
        cvConvert( &row64, &row32 );
	}

	// convert to C indices
	cvSubS(pts1_32, cvScalar(-1), pts1_32);


	// output arguments
	plhs[0] = mxCreateDoubleMatrix( 2, count, mxREAL );

	plhs[1] = mxCreateNumericMatrix( 1, count, mxUINT8_CLASS, mxREAL );
	cvInitMatHeader(&status, count, 1, CV_8U, mxGetPr( plhs[1] ));

	if(nlhs==3){
		plhs[2] = mxCreateNumericMatrix( 1, count, mxSINGLE_CLASS, mxREAL );
		track_error = cvInitMatHeader(&track_error_stub, count, 1, CV_32F, mxGetPr( plhs[2] ));
	}

	cvCalcOpticalFlowPyrLK( img1_8u, img2_8u, NULL, NULL, (CvPoint2D32f *)pts1_32->data.fl,
		   	(CvPoint2D32f *)pts2_32.data.fl, 
			count, win_size, level,
			(char *) status.data.ptr, track_error ? track_error->data.fl : NULL, term_crit, flags );	

	// convert back to matlab indices
	cvAddS(pts2_32, cvScalar(-1), pts2_32);

	// transpose and convert points
	cvInitMatHeader(&pts2_32, 2, count, CV_32F, mxGetPr( plhs[0] ));


	cvReleaseMat( &img1_8u );
	cvReleaseMat( &img2_8u );
	cvReleaseMat( &pts1_32 );
}
