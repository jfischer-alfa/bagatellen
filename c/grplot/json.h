#ifndef GRPLOT_JSON_H
#define GRPLOT_JSON_H

#include <Imlib2.h>
#include <jansson.h>

#include "axis.h"
#include "axis_output.h"
#include "diagram.h"
#include "matrix.h"

typedef enum {
      grplot_json_schema_base
   ,  grplot_json_schema_axis
   ,  grplot_json_schema_diagram_base
   ,  grplot_json_schema_diagram } grplot_json_schema_location_type_t;

typedef struct {
   grplot_axis_type_t axisType;
   unsigned nr; } grplot_json_schema_axis_t;

typedef struct {
   unsigned x;
   unsigned y; } grplot_json_schema_diagram_base_t;

typedef struct {
   grplot_json_schema_diagram_base_t base;
   unsigned nr; } grplot_json_schema_diagram_t;

typedef union {
   int base;
   grplot_json_schema_axis_t axis;
   grplot_json_schema_diagram_base_t diagramBase;
   grplot_json_schema_diagram_t diagram; } grplot_json_schema_variant_t;

typedef struct {
   grplot_json_schema_location_type_t locationType;
   grplot_json_schema_variant_t variant; } grplot_json_schema_location_t;

void
grplot_json_printErrMsg(
      const grplot_json_schema_location_t *
   ,  const char * );

void
grplot_json_printColorErrMsg(
      const grplot_json_schema_location_t *
   ,  const char *
   ,  int );

void
grplot_json_printAxisErrMsg(
      const grplot_json_schema_location_t *
   ,  grplot_axis_output_status_t );

void
grplot_json_printDiagramErrMsg(
      const grplot_json_schema_location_t *
   ,  grplot_diagram_status_t );

const int grplot_json_error_red_integer =  1;
const int grplot_json_error_green_integer =  2;
const int grplot_json_error_blue_integer =  4;
const int grplot_json_error_alpha_integer =  8;
const int grplot_json_error_red_range =  16;
const int grplot_json_error_green_range =  32;
const int grplot_json_error_blue_range =  64;
const int grplot_json_error_alpha_range =  128;
const int grplot_json_error_color_object =  256;
int
grplot_json_color(json_t *, DATA32 *);

#endif
