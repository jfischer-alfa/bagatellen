#ifndef GRPLOT_INSCRIPTION_H
#define GRPLOT_INSCRIPTION_H

#include <Imlib2.h>

typedef struct {
   char *text;
   int width, height; } grplot_inscription_t;

typedef struct {
   grplot_inscription_t inscription;
   unsigned positionPerPixel; } grplot_inscription_positional_inscription_t;

int
grplot_inscription_init(grplot_inscription_t *, Imlib_Font, char *);


#endif
