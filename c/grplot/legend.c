#include <assert.h>
#include <stdlib.h>

#include "legend.h"

static grplot_legend_status_t
get_width(
      grplot_legend_t * );

grplot_legend_status_t
grplot_legend_init(
      grplot_legend_t *pLegend
   ,  Imlib_Font font
   ,  unsigned nrItem ) {
   assert(pLegend);

   grplot_legend_status_t retval =  grplot_legend_ok;

   pLegend->font =  font;
   pLegend->nrItem =  nrItem;
   pLegend->pBuf =  (grplot_legend_item_t *) malloc(sizeof(grplot_legend_item_t) * nrItem);

   return retval;
}

grplot_legend_status_t
grplot_legend_inscription_init(
      grplot_legend_t *pLegend
   ,  const char *text
   ,  DATA32 color
   ,  unsigned index ) {
   assert(pLegend);
   assert(text);
   assert(index < pLegend->nrItem);

   grplot_legend_status_t retval =  grplot_legend_ok;
   grplot_inscription_init(
         &((pLegend->pBuf)[index].positionalInscription.inscription)
      ,  pLegend->font
      ,  text );
   (pLegend->pBuf)[index].color =  color;

   return retval;
}

grplot_legend_status_t
grplot_legend_get_color(
      const grplot_legend_t *pLegend
   ,  DATA32 **ppColor
   ,  unsigned index ) {
   assert(pLegend);
   assert(index < pLegend->nrItem);

   grplot_legend_status_t retval =  grplot_legend_ok;

   *ppColor =  &((pLegend->pBuf)[index].color);

   return retval;
}

grplot_legend_status_t
grplot_legend_get_positional_inscription(
      const grplot_legend_t *pLegend
   ,  grplot_inscription_positional_inscription_t **ppPositionalInscription
   ,  unsigned index ) {
   assert(pLegend);
   assert(index < pLegend->nrItem);

   grplot_legend_status_t retval =  grplot_legend_ok;

   *ppPositionalInscription =  &((pLegend->pBuf)[index].positionalInscription);

   return retval;
}

grplot_legend_status_t
grplot_legend_prepare(
      grplot_legend_t *pLegend ) {
   assert(pLegend);

   grplot_legend_status_t retval =  grplot_legend_ok;

   pLegend->height =  0;
   for (unsigned i =  0; i < pLegend->nrItem; i++) {
      (pLegend->pBuf)[i].positionalInscription.positionPerPixel =  pLegend->height;
      pLegend->height += (pLegend->pBuf)[i].positionalInscription.inscription.height;
   }
   get_width(pLegend);

   return retval;
}

grplot_legend_status_t
grplot_legend_draw_LB_horizontal(
      const grplot_legend_t *pLegend
   ,  int x
   ,  int y ) {
   assert(pLegend);

   grplot_legend_status_t retval =  grplot_legend_ok;

   for (unsigned i =  0; i < pLegend->nrItem; i++) {
      grplot_inscription_draw_positional_LB_horizontal(
            &((pLegend->pBuf)[i].positionalInscription)
         ,  (pLegend->pBuf)[i].color
         ,  pLegend->font
         ,  x
         ,  y );
   }

   return retval;
}


void
grplot_legend_destroy(
      grplot_legend_t *pLegend ) {
   assert(pLegend);

   free(pLegend->pBuf);
}

static grplot_legend_status_t
get_width(
      grplot_legend_t *pLegend ) {
   assert(pLegend);

   grplot_legend_status_t retval =  grplot_legend_ok;

   pLegend->width =  0;
   for (unsigned i =  0;  i < pLegend->nrItem; i++) {
      unsigned width =  (pLegend->pBuf)[i].positionalInscription.inscription.width;
      if (width > pLegend->width) {
         pLegend->width =  width;
      }
   }

   return retval;
}

