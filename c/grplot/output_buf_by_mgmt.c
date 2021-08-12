#include <assert.h>

#include "color_diff.h"
#include "output_buf_by_mgmt.h"

int
grplot_output_buf_by_mgmt_set_buf(
      DATA32 *p_out
   ,  const grplot_input_buf_mgmt_t *p_input_buf_mgmt
   ,  unsigned originX
   ,  unsigned originY
   ,  DATA32 backgroundColor ) {
   assert(p_out);
   assert(p_input_buf_mgmt);
   int retval =  0;

   unsigned long idx =  0;
   for (unsigned row =  0; row < p_input_buf_mgmt->nrRows; row++)
   for (unsigned col =  0; col < p_input_buf_mgmt->nrCols; col++) {
      DATA32 *p_out_ptr =  p_out + p_input_buf_mgmt->nrCols * (originY + row) + (originX + col);

      double sumInpVal =  0.0;
      for (unsigned i =  0; i < p_input_buf_mgmt->nrInpBufs; i++) {
         double *p_pixels; 
         grplot_input_buf_mgmt_get_pixels(p_input_buf_mgmt, &p_pixels, i);
         sumInpVal +=  p_pixels[idx];
      }

      double p_foregroundColor[] =  { 0.0, 0.0, 0.0, 0.0 };
      for (unsigned i =  0; i < p_input_buf_mgmt->nrInpBufs; i++) {
         double *p_pixels;
         grplot_input_buf_mgmt_get_pixels(p_input_buf_mgmt, &p_pixels, i);
         const double relVal =  p_pixels[idx];
         const double absVal =  relVal * relVal / sumInpVal;

         double *p_colors;
         grplot_input_buf_mgmt_get_color(p_input_buf_mgmt, &p_colors, i);
         for (unsigned char channel =  0; channel < 4; channel++) {
            p_foregroundColor[channel] +=  p_colors[channel] * absVal;
         }
      }
      grplot_color_diff_decode(p_out_ptr, p_foregroundColor, backgroundColor);
      idx++;
   }

   return retval;
}