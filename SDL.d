/*
MIT License
Copyright (c) 2019 Seth Ballantyne
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

 _   _   ___  _____  _   __  _____ _   _  _____  
| | | | / _ \/  __ \| | / / |_   _| | | ||  ___| 
| |_| |/ /_\ \ /  \/| |/ /    | | | |_| || |__   
|  _  ||  _  | |    |    \    | | |  _  ||  __|  
| | | || | | | \__/\| |\  \   | | | | | || |___  
\_| |_/\_| |_/\____/\_| \_/   \_/ \_| |_/\____/  
                                                 
                                                 
______ _       ___   _   _  _____ _____          
| ___ \ |     / _ \ | \ | ||  ___|_   _|         
| |_/ / |    / /_\ \|  \| || |__   | |           
|  __/| |    |  _  || . ` ||  __|  | |           
| |   | |____| | | || |\  || |___  | |           
\_|   \_____/\_| |_/\_| \_/\____/  \_/          
*/
module SDL;
import std;

enum SDL_LIL_ENDIAN = 1234;
enum SDL_BIG_ENDIAN = 4321;
// x86* is assumed, because that's what I'm using. :P
enum SDL_BYTEORDER = SDL_LIL_ENDIAN;
//---------------------------------------------------------------------
// SDL-flavoured basic data types from SDL_stdinc.h
//---------------------------------------------------------------------
// don't really need SDL_bool but it's here for completeness
enum SDL_bool { SDL_FALSE = 0, SDL_TRUE = 1 }

alias byte      Sint8;
alias ubyte	    Uint8;
alias short     Sint16;
alias ushort    Uint16;
alias int       Sint32;
alias uint	    Uint32;
alias long      Sint64;
alias ulong     Uint64;

// Everything below this line is found within the SDL docs. If it's 
// not in the docs, it's not here and you'll have to port it yourself.
// missing: SDL_envvars. I don't need it. 
//---------------------------------------------------------------------
// Chap 5. GENERAL
//---------------------------------------------------------------------

// I could have done it the enum FLAGS {...} way, but I want it
// to resemble the C version of SDL as close as possible for when people 
// are porting C code to D; also handy if someone is using old 
//tutorials/books and wants to use D instead of C (like me from time to time).
enum Uint32 SDL_INIT_TIMER = 0x00000001;
enum Uint32 SDL_INIT_AUDIO = 0x00000010;
enum Uint32 SDL_INIT_VIDEO = 0x00000020;
enum Uint32 SDL_INIT_CDROM = 0x00000100;
enum Uint32 SDL_INIT_JOYSTICK	= 0x00000200;
enum Uint32 SDL_INIT_NOPARACHUTE = 0x00100000;	
enum Uint32 SDL_INIT_EVENTTHREAD = 0x01000000;	
enum Uint32 SDL_INIT_EVERYTHING = 0x0000FFFF; 

extern(C) int SDL_Init(Uint32 flags);
extern(C) int SDL_InitSubSystem(Uint32 flags);
extern(C) void SDL_QuitSubSystem(Uint32 flags);
extern(C) void SDL_Quit();
extern(C) Uint32 SDL_WasInit(Uint32 flags);
extern(C) char *SDL_GetError();

//---------------------------------------------------------------------
// Chap 6. VIDEO
//--------------------------------------------------------------------
extern (C) struct SDL_Color
{
	Uint8 r;
	Uint8 g;
	Uint8 b;
	Uint8 unused;
}

extern (C) struct SDL_Palette
{
	int       ncolors;
	SDL_Color *colors;
}

extern (C) struct SDL_PixelFormat
{
	SDL_Palette *palette;
	Uint8  BitsPerPixel;
	Uint8  BytesPerPixel;
	Uint8  Rloss;
	Uint8  Gloss;
	Uint8  Bloss;
	Uint8  Aloss;
	Uint8  Rshift;
	Uint8  Gshift;
	Uint8  Bshift;
	Uint8  Ashift;
	Uint32 Rmask;
	Uint32 Gmask;
	Uint32 Bmask;
	Uint32 Amask;
	Uint32 colorkey;
	Uint8  alpha;
}

extern (C) struct SDL_Rect 
{
	Sint16 x, y;
	Uint16 w, h;
}

struct private_hwdata;
struct SDL_BlitMap;
extern (C) struct SDL_Surface
{
	Uint32 flags;				
	SDL_PixelFormat *format;		
	int w, h;				
	Uint16 pitch;				
	void *pixels;				
	int offset;				
	private_hwdata *hwdata;
	SDL_Rect clip_rect;			
	Uint32 unused1;				
	Uint32 locked;				
	SDL_BlitMap *map;
	uint format_version;
	int refcount;
}

extern(C) struct SDL_VideoInfo 
{
  mixin(bitfields!(
  Uint32, "hw_available",1,
  Uint32, "wm_available",1,
  Uint32, "blit_hw",1,
  Uint32, "blit_hw_CC",1,
  Uint32, "blit_hw_A",1,
  Uint32, "blit_sw",1,
  Uint32, "blit_sw_CC",1,
  Uint32, "blit_sw_A",1));
  Uint32 blit_fill;
  Uint32 video_mem;
  SDL_PixelFormat *vfmt;
}

struct WMcursor;
extern(C) struct SDL_Cursor {
	SDL_Rect area;			
	Sint16 hot_x, hot_y;		
	Uint8 *data;			
	Uint8 *mask;			
	Uint8*[2] save;		
	WMcursor *wm_cursor;	
}

struct private_yuvhwfuncs;
struct private_yuvhwdata;
struct SDL_Overlay {
	Uint32 format;				
	int w, h;				
	int planes;				
	Uint16 *pitches;			
	Uint8 **pixels;				
	private_yuvhwfuncs *hwfuncs;
	private_yuvhwdata *hwdata;	
	mixin(bitfields!(
		Uint32, "hw_overlay",1,
		Uint32, "UnusedBits",31));
}

