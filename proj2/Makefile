PKG_CONFIG_PATH=/usr/local/opencv/lib/pkgconfig
CXXFLAGS=`pkg-config opencv --cflags` -ggdb
LDFLAGS=`pkg-config opencv --libs`
MEX=/usr/local/matlab-7/bin/mex

%.mexglx:%.mex.cpp
	$(MEX) $(CXXFLAGS) $(LDFLAGS) $< -o $@

cvCalcOpticalFlowPyrLK: cvCalcOpticalFlowPyrLK.mexglx
cvFindFundamentalMat: cvFindFundamentalMat.mexglx
cvGoodFeaturesToTrack: cvGoodFeaturesToTrack.mexglx

do-lowimages: fullimages/*
	for f in $^; do make lowimages/`basename $$f`; done

lowimages/%:fullimages/%
	convert $< -resize 100 $@
