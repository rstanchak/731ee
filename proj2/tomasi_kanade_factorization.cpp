#include <stdio.h>
#include <cv.h>
#include <highgui.h>

#define MAX_FEATURES 2048 



int main(int argc, char ** argv){
	IplImage * prev_frame=NULL, *prev_frame3;
	IplImage * frame, *frame3;
	CvMat * tmp1, *tmp2, *pyr1, *pyr2, *tmp3;
	int count=0;
	float track_error[MAX_FEATURES];
	double quality_level=.01;
	CvSize win_size=cvSize(7,7);
	CvSize zero_zone=cvSize(-1,-1);
	CvTermCriteria term_crit = cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 1000, 0.001);
	int level = 5;
	int min_distance=1;
	int flags = 0;
	int nx,ny;

	CvMat * measurements = cvCreateMat( argc-1, MAX_FEATURES, CV_32FC2 );	
	CvMat * status = cvCreateMat( argc-1, MAX_FEATURES, CV_8U );	
	cvNamedWindow("current", 0);
	cvNamedWindow("previous", 0);


	for( int i=1; i<argc; ++i ){
		CvPoint2D32f * curr_features = (CvPoint2D32f *) CV_MAT_ELEM_PTR_FAST(*measurements, i-1, 0, sizeof(CvPoint2D32f) );
		frame3 = cvLoadImage( argv[i], 1);
		frame = cvCreateImage( cvGetSize(frame3), 8, 1 );
		cvCvtColor(frame3, frame, CV_BGR2GRAY);
		if(!prev_frame){
			tmp1 = cvCreateMat( frame->height, frame->width, CV_32F );
			tmp2 = cvCreateMat( frame->height, frame->width, CV_32F );
			pyr1 = cvCreateMat( frame->height, frame->width, CV_32F );
			pyr2 = cvCreateMat( frame->height, frame->width, CV_32F );
			nx = cvFloor(sqrt( frame->width*MAX_FEATURES/(double)frame->height ));
			ny = MAX_FEATURES/nx;

			for(int i=0; i<nx; i++){
			   for(int j=0; j<ny; j++){
					curr_features[count++] = cvPoint2D32f( (i+1)*frame->width/(nx+2), (j+1)*frame->height/(ny+2) );
			   }
			}	   
		}
		else{
			CvPoint2D32f * prev_features = (CvPoint2D32f *) CV_MAT_ELEM_PTR_FAST(*measurements, i-2, 0, sizeof(CvPoint2D32f) );
			//cvGoodFeaturesToTrack( prev_frame, tmp1, tmp2, prev_features, &count,
			//		quality_level, min_distance );

			//assert(count>0);
			//printf("found %d features\n", count);
			//cvFindCornerSubPix( prev_frame, prev_features, count, win_size, zero_zone, 
			//		term_crit );
			char * curr_status = (char *) CV_MAT_ELEM_PTR_FAST(*status, i-1, 0, sizeof(uchar));

			cvCalcOpticalFlowPyrLK( prev_frame, frame, pyr1, pyr2, prev_features, curr_features,
				count, win_size, level,	
				curr_status, track_error, term_crit, flags );

			for(int j=0; j<count; j++){
				if(curr_status[j]){
					cvCircle( prev_frame3, cvPointFrom32f( prev_features[j] ), 2, CV_RGB(0,255,0), 1, CV_AA);
					cvCircle( frame3, cvPointFrom32f( curr_features[j] ), 2, CV_RGB(0,255,0), 1, CV_AA);		
				}
				else{
					cvCircle( prev_frame3, cvPointFrom32f( prev_features[j] ), 2, CV_RGB(255,0,0), 1, CV_AA);
				}
			}
			cvShowImage("current", frame3);
			cvShowImage("previous", prev_frame3);
			if((char)cvWaitKey()=='q') break;

			flags = CV_LKFLOW_PYR_A_READY;
			CV_SWAP( pyr1, pyr2, tmp3 );
			memcpy(prev_features, curr_features, count*sizeof(CvPoint2D32f));
			//cvCopy(curr_status, prev_status);
			cvReleaseImage( &prev_frame );
			cvReleaseImage( &prev_frame3 );
		}
		prev_frame = frame;
		prev_frame3 = frame3;
	
	}
	CvMat last_status; cvGetRow(status, &last_status, status->rows-1);
	int nonzero = cvCountNonZero( &last_status );
	
	CvMat * vmeasurements = cvCreateMat( measurements->rows*2, nonzero, CV_32F );

	// extract valid measurements
	for(int i=0; i<vmeasurement->cols; i++){
		CvMat col;
		CvMat col2;
		CvMat vcol;
		
		// find next non-zero
		while(last_status.data.ptr[idx]==0) idx++;

		cvGetCol(vmeasurement, &vcol, i);
		cvGetCols(measurement, &col2, 2*idx, 2*idx+2);
		cvReshape(&col2, &col, 1, col2.rows*2);
			
		cvCopy(&col, &vcol);
	}



}