enum Uint32 SDL_SWSURFACE = 0x00000000;	
enum Uint32 SDL_HWSURFACE = 0x00000001;	
enum Uint32 SDL_ASYNCBLIT = 0x00000004;	
enum Uint32 SDL_ANYFORMAT =  0x10000000;	
enum Uint32 SDL_HWPALETTE =  0x20000000;	
enum Uint32 SDL_DOUBLEBUF =  0x40000000;	
enum Uint32 SDL_FULLSCREEN = 0x80000000;	
enum Uint32 SDL_OPENGL =     0x00000002;    
enum Uint32 SDL_OPENGLBLIT = 0x0000000A;	
enum Uint32 SDL_RESIZABLE =  0x00000010;	
enum Uint32 SDL_NOFRAME =    0x00000020;

// only used internally by SDL. They're here because SDL_MUSTLOCK
// requires SDL_RLEACCEL and fuck it. Might need the others down the road.
enum Uint32 SDL_HWACCEL	    = 0x00000100;
enum Uint32 SDL_SRCCOLORKEY	= 0x00001000;	
enum Uint32 SDL_RLEACCELOK  = 0x00002000;
enum Uint32 SDL_RLEACCEL    = 0x00004000;	
enum Uint32 SDL_SRCALPHA    = 0x00010000;	
enum Uint32 SDL_PREALLOC    = 0x01000000;

// couldn't find these in the headers but they're mentioned in the docs
// for SDL_SetAlpha().
enum Uint8 SDL_ALPHA_TRANSPARENT = 0x0;
enum Uint8 SDL_ALPHA_OPAQUE = 0xFF;

enum int SDL_QUERY	  =-1;
enum int SDL_IGNORE   = 0;
enum int SDL_DISABLE  = 0;
enum int SDL_ENABLE	  = 1;

enum SDL_GLattr 
{
	SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE,
    SDL_GL_STEREO,
    SDL_GL_MULTISAMPLEBUFFERS,
    SDL_GL_MULTISAMPLESAMPLES,
    SDL_GL_ACCELERATED_VISUAL,
    SDL_GL_SWAP_CONTROL
}

extern(C) struct SDL_RWops {
	//int (SDLCALL *seek)(struct SDL_RWops *context, int offset, int whence);
    int function(SDL_RWops *context, int offset, int whence) seek;
	//int (SDLCALL *read)(struct SDL_RWops *context, void *ptr, int size, int maxnum);
	int function(SDL_RWops *context, void *ptr, int size, int maxnum) read;
	//int (SDLCALL *write)(struct SDL_RWops *context, const void *ptr, int size, int num);
	int function(SDL_RWops *context, const void *ptr, int size, int num) write;
	
	//int (SDLCALL *close)(struct SDL_RWops *context);
	int function(SDL_RWops *context) close;
	Uint32 type;
	union _hidden
	{
//#if defined(__WIN32__) && !defined(__SYMBIAN32__)
		version(Windows)
		{
			struct _win32io 
			{
				int   append;
				void *h;
				struct _buffer
				{
					void *data;
					int size;
					int left;
				}
				_buffer buffer;
			}
			_win32io win32io;
		}
//#endif
	    struct _stdio 
	    {
			int autoclose;
			FILE *fp;
	    }
	    _stdio stdio; 

	    struct _mem 
	    {
			Uint8 *base;
			Uint8 *here;
			Uint8 *stop;
	    }
	    _mem mem;
	    struct _unknown 
	    {
			void *data1;
	    }
	    _unknown unknown;
	}
	_hidden hidden;
}

bool SDL_MUSTLOCK(SDL_Surface *surface)
{
	pragma(inline, true);
	return (surface.offset || ((surface.flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0));
}

extern(C) SDL_RWops *SDL_RWFromFile(const char *file, const char *mode);

SDL_Surface *SDL_LoadBMP(const char *file)
{
	pragma(inline, true);
	return SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);
}

int SDL_SaveBMP(SDL_Surface *surface, const char *file)
{
	pragma(inline, true);
	return SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1);
}

extern(C) SDL_Surface *SDL_GetVideoSurface();
extern(C) SDL_VideoInfo *SDL_GetVideoInfo();
extern(C) char* SDL_VideoDriverName(char *namebuf, int maxlen);
extern(C) SDL_Rect **SDL_ListModes(SDL_PixelFormat *format, Uint32 flags);
extern(C) int SDL_VideoModeOK(int width, int height, int bpp, Uint32 flags);
extern(C) SDL_Surface *SDL_SetVideoMode(int width, int height, int bpp, Uint32 flags);
extern(C) void SDL_UpdateRect(SDL_Surface *screen, Sint32 x, Sint32 y, Sint32 w, Sint32 h);
extern(C) void SDL_UpdateRects(SDL_Surface *screen, int numrects, SDL_Rect *rects);
extern(C) int SDL_Flip(SDL_Surface *screen);
extern(C) int SDL_SetColors(SDL_Surface *surface, SDL_Color *colors, int firstcolor, int ncolors);
extern(C) int SDL_SetPalette(SDL_Surface *surface, int flags, SDL_Color *colors, int firstcolor, int ncolors);
extern(C) int SDL_SetGamma(float redgamma, float greengamma, float bluegamma);
extern(C) int SDL_GetGammaRamp(Uint16 *redtable, Uint16 *greentable, Uint16 *bluetable);
extern(C) int SDL_SetGammaRamp(Uint16 *redtable, Uint16 *greentable, Uint16 *bluetable);
extern(C) Uint32 SDL_MapRGB(SDL_PixelFormat *fmt, Uint8 r, Uint8 g, Uint8 b);
extern(C) Uint32 SDL_MapRGBA(SDL_PixelFormat *fmt, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
extern(C) void SDL_GetRGB(Uint32 pixel, SDL_PixelFormat *fmt, Uint8 *r, Uint8 *g, Uint8 *b);
extern(C) void SDL_GetRGBA(Uint32 pixel, SDL_PixelFormat *fmt, Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a);
extern(C) SDL_Surface *SDL_CreateRGBSurface(Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
extern(C) SDL_Surface *SDL_CreateRGBSurfaceFrom(void *pixels, int width, int height, int depth, int pitch, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask);
extern(C) void SDL_FreeSurface(SDL_Surface *surface);
extern(C) int SDL_LockSurface(SDL_Surface *surface);
extern(C) void SDL_UnlockSurface(SDL_Surface *surface);
extern(C) SDL_Surface *SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);
extern(C) int SDL_SaveBMP_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst);
extern(C) int SDL_SetColorKey(SDL_Surface *surface, Uint32 flag, Uint32 key);
extern(C) int SDL_SetAlpha(SDL_Surface *surface, Uint32 flag, Uint8 alpha);
extern(C) void SDL_SetClipRect(SDL_Surface *surface, SDL_Rect *rect);
extern(C) void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect);
extern(C) SDL_Surface *SDL_ConvertSurface(SDL_Surface *src, SDL_PixelFormat *fmt, Uint32 flags);
extern(C) int SDL_UpperBlit(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst, SDL_Rect *dstrect);
alias SDL_UpperBlit SDL_BlitSurface;
extern(C) int SDL_FillRect(SDL_Surface *dst, SDL_Rect *dstrect, Uint32 color);
extern(C) SDL_Surface *SDL_DisplayFormat(SDL_Surface *surface);
extern(C) SDL_Surface *SDL_DisplayFormatAlpha(SDL_Surface *surface);
extern(C) void SDL_WarpMouse(Uint16 x, Uint16 y);
extern(C) SDL_Cursor *SDL_CreateCursor(Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y);
extern(C) void SDL_FreeCursor(SDL_Cursor *cursor);
extern(C) void SDL_SetCursor(SDL_Cursor *cursor);
extern(C) SDL_Cursor *SDL_GetCursor();
extern(C) int SDL_ShowCursor(int toggle);
extern(C) int SDL_GL_LoadLibrary(const char *path);
extern(C) void *SDL_GL_GetProcAddress(const char* proc);
extern(C) int SDL_GL_GetAttribute(SDL_GLattr attr, int *value);
extern(C) int SDL_GL_SetAttribute(SDL_GLattr attr, int value);
extern(C) void SDL_GL_SwapBuffers();
extern(C) SDL_Overlay *SDL_CreateYUVOverlay(int width, int height, Uint32 format, SDL_Surface *display);
extern(C) int SDL_LockYUVOverlay(SDL_Overlay *overlay);
extern(C) void SDL_UnlockYUVOverlay(SDL_Overlay *overlay);
extern(C) int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect);
extern(C) void SDL_FreeYUVOverlay(SDL_Overlay *overlay);

