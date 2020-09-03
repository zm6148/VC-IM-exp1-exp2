// See in the FEX:
// ShowWindow, Matthew Simoneau:
//   http://www.mathworks.com/matlabcentral/fileexchange/3407
// Window Manipulation, Phil Goddard:
//   http://www.mathworks.com/matlabcentral/fileexchange/3434
// api_showwindow, Mihai Moldovan:
//   http://www.mathworks.com/matlabcentral/fileexchange/2041
// maxfig, Mihai Moldovan:
//   http://www.mathworks.com/matlabcentral/fileexchange/6913
// setFigTransparency, Yair Altman:
//   http://www.mathworks.com/matlabcentral/fileexchange/30583
// FigureManagement (multi-monitor setup), Mirko Hrovat:
//   http://www.mathworks.com/matlabcentral/fileexchange/12607


#if !defined(__WINDOWS__) && !defined(_WIN32) && !defined(_WIN64)
#error Implemented for Windows only!
#endif

#include <windows.h>
#include "WinUser.h"
#include <string.h>
#include <shellapi.h>
#include <math.h>
#include "mex.h"

// Multi-monitor management: ---------------------------------------------------
typedef struct tagGETMONITOR {
   HMONITOR target;
   int      index;
   BOOL     found;
} GETMONITOR, *LPGETMONITOR;

int  myGetIndexFromMonitor(HMONITOR hMonitor);
BOOL CALLBACK myMonitorMatchProc(HMONITOR hMonitor, HDC hdc,
                                LPRECT lprc, LPARAM dwData);

HMONITOR myGetMonitorFromIndex(HWND hWnd, int MonitorIndex);
BOOL CALLBACK myIndexMatchProc(HMONITOR hMonitor, HDC hdcMonitor,
                               LPRECT lprcMonitor, LPARAM dwData);
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs == 1)
	{
		long value = GetWindowLong(*(HWND*)mxGetData(prhs[0]), GWL_STYLE);
		plhs[0] =  mxCreateLogicalScalar(SetWindowLong(*(HWND*)mxGetData(prhs[0]),GWL_STYLE,(int)(value & ~WS_CAPTION)) > 0);
	}
}
