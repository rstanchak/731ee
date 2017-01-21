function getIntersectionData(filenames)
oldFig=figure(1);
currentFig=figure(2);
nextFig=figure(3);
y=.33;
set(oldFig, 'Units','normalized','Position', [ 0, y, .33, y], 'toolbar','none');
set(currentFig, 'Units','normalized','Position', [ .33, y, .33, y], 'toolbar','none');
set(nextFig, 'Units','normalized','Position', [ .66, y, .33, y], 'toolbar','none');
figure(nextFig);
clf
for filenameIx = 0:length(filenames)
    ix = 1;
    moreCarsToClick = 1;
    timesThroughImage = 0;
		set(oldFig, 'Units','normalized','Position', [ 0, y, .33, y], 'toolbar','none');
		set(currentFig, 'Units','normalized','Position', [ .33, y, .33, y], 'toolbar','none');
		set(nextFig, 'Units','normalized','Position', [ .66, y, .33, y], 'toolbar','none');
    	figure(nextFig);
    	clf
    	if (filenameIx <= length(filenames))
    	    a=imread(filenames{filenameIx+1});
    	    image(a);
    	    set(text(5,10,filenames{filenameIx+1}), 'Color', 'red');
    	    if filenameIx == 0
    	        [oldFig,currentFig,nextFig]=deal(currentFig,nextFig,oldFig)
    	        continue
    	    end
    	end
    	figure(currentFig);
    	caption = text(0, -10, '');

	% does txt file exist already?
    	[p,n,e,v]=fileparts(filenames{filenameIx+1});
		dataFilename = [n '.txt'];
		fid = fopen(dataFilename, 'r');
		if(fid>0)
			ok=1;
			while(ok)
				[pts,ok1] = fscanf(fid, '%f', 2);
				[desc,ok2] = fscanf(fid, '%s', 4);
				if(ok1==2 & ok2==4)
					positions(:,ix)=pts;
					fromArray(ix)=desc(1);
					toArray(ix)=desc(2);
					colorArray(ix)=desc(3);
					typeArray(ix)=desc(4);
					ix=ix+1;
					timesThroughImage=timesThroughImage+1;
					labelCap(timesThroughImage)=text(pts(1),pts(2),desc);
					set(labelCap(timesThroughImage),'Color','green');
				else
					ok=0;
				end
			end
			disp(sprintf('read %d points from %s', ix-1, dataFilename))
			fclose(fid);

			% uncomment this to edit old txt file
			moreCarsToClick=0;
		end

    while (moreCarsToClick)
        set(currentFig, 'WindowStyle', 'modal');
        set(caption, 'String', 'Click current car, N for next image, R replicates last frame, X removes last car');
        [xInput, yInput, button] = ginput(1);
        if not(button==1)
            switch button
				case{'R','r'}
					positions=old_positions;
					fromArray=old_fromArray;
					toArray=old_toArray;
					colorArray=old_colorArray;
					typeArray=old_typeArray;
					ix=size(positions,2)+1;
					timesThroughImage=ix-1;
					for i=1:timesThroughImage
						labelCap(i)=text(positions(1,i),positions(2,i), ...
							[fromArray(i), toArray(i), colorArray(i), typeArray(i)]);
						set(labelCap(i),'Color','green');
					end

                case {'N', 'n'}
                    moreCarsToClick = 0;
                case {'X', 'x'}
                    disp('deleting last car');
                    if timesThroughImage > 0
                        set(labelCap(timesThroughImage), 'String', '');
                        timesThroughImage = timesThroughImage - 1;
                        ix=ix-1;
                    else
                        disp('no more cars to delete');
                    end
            end
        else %mouse button press
            mousePress = [xInput, yInput];
            timesThroughImage = timesThroughImage + 1;
            if mousePress(1) > 0 & mousePress(2) > 0
                positions(:,ix) = mousePress(:);
                fromDir = 'X';
                while not(ismember(fromDir, 'NSEW'))
                    set(caption, 'String', 'From ([N]orth [S]outh [E]ast [W]est)?')
                    pause(0.01);
                    set(currentFig, 'CurrentCharacter', 'X');
                    waitfor(currentFig, 'CurrentCharacter');
                    fromDir = upper(get(currentFig, 'CurrentCharacter'));
                end
                fromArray(ix) = fromDir;
                toDir = 'X';
                while not(ismember(toDir, 'NSEW'))
                    set(caption, 'String', 'To ([N]orth [S]outh [E]ast [W]est)?');
                    pause(0.01);
                    set(currentFig, 'CurrentCharacter', 'X');
                    waitfor(currentFig, 'CurrentCharacter');
                    toDir = upper(get(currentFig, 'CurrentCharacter'));
                end
                toArray(ix) = toDir;
                color = 'X';
                while not(ismember(color, 'DMLWRYBGO'))
                    set(caption, 'String', 'Color ([D]ark [M]edium [L]ight [W]hite [R]ed [Y]ellow [B]lue [G]reen [O]range)?');
                    pause(0.01);
                    set(currentFig, 'CurrentCharacter', 'X');
                    waitfor(currentFig, 'CurrentCharacter');
                    color = upper(get(currentFig, 'CurrentCharacter'));
                end
                colorArray(ix) = color;
                type = 'X';
                while not(ismember(type, 'CBTPVMSY'))
                    set(caption, 'String', 'Type ([C]ar [B]us [T]ruck [P]ickup [V]an [M]inivan [S]uv motorc[Y]cle)?');
                    pause(0.01);
                    set(currentFig, 'CurrentCharacter', 'X');
                    waitfor(currentFig, 'CurrentCharacter');
                    type = upper(get(currentFig, 'CurrentCharacter'));
                end
                typeArray(ix) = type;
                set(currentFig, 'WindowStyle', 'normal');
                ix = ix + 1;
                labelCap(timesThroughImage)=text(mousePress(1),mousePress(2),[fromDir toDir color type]);
                set(labelCap(timesThroughImage),'Color','green');
            end
        end
    end
    numClicks = ix-1;

    [p,n,e,v]=fileparts(filenames{filenameIx+1});
    dataFilename = [n '.txt'];
    fid = fopen(dataFilename, 'w');
    if (numClicks > 0)
        for ix=1:numClicks
            fprintf(fid, '%d %d %s %s %s %s\n', positions(1,ix), positions(2,ix), ...
                fromArray(ix), toArray(ix), colorArray(ix), typeArray(ix));
        end
    end
    fclose(fid);

	%save old
	old_positions=[];
	old_fromArray=[];
	old_toArray=[];
	old_colorArray=[];
	old_typeArray=[];
	if(numClicks>0)
		old_positions=positions(:, 1:numClicks);
		old_fromArray=fromArray(1:numClicks);
		old_toArray=toArray(1:numClicks);
		old_colorArray=colorArray(1:numClicks);
		old_typeArray=typeArray(1:numClicks);
	end
    clear positions fromArray toArray colorArray typeArray
    [oldFig,currentFig,nextFig]=deal(currentFig,nextFig,oldFig);
end