//---------------------------------------------------------------------
// CHAPTER 7. WINDOW MANAGEMENT
//---------------------------------------------------------------------
enum SDL_GrabMode
{
  SDL_GRAB_QUERY = -1,
  SDL_GRAB_OFF = 0,
  SDL_GRAB_ON =  1,
  SDL_GRAB_FULLSCREEN // only used internally by SDL but here for completeness.
}

extern(C) void SDL_WM_SetCaption(const char *title, const char *icon);
extern(C) void SDL_WM_GetCaption(char **title, char **icon);
extern(C) void SDL_WM_SetIcon(SDL_Surface *icon, Uint8 *mask);
extern(C) int SDL_WM_IconifyWindow();
extern(C) int SDL_WM_ToggleFullScreen(SDL_Surface *surface);
extern(C) SDL_GrabMode SDL_WM_GrabInput(SDL_GrabMode mode);

//--------------------------------------------------------------------
// CHAPTER 8. EVENTS
//--------------------------------------------------------------------
 extern(C) struct SDL_ActiveEvent 
 {
	Uint8 type;	
	Uint8 gain;	
	Uint8 state;
}

extern(C) struct SDL_KeyboardEvent 
{
	Uint8 type;	
	Uint8 which;	
	Uint8 state;
	SDL_keysym keysym;
}

extern(C) struct SDL_MouseMotionEvent 
{
	Uint8 type;	
	Uint8 which;	
	Uint8 state;	
	Uint16 x, y;	
	Sint16 xrel;
	Sint16 yrel;
}

extern(C) struct SDL_MouseButtonEvent 
{
	Uint8 type;
	Uint8 which;	
	Uint8 button;	
	Uint8 state;
	Uint16 x, y;
}

extern(C) struct SDL_JoyAxisEvent 
{
	Uint8 type;
	Uint8 which;
	Uint8 axis;	
	Sint16 value;
}

extern(C) struct SDL_JoyBallEvent 
{
	Uint8 type;	
	Uint8 which;	
	Uint8 ball;	
	Sint16 xrel;	
	Sint16 yrel;
}

extern(C) struct SDL_JoyHatEvent 
{
	Uint8 type;	
	Uint8 which;	
	Uint8 hat;	
	Uint8 value;
}

extern(C) struct SDL_JoyButtonEvent 
{
	Uint8 type;	
	Uint8 which;	
	Uint8 button;	
	Uint8 state;
}

extern(C) struct SDL_ResizeEvent 
{
	Uint8 type;	
	int w;		
	int h;
}

extern(C) struct SDL_ExposeEvent 
{
	Uint8 type;
}

extern(C) struct SDL_QuitEvent 
{
	Uint8 type;	
}

extern(C) struct SDL_UserEvent 
{
	Uint8 type;	
	int code;	
	void *data1;	
	void *data2;
}

struct SDL_SysWMmsg;
extern(C) struct SDL_SysWMEvent 
{
	Uint8 type;
	SDL_SysWMmsg *msg;
}

extern(C) union SDL_Event 
{
	Uint8 type;
	SDL_ActiveEvent active;
	SDL_KeyboardEvent key;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_ResizeEvent resize;
	SDL_ExposeEvent expose;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;
}

enum SDL_EventType 
{
	SDL_NOEVENT = 0,			
    SDL_ACTIVEEVENT,			
    SDL_KEYDOWN,			
    SDL_KEYUP,			
    SDL_MOUSEMOTION,			
    SDL_MOUSEBUTTONDOWN,		
    SDL_MOUSEBUTTONUP,		
    SDL_JOYAXISMOTION,		
    SDL_JOYBALLMOTION,		
    SDL_JOYHATMOTION,		
    SDL_JOYBUTTONDOWN,		
    SDL_JOYBUTTONUP,			
    SDL_QUIT,			
    SDL_SYSWMEVENT,			
    SDL_EVENT_RESERVEDA,		
    SDL_EVENT_RESERVEDB,		
    SDL_VIDEORESIZE,		
    SDL_VIDEOEXPOSE,			
    SDL_EVENT_RESERVED2,		
    SDL_EVENT_RESERVED3,		
    SDL_EVENT_RESERVED4,		
    SDL_EVENT_RESERVED5,		
    SDL_EVENT_RESERVED6,		
    SDL_EVENT_RESERVED7,		
    // Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use
    SDL_USEREVENT = 24,
    // used internally by SDL
    SDL_NUMEVENTS = 32
}

