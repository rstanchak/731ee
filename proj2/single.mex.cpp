#include <mex.h>

extern "C" { 
	
void mexFunction( int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
	double * indata;
	float * outdata;
	int m,n,len;

	if(nlhs != 1 && nrhs != 1){
		mexErrMsgTxt("Expected one input and one output argument\n");
		return;
	}
	
	m = mxGetM( prhs[0] );
	n = mxGetN( prhs[0] );
	len = m*n;

	// output arguments
	plhs[0] = mxCreateNumericMatrix( m, n, mxSINGLE_CLASS, mxREAL );

	indata = (double *) mxGetPr( prhs[0] );
	outdata = (float *) mxGetPr( plhs[0] );

	for(int i=0; i<len; i++){
		indata[i] = (float) outdata[i];
	}
}

} // extern "C"
