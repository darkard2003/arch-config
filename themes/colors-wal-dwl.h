/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const float rootcolor[]             = COLOR(0x1a1b1eff);
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */
	[SchemeNorm] = { 0xc5c6c6ff, 0x1a1b1eff, 0x606075ff },
	[SchemeSel]  = { 0xc5c6c6ff, 0x77BED8ff, 0x5691A5ff },
	[SchemeUrg]  = { 0xc5c6c6ff, 0x5691A5ff, 0x77BED8ff },
};