enum Uint8 SDL_APPMOUSEFOCUS = 0x01;
enum Uint8 SDL_APPINPUTFOCUS = 0x02;
enum Uint8 SDL_APPACTIVE     = 0x04;

enum Uint8 SDL_RELEASED	= 0;
enum Uint8 SDL_PRESSED	= 1;

/*enum Uint8 SDL_HAT_CENTERED	 = 0x00;
enum Uint8 SDL_HAT_UP		 = 0x01;
enum Uint8 SDL_HAT_RIGHT     = 0x02;
enum Uint8 SDL_HAT_DOWN		 = 0x04;
enum Uint8 SDL_HAT_LEFT		 = 0x08;
enum Uint8 SDL_HAT_RIGHTUP	 = (SDL_HAT_RIGHT|SDL_HAT_UP);
enum Uint8 SDL_HAT_RIGHTDOWN = (SDL_HAT_RIGHT|SDL_HAT_DOWN);
enum Uint8 SDL_HAT_LEFTUP	 = (SDL_HAT_LEFT|SDL_HAT_UP);
enum Uint8 SDL_HAT_LEFTDOWN	 = (SDL_HAT_LEFT|SDL_HAT_DOWN);*/

extern(C) struct SDL_version {
	Uint8 major;
	Uint8 minor;
	Uint8 patch;
}

enum Uint8 SDL_MAJOR_VERSION = 1;
enum Uint8 SDL_MINOR_VERSION = 2;
enum Uint8 SDL_PATCHLEVEL    = 15;

void SDL_VERSION(ref SDL_version x)
{
	pragma(inline, true);
	x.major = SDL_MAJOR_VERSION;
	x.minor = SDL_MINOR_VERSION;				
	x.patch = SDL_PATCHLEVEL;
}

/*#define SDL_QuitRequested() \
        (SDL_PumpEvents(), SDL_PeepEvents(NULL,0,SDL_PEEKEVENT,SDL_QUITMASK))*/
int SDL_QuitRequested()
{
	pragma(inline, true);
	SDL_PumpEvents();
	return SDL_PeepEvents(null, 0, SDL_eventaction.SDL_PEEKEVENT, SDL_EventMask.SDL_QUITMASK);
}

enum SDL_eventaction
{
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT
};

extern(C) struct SDL_keysym 
{
	Uint8 scancode;			
	SDLKey sym;			
	SDLMod mod;			
	Uint16 unicode;	
}

//#define SDL_EVENTMASK(X)	(1<<(X))
Uint32 SDL_EVENTMASK(Uint32 X)
{
	pragma(inline, true);
	return (1 << X);
}

enum SDL_EventMask
{
	SDL_ACTIVEEVENTMASK	= SDL_EVENTMASK(SDL_EventType.SDL_ACTIVEEVENT),
	SDL_KEYDOWNMASK		= SDL_EVENTMASK(SDL_EventType.SDL_KEYDOWN),
	SDL_KEYUPMASK		= SDL_EVENTMASK(SDL_EventType.SDL_KEYUP),
	SDL_KEYEVENTMASK	= SDL_EVENTMASK(SDL_EventType.SDL_KEYDOWN)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_KEYUP),
	SDL_MOUSEMOTIONMASK	= SDL_EVENTMASK(SDL_EventType.SDL_MOUSEMOTION),
	SDL_MOUSEBUTTONDOWNMASK	= SDL_EVENTMASK(SDL_EventType.SDL_MOUSEBUTTONDOWN),
	SDL_MOUSEBUTTONUPMASK	= SDL_EVENTMASK(SDL_EventType.SDL_MOUSEBUTTONUP),
	SDL_MOUSEEVENTMASK	= SDL_EVENTMASK(SDL_EventType.SDL_MOUSEMOTION)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_MOUSEBUTTONDOWN)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_MOUSEBUTTONUP),
	SDL_JOYAXISMOTIONMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYAXISMOTION),
	SDL_JOYBALLMOTIONMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYBALLMOTION),
	SDL_JOYHATMOTIONMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYHATMOTION),
	SDL_JOYBUTTONDOWNMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYBUTTONDOWN),
	SDL_JOYBUTTONUPMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYBUTTONUP),
	SDL_JOYEVENTMASK	= SDL_EVENTMASK(SDL_EventType.SDL_JOYAXISMOTION)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_JOYBALLMOTION)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_JOYHATMOTION)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_JOYBUTTONDOWN)|
	                          SDL_EVENTMASK(SDL_EventType.SDL_JOYBUTTONUP),
	SDL_VIDEORESIZEMASK	= SDL_EVENTMASK(SDL_EventType.SDL_VIDEORESIZE),
	SDL_VIDEOEXPOSEMASK	= SDL_EVENTMASK(SDL_EventType.SDL_VIDEOEXPOSE),
	SDL_QUITMASK		= SDL_EVENTMASK(SDL_EventType.SDL_QUIT),
	SDL_SYSWMEVENTMASK	= SDL_EVENTMASK(SDL_EventType.SDL_SYSWMEVENT)
}

