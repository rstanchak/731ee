#include <stdio.h>
#include <cv.h>
#include <highgui.h>

#define MAX_FEATURES 2048 

int main(int argc, char ** argv){
	IplImage * prev_frame=NULL, *prev_frame3;
	IplImage * frame, *frame3;
	CvMat * tmp1, *tmp2, *pyr1, *pyr2, *tmp3;
	CvMat * curr_status = cvCreateMat(1, MAX_FEATURES, CV_8U);
	CvMat *prev_status = cvCreateMat(1, MAX_FEATURES, CV_8U);
	CvPoint2D32f prev_features[MAX_FEATURES];
	CvPoint2D32f curr_features[MAX_FEATURES];
	int count;
	float track_error[MAX_FEATURES];
	char status[MAX_FEATURES];
	double quality_level=.01;
	CvSize win_size=cvSize(7,7);
	CvSize zero_zone=cvSize(-1,-1);
	CvTermCriteria term_crit = cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 1000, 0.001);
	int level = 5;
	int min_distance=1;
	int flags = 0;
	int nx,ny;
	
	cvNamedWindow("current", 0);
	cvNamedWindow("previous", 0);


	// initialize status to all valid
	cvSet( prev_status, cvScalarAll(255) );

	for( int i=1; i<argc; ++i ){
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
					prev_features[count++] = cvPoint2D32f( (i+1)*frame->width/(nx+2), (j+1)*frame->height/(ny+2) );
			   }
			}	   
		}
		else{
			//cvGoodFeaturesToTrack( prev_frame, tmp1, tmp2, prev_features, &count,
			//		quality_level, min_distance );

			//assert(count>0);
			//printf("found %d features\n", count);
			//cvFindCornerSubPix( prev_frame, prev_features, count, win_size, zero_zone, 
			//		term_crit );
			cvCalcOpticalFlowPyrLK( prev_frame, frame, pyr1, pyr2, 
					prev_features, curr_features, count, win_size, level,
					(char *) curr_status->data.ptr, track_error, term_crit, flags );

			cvAnd( curr_status, prev_status, curr_status );

			for(int j=0; j<count; j++){
				if(curr_status->data.ptr[j]){
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
			cvCopy(curr_status, prev_status);
			cvReleaseImage( &prev_frame );
			cvReleaseImage( &prev_frame3 );
		}
		prev_frame = frame;
		prev_frame3 = frame3;
	
	}
}
