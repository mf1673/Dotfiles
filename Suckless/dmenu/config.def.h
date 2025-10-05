/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static const unsigned int alpha = 0xbf;     /* Amount of opacity */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 500;                    /* minimum width when centered */
static const float menu_height_ratio = 4.0f;  /* This is the ratio used in the original calculation */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"monospace:size=12"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm]          = { "#bbbbbb", "#222222" },
	[SchemeSel]           = { "#eeeeee", "#005577" },
	[SchemeOut]           = { "#000000", "#00ffff" },
};
static const unsigned int alphas[SchemeLasts][2] = {
        [SchemeNorm] = { OPAQUE, alpha },
        [SchemeNorm] = { OPAQUE, alpha },
        [SchemeOut]  = { OPAQUE, alpha },
};

/* -l and -g  option; controls number of lines and columns in grid if > 0 */
static unsigned int columns      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