enum SDLKey 
{
	SDLK_UNKNOWN		= 0,
	SDLK_FIRST		= 0,
	SDLK_BACKSPACE		= 8,
	SDLK_TAB		= 9,
	SDLK_CLEAR		= 12,
	SDLK_RETURN		= 13,
	SDLK_PAUSE		= 19,
	SDLK_ESCAPE		= 27,
	SDLK_SPACE		= 32,
	SDLK_EXCLAIM		= 33,
	SDLK_QUOTEDBL		= 34,
	SDLK_HASH		= 35,
	SDLK_DOLLAR		= 36,
	SDLK_AMPERSAND		= 38,
	SDLK_QUOTE		= 39,
	SDLK_LEFTPAREN		= 40,
	SDLK_RIGHTPAREN		= 41,
	SDLK_ASTERISK		= 42,
	SDLK_PLUS		= 43,
	SDLK_COMMA		= 44,
	SDLK_MINUS		= 45,
	SDLK_PERIOD		= 46,
	SDLK_SLASH		= 47,
	SDLK_0			= 48,
	SDLK_1			= 49,
	SDLK_2			= 50,
	SDLK_3			= 51,
	SDLK_4			= 52,
	SDLK_5			= 53,
	SDLK_6			= 54,
	SDLK_7			= 55,
	SDLK_8			= 56,
	SDLK_9			= 57,
	SDLK_COLON		= 58,
	SDLK_SEMICOLON		= 59,
	SDLK_LESS		= 60,
	SDLK_EQUALS		= 61,
	SDLK_GREATER		= 62,
	SDLK_QUESTION		= 63,
	SDLK_AT			= 64,
	/* 
	   Skip uppercase letters
	 */
	SDLK_LEFTBRACKET	= 91,
	SDLK_BACKSLASH		= 92,
	SDLK_RIGHTBRACKET	= 93,
	SDLK_CARET		= 94,
	SDLK_UNDERSCORE		= 95,
	SDLK_BACKQUOTE		= 96,
	SDLK_a			= 97,
	SDLK_b			= 98,
	SDLK_c			= 99,
	SDLK_d			= 100,
	SDLK_e			= 101,
	SDLK_f			= 102,
	SDLK_g			= 103,
	SDLK_h			= 104,
	SDLK_i			= 105,
	SDLK_j			= 106,
	SDLK_k			= 107,
	SDLK_l			= 108,
	SDLK_m			= 109,
	SDLK_n			= 110,
	SDLK_o			= 111,
	SDLK_p			= 112,
	SDLK_q			= 113,
	SDLK_r			= 114,
	SDLK_s			= 115,
	SDLK_t			= 116,
	SDLK_u			= 117,
	SDLK_v			= 118,
	SDLK_w			= 119,
	SDLK_x			= 120,
	SDLK_y			= 121,
	SDLK_z			= 122,
	SDLK_DELETE		= 127,

	SDLK_WORLD_0		= 160,		/* 0xA0 */
	SDLK_WORLD_1		= 161,
	SDLK_WORLD_2		= 162,
	SDLK_WORLD_3		= 163,
	SDLK_WORLD_4		= 164,
	SDLK_WORLD_5		= 165,
	SDLK_WORLD_6		= 166,
	SDLK_WORLD_7		= 167,
	SDLK_WORLD_8		= 168,
	SDLK_WORLD_9		= 169,
	SDLK_WORLD_10		= 170,
	SDLK_WORLD_11		= 171,
	SDLK_WORLD_12		= 172,
	SDLK_WORLD_13		= 173,
	SDLK_WORLD_14		= 174,
	SDLK_WORLD_15		= 175,
	SDLK_WORLD_16		= 176,
	SDLK_WORLD_17		= 177,
	SDLK_WORLD_18		= 178,
	SDLK_WORLD_19		= 179,
	SDLK_WORLD_20		= 180,
	SDLK_WORLD_21		= 181,
	SDLK_WORLD_22		= 182,
	SDLK_WORLD_23		= 183,
	SDLK_WORLD_24		= 184,
	SDLK_WORLD_25		= 185,
	SDLK_WORLD_26		= 186,
	SDLK_WORLD_27		= 187,
	SDLK_WORLD_28		= 188,
	SDLK_WORLD_29		= 189,
	SDLK_WORLD_30		= 190,
	SDLK_WORLD_31		= 191,
	SDLK_WORLD_32		= 192,
	SDLK_WORLD_33		= 193,
	SDLK_WORLD_34		= 194,
	SDLK_WORLD_35		= 195,
	SDLK_WORLD_36		= 196,
	SDLK_WORLD_37		= 197,
	SDLK_WORLD_38		= 198,
	SDLK_WORLD_39		= 199,
	SDLK_WORLD_40		= 200,
	SDLK_WORLD_41		= 201,
	SDLK_WORLD_42		= 202,
	SDLK_WORLD_43		= 203,
	SDLK_WORLD_44		= 204,
	SDLK_WORLD_45		= 205,
	SDLK_WORLD_46		= 206,
	SDLK_WORLD_47		= 207,
	SDLK_WORLD_48		= 208,
	SDLK_WORLD_49		= 209,
	SDLK_WORLD_50		= 210,
	SDLK_WORLD_51		= 211,
	SDLK_WORLD_52		= 212,
	SDLK_WORLD_53		= 213,
	SDLK_WORLD_54		= 214,
	SDLK_WORLD_55		= 215,
	SDLK_WORLD_56		= 216,
	SDLK_WORLD_57		= 217,
	SDLK_WORLD_58		= 218,
	SDLK_WORLD_59		= 219,
	SDLK_WORLD_60		= 220,
	SDLK_WORLD_61		= 221,
	SDLK_WORLD_62		= 222,
	SDLK_WORLD_63		= 223,
	SDLK_WORLD_64		= 224,
	SDLK_WORLD_65		= 225,
	SDLK_WORLD_66		= 226,
	SDLK_WORLD_67		= 227,
	SDLK_WORLD_68		= 228,
	SDLK_WORLD_69		= 229,
	SDLK_WORLD_70		= 230,
	SDLK_WORLD_71		= 231,
	SDLK_WORLD_72		= 232,
	SDLK_WORLD_73		= 233,
	SDLK_WORLD_74		= 234,
	SDLK_WORLD_75		= 235,
	SDLK_WORLD_76		= 236,
	SDLK_WORLD_77		= 237,
	SDLK_WORLD_78		= 238,
	SDLK_WORLD_79		= 239,
	SDLK_WORLD_80		= 240,
	SDLK_WORLD_81		= 241,
	SDLK_WORLD_82		= 242,
	SDLK_WORLD_83		= 243,
	SDLK_WORLD_84		= 244,
	SDLK_WORLD_85		= 245,
	SDLK_WORLD_86		= 246,
	SDLK_WORLD_87		= 247,
	SDLK_WORLD_88		= 248,
	SDLK_WORLD_89		= 249,
	SDLK_WORLD_90		= 250,
	SDLK_WORLD_91		= 251,
	SDLK_WORLD_92		= 252,
	SDLK_WORLD_93		= 253,
	SDLK_WORLD_94		= 254,
	SDLK_WORLD_95		= 255,		/* 0xFF */

	/*Numeric keypad */
      
	SDLK_KP0		= 256,
	SDLK_KP1		= 257,
	SDLK_KP2		= 258,
	SDLK_KP3		= 259,
	SDLK_KP4		= 260,
	SDLK_KP5		= 261,
	SDLK_KP6		= 262,
	SDLK_KP7		= 263,
	SDLK_KP8		= 264,
	SDLK_KP9		= 265,
	SDLK_KP_PERIOD		= 266,
	SDLK_KP_DIVIDE		= 267,
	SDLK_KP_MULTIPLY	= 268,
	SDLK_KP_MINUS		= 269,
	SDLK_KP_PLUS		= 270,
	SDLK_KP_ENTER		= 271,
	SDLK_KP_EQUALS		= 272,
   
	/*Arrows + Home/End pad */
       
	SDLK_UP			= 273,
	SDLK_DOWN		= 274,
	SDLK_RIGHT		= 275,
	SDLK_LEFT		= 276,
	SDLK_INSERT		= 277,
	SDLK_HOME		= 278,
	SDLK_END		= 279,
	SDLK_PAGEUP		= 280,
	SDLK_PAGEDOWN		= 281,

	/* Function keys */
	SDLK_F1			= 282,
	SDLK_F2			= 283,
	SDLK_F3			= 284,
	SDLK_F4			= 285,
	SDLK_F5			= 286,
	SDLK_F6			= 287,
	SDLK_F7			= 288,
	SDLK_F8			= 289,
	SDLK_F9			= 290,
	SDLK_F10		= 291,
	SDLK_F11		= 292,
	SDLK_F12		= 293,
	SDLK_F13		= 294,
	SDLK_F14		= 295,
	SDLK_F15		= 296,
    
	/*Key state modifier keys */
 
	SDLK_NUMLOCK		= 300,
	SDLK_CAPSLOCK		= 301,
	SDLK_SCROLLOCK		= 302,
	SDLK_RSHIFT		= 303,
	SDLK_LSHIFT		= 304,
	SDLK_RCTRL		= 305,
	SDLK_LCTRL		= 306,
	SDLK_RALT		= 307,
	SDLK_LALT		= 308,
	SDLK_RMETA		= 309,
	SDLK_LMETA		= 310,
	SDLK_LSUPER		= 311,		/*Left "Windows" key */
	SDLK_RSUPER		= 312,		/*Right "Windows" key */
	SDLK_MODE		= 313,		/*"Alt Gr" key */
	SDLK_COMPOSE		= 314,		/*Multi-key compose key */
     
	/*Miscellaneous function keys */
    
	SDLK_HELP		= 315,
	SDLK_PRINT		= 316,
	SDLK_SYSREQ		= 317,
	SDLK_BREAK		= 318,
	SDLK_MENU		= 319,
	SDLK_POWER		= 320,		/* Power Macintosh power key */
	SDLK_EURO		= 321,		/* Some european keyboards */
	SDLK_UNDO		= 322,		/* Atari keyboard has Undo */

	/* Add any other keys here */

	SDLK_LAST
}

enum SDLMod
{
	KMOD_NONE  = 0x0000,
	KMOD_LSHIFT= 0x0001,
	KMOD_RSHIFT= 0x0002,
	KMOD_LCTRL = 0x0040,
	KMOD_RCTRL = 0x0080,
	KMOD_LALT  = 0x0100,
	KMOD_RALT  = 0x0200,
	KMOD_LMETA = 0x0400,
	KMOD_RMETA = 0x0800,
	KMOD_NUM   = 0x1000,
	KMOD_CAPS  = 0x2000,
	KMOD_MODE  = 0x4000,
	KMOD_RESERVED = 0x8000
}

enum KMOD_CTRL  = (SDLMod.KMOD_LCTRL|SDLMod.KMOD_RCTRL);
enum KMOD_SHIFT = (SDLMod.KMOD_LSHIFT|SDLMod.KMOD_RSHIFT);
enum KMOD_ALT	 = (SDLMod.KMOD_LALT|SDLMod.KMOD_RALT);
enum KMOD_META =(SDLMod.KMOD_LMETA|SDLMod.KMOD_RMETA);

enum int SDL_DEFAULT_REPEAT_DELAY    = 500;
enum int SDL_DEFAULT_REPEAT_INTERVAL = 30;

//#define SDL_BUTTON(X)		(1 << ((X)-1))
Uint8 SDL_BUTTON(Uint8 X)
{
	pragma(inline, true);
	return cast(ubyte)(1 << (X - 1));
}

enum SDL_BUTTON_LEFT	  = 1;
enum SDL_BUTTON_MIDDLE	  = 2;
enum SDL_BUTTON_RIGHT	  = 3;
enum SDL_BUTTON_WHEELUP	  = 4;
enum SDL_BUTTON_WHEELDOWN = 5;
enum SDL_BUTTON_X1        = 6;
enum SDL_BUTTON_X2		  = 7;
enum SDL_BUTTON_LMASK	  = SDL_BUTTON(SDL_BUTTON_LEFT);
enum SDL_BUTTON_MMASK	  = SDL_BUTTON(SDL_BUTTON_MIDDLE);
enum SDL_BUTTON_RMASK	  = SDL_BUTTON(SDL_BUTTON_RIGHT);
enum SDL_BUTTON_X1MASK	  = SDL_BUTTON(SDL_BUTTON_X1);
enum SDL_BUTTON_X2MASK	  = SDL_BUTTON(SDL_BUTTON_X2);

