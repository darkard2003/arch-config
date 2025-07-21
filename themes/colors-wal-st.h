const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#1a1b1e", /* black   */
  [1] = "#5691A5", /* red     */
  [2] = "#77BED8", /* green   */
  [3] = "#74BEDE", /* yellow  */
  [4] = "#76C1DD", /* blue    */
  [5] = "#75C2E0", /* magenta */
  [6] = "#BDC1B0", /* cyan    */
  [7] = "#c5c6c6", /* white   */

  /* 8 bright colors */
  [8]  = "#606075",  /* black   */
  [9]  = "#5691A5",  /* red     */
  [10] = "#77BED8", /* green   */
  [11] = "#74BEDE", /* yellow  */
  [12] = "#76C1DD", /* blue    */
  [13] = "#75C2E0", /* magenta */
  [14] = "#BDC1B0", /* cyan    */
  [15] = "#c5c6c6", /* white   */

  /* special colors */
  [256] = "#1a1b1e", /* background */
  [257] = "#c5c6c6", /* foreground */
  [258] = "#c5c6c6",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
