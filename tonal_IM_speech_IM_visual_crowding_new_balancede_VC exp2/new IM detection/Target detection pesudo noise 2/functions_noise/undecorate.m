function undecorate(fig)
% Remove figure title bar and borders
	warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
	if ispc
		undecorate_mex(int32(fig.JavaFrame.fHG2Client.getWindow.getHWnd));
        % undecorate_mex(int32(fig.fHG2Client.getWindow.getHWnd));
    else
		warning('Undecorate: Implemented only for Windows');
	end
end