extern(C) void SDL_PumpEvents();
extern(C) int SDL_PeepEvents(SDL_Event *events, int numevents, SDL_eventaction action, Uint32 mask);
extern(C) int SDL_PollEvent(SDL_Event *event);
extern(C) int SDL_WaitEvent(SDL_Event *event);
extern(C) int SDL_PushEvent(SDL_Event *event);
extern(C) alias SDL_EventFilter = int function(const SDL_Event *event);
extern(C) void SDL_SetEventFilter(SDL_EventFilter filter);
extern(C) SDL_EventFilter SDL_GetEventFilter();
extern(C) Uint8 SDL_EventState(Uint8 type, int state);
extern(C) Uint8 *SDL_GetKeyState(int *numkeys);
extern(C) SDLMod SDL_GetModState();
extern(C) void SDL_SetModState(SDLMod modstate);
extern(C) char *SDL_GetKeyName(SDLKey key);
extern(C) int SDL_EnableUNICODE(int enable);
extern(C) int SDL_EnableKeyRepeat(int delay, int interval);
extern(C) Uint8 SDL_GetMouseState(int *x, int *y);
extern(C) Uint8 SDL_GetRelativeMouseState(int *x, int *y);
extern(C) Uint8 SDL_GetAppState();
int SDL_JoystickEventState(int state);

//--------------------------------------------------------------------
// CHAPTER 9. JOYSTICK
//--------------------------------------------------------------------

enum SDL_HAT_CENTERED  = 0x00;
enum SDL_HAT_UP		   = 0x01;
enum SDL_HAT_RIGHT	   = 0x02;
enum SDL_HAT_DOWN	   = 0x04;
enum SDL_HAT_LEFT	   = 0x08;
enum SDL_HAT_RIGHTUP   = (SDL_HAT_RIGHT|SDL_HAT_UP);
enum SDL_HAT_RIGHTDOWN = (SDL_HAT_RIGHT|SDL_HAT_DOWN);
enum SDL_HAT_LEFTUP	   = (SDL_HAT_LEFT|SDL_HAT_UP);
enum SDL_HAT_LEFTDOWN  = (SDL_HAT_LEFT|SDL_HAT_DOWN);

struct SDL_Joystick;

extern(C) int SDL_NumJoysticks();
extern(C) const(char)* SDL_JoystickName(int index);
extern(C) SDL_Joystick *SDL_JoystickOpen(int index);
extern(C) int SDL_JoystickOpened(int index);
extern(C) int SDL_JoystickIndex(SDL_Joystick *joystick);
extern(C) int SDL_JoystickNumAxes(SDL_Joystick *joystick);
extern(C) int SDL_JoystickNumBalls(SDL_Joystick *joystick);
extern(C) int SDL_JoystickNumHats(SDL_Joystick *joystick);
extern(C) int SDL_JoystickNumButtons(SDL_Joystick *joystick);
extern(C) void SDL_JoystickUpdate();
extern(C) Sint16 SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis);
extern(C) Uint8 SDL_JoystickGetHat(SDL_Joystick *joystick, int hat);
extern(C) Uint8 SDL_JoystickGetButton(SDL_Joystick *joystick, int button);
extern(C) int SDL_JoystickGetBall(SDL_Joystick *joystick, int ball, int *dx, int *dy);
extern(C) void SDL_JoystickClose(SDL_Joystick *joystick);

//---------------------------------------------------------------------
// CHAPTER 10. AUDIO
//---------------------------------------------------------------------
extern(C) alias Callback = void function(void *userdata, Uint8 *stream, int len);
extern(C) struct SDL_AudioSpec 
{
	int freq;		
	Uint16 format;		
	Uint8  channels;	
	Uint8  silence;		
	Uint16 samples;		
	Uint16 padding;		
	Uint32 size;		
	Callback callback;
	void  *userdata;
}

enum Uint16 AUDIO_U8	  = 0x0008;	
enum Uint16 AUDIO_S8	  = 0x8008;	
enum Uint16 AUDIO_U16LSB  =	0x0010;	
enum Uint16 AUDIO_S16LSB  =	0x8010;	
enum Uint16 AUDIO_U16MSB  =	0x1010;	
enum Uint16 AUDIO_S16MSB  =	0x9010;
enum Uint16 AUDIO_U16	  = AUDIO_U16LSB;
enum Uint16 AUDIO_S16	  = AUDIO_S16LSB;

static if(SDL_BYTEORDER == SDL_LIL_ENDIAN)
{
    enum Uint16 AUDIO_U16SYS = AUDIO_U16LSB;
	enum Uint16 AUDIO_S16SYS = AUDIO_S16LSB;
}
else
{
	enum Uint16 AUDIO_U16SYS = AUDIO_U16MSB;
	enum Uint16 AUDIO_S16SYS = AUDIO_S16MSB;
}

enum SDL_audiostatus
{
  SDL_AUDIO_STOPPED,
  SDL_AUDIO_PAUSED,
  SDL_AUDIO_PLAYING
}

alias _filter = void function(SDL_AudioCVT *cvt, Uint16 format);
extern(C) struct SDL_AudioCVT {
	int needed;			
	Uint16 src_format;		
	Uint16 dst_format;		
	double rate_incr;		
	Uint8 *buf;			
	int    len;			
	int    len_cvt;			
	int    len_mult;		
	double len_ratio; 	
	_filter[10] filters;
	int filter_index;		
}

extern(C) SDL_AudioSpec *SDL_LoadWAV_RW(SDL_RWops *src, int freesrc, SDL_AudioSpec *spec, Uint8 **audio_buf, Uint32 *audio_len);
SDL_AudioSpec *SDL_LoadWAV(const char *file, SDL_AudioSpec *spec, Uint8 **audio_buf, Uint32 *audio_len)
{
	pragma(inline, true);
	return SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len);
}
/*#define SDL_LoadWAV(file, spec, audio_buf, audio_len) \
	SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)*/
	
extern(C) int SDL_OpenAudio(SDL_AudioSpec *desired, SDL_AudioSpec *obtained);
extern(C) void SDL_PauseAudio(int pause_on);
extern(C) SDL_audiostatus SDL_GetAudioStatus();
extern(C) void SDL_FreeWAV(Uint8 *audio_buf);
extern(C) int SDL_BuildAudioCVT(SDL_AudioCVT *cvt, Uint16 src_format, Uint8 src_channels, int src_rate, Uint16 dst_format, Uint8 dst_channels, int dst_rate);
extern(C) int SDL_ConvertAudio(SDL_AudioCVT *cvt);
extern(C) void SDL_MixAudio(Uint8 *dst, Uint8 *src, Uint32 len, int volume);
extern(C) void SDL_LockAudio();
extern(C) void SDL_UnlockAudio();
extern(C) void SDL_CloseAudio();

//---------------------------------------------------------------------
// CHAPTER 11. CD-ROM
//---------------------------------------------------------------------
extern(C) struct SDL_CDtrack
{
	Uint8 id;		
	Uint8 type;		
	Uint16 unused;
	Uint32 length;		
	Uint32 offset;		
}

extern(C) struct SDL_CD 
{
	int id;			
	CDstatus status;		
	int numtracks;		
	int cur_track;		
	int cur_frame;		
	SDL_CDtrack[SDL_MAX_TRACKS+1] track;
}

 enum CDstatus
 {
	CD_TRAYEMPTY,
	CD_STOPPED,
	CD_PLAYING,
	CD_PAUSED,
	CD_ERROR = -1
}

enum SDL_MAX_TRACKS	= 99;
enum SDL_AUDIO_TRACK  = 0x00;
enum SDL_DATA_TRACK	  = 0x04;
enum CD_FPS = 75;

void FRAMES_TO_MSF(Uint32 f, Uint32 *M, Uint32 *S, Uint32 *F)
{
	pragma(inline, true);
	
	int value = f;						
	*(F) = value%CD_FPS;					
	value /= CD_FPS;						
	*(S) = value%60;					
	value /= 60;							
	*(M) = value;			
}

Uint32 MSF_TO_FRAMES(Uint32 M, Uint32 S, Uint32 F)
{
	pragma(inline, true);
	return((M)*60*CD_FPS+(S)*CD_FPS+(F));
}

bool CD_INDRIVE(int status)
{
	pragma(inline, true);
	return status > 0;
}

extern(C) int SDL_CDNumDrives();
extern(C) const(char)* SDL_CDName(int drive);
extern(C) SDL_CD *SDL_CDOpen(int drive);
extern(C) CDstatus SDL_CDStatus(SDL_CD *cdrom);
extern(C) int SDL_CDPlay(SDL_CD *cdrom, int start, int length);
extern(C) int SDL_CDPlayTracks(SDL_CD *cdrom, int start_track, int start_frame, int ntracks, int nframes);
extern(C) int SDL_CDPause(SDL_CD *cdrom);
extern(C) int SDL_CDResume(SDL_CD *cdrom);
extern(C) int SDL_CDStop(SDL_CD *cdrom);
extern(C) int SDL_CDEject(SDL_CD *cdrom);
extern(C) void SDL_CDClose(SDL_CD *cdrom);

//---------------------------------------------------------------------
// CHAPTER 12. MULTI-THREADED PROGRAMMING
//---------------------------------------------------------------------
enum SDL_MUTEX_TIMEDOUT = 1;
enum SDL_MUTEX_MAXWAIT = (~cast(Uint32)0);

struct SDL_mutex;
struct SDL_semaphore;
struct SDL_Thread;
struct SDL_cond;

alias SDL_sem = SDL_semaphore;
alias _fn = int function(void *);
alias SDL_LockMutex = SDL_mutexP;
alias SDL_UnlockMutex = SDL_mutexV;

extern(C) SDL_Thread *SDL_CreateThread(_fn fn, void *data);
extern(C) Uint32 SDL_ThreadID();
extern(C) Uint32 SDL_GetThreadID(SDL_Thread *thread);
extern(C) void SDL_WaitThread(SDL_Thread *thread, int *status);
extern(C) void SDL_KillThread(SDL_Thread *thread);
extern(C) SDL_mutex *SDL_CreateMutex();
extern(C) void SDL_DestroyMutex(SDL_mutex *mutex);
extern(C) int SDL_mutexP(SDL_mutex *mutex);
extern(C) int SDL_mutexV(SDL_mutex *mutex);
extern(C) SDL_sem *SDL_CreateSemaphore(Uint32 initial_value);
extern(C) void SDL_DestroySemaphore(SDL_sem *sem);
extern(C) int SDL_SemWait(SDL_sem *sem);
extern(C) int SDL_SemTryWait(SDL_sem *sem);
extern(C) int SDL_SemWaitTimeout(SDL_sem *sem, Uint32 timeout);
extern(C) int SDL_SemPost(SDL_sem *sem);
extern(C) Uint32 SDL_SemValue(SDL_sem *sem);
extern(C) SDL_cond *SDL_CreateCond();
extern(C) void SDL_DestroyCond(SDL_cond *cond);
extern(C) int SDL_CondSignal(SDL_cond *cond);
extern(C) int SDL_CondBroadcast(SDL_cond *cond);
extern(C) int SDL_CondWait(SDL_cond *cond, SDL_mutex *mut);
extern(C) int SDL_CondWaitTimeout(SDL_cond *cond, SDL_mutex *mutex, Uint32 ms);

//---------------------------------------------------------------------
// CHAPTER 13. TIME
//---------------------------------------------------------------------
extern(C) alias SDL_NewTimerCallback = Uint32 function(Uint32 interval, void *param);
extern(C) alias SDL_TimerCallback = Uint32 function(Uint32 interval);
struct _SDL_TimerID;
alias _SDL_TimerID *SDL_TimerID;

extern(C) Uint32 SDL_GetTicks();
extern(C) void SDL_Delay(Uint32 ms);
/* 
 * Callbacks for SDL_AddTimer are created like so:
 * extern(C) Uint32 timerCallback(Uint32 u, void *p)
 * {
 * 		printf("Callback called!\n");
 * 		return 0;
 * }
 * 
 * Don't forget the extern(C)!
 */
extern(C) SDL_TimerID SDL_AddTimer(Uint32 interval, SDL_NewTimerCallback callback, void *param);
extern(C) SDL_bool SDL_RemoveTimer(SDL_TimerID id);
extern(C) int SDL_SetTimer(Uint32 interval, SDL_TimerCallback callback);
