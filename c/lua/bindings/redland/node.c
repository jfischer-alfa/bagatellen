#include "node.h"
#include "defs.h"
#include "uri.h"
#include <lauxlib.h>

int
lua_bindings_redland_node_clone(lua_State *L) {
   librdf_node **pp_arg =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   lua_bindings_redland_node_new_mt(L);
   return lua_bindings_redland_node_wrap(L, librdf_new_node_from_node(*pp_arg));
}

int
lua_bindings_redland_node_eq(lua_State *L) {
   librdf_node **pp_arg_1 =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_arg_2 =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   lua_pushboolean(L, librdf_node_equals(*pp_arg_1, *pp_arg_2));

   return 1;
}

int
lua_bindings_redland_node_gc(lua_State *L) {
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   librdf_free_node(*pp_node);

   return 0;
}

int
lua_bindings_redland_node_get_blank(lua_State *L) {
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   if (librdf_node_is_blank(*pp_node)) {
      unsigned char *result =  librdf_node_get_blank_identifier(*pp_node);
      if (result) {
         lua_pushstring(L, result);
         return 1;
      } else {
         luaL_error(L, "problem during getting blank id");
      }
   } else {
      return 0;
   }
}

int
lua_bindings_redland_node_get_li_number(lua_State *L) {
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   lua_pushnumber(L, librdf_node_get_li_ordinal(*pp_node));

   return 1;
}

int
lua_bindings_redland_node_get_literal(lua_State *L) {
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   {
      unsigned char *val =  librdf_node_get_literal_value(*pp_node);
      if (val) {
         lua_newtable(L);
         lua_pushstring(L, val);
         lua_setfield(L, -2, "value");

         {
            int is_well_formed =  librdf_node_get_literal_value_is_wf_xml(
               *pp_node );
            lua_pushboolean(L, is_well_formed);
            lua_setfield(L, -2, "is_wf_xml");
         }

         {
            char *language =  librdf_node_get_literal_value_language(
               *pp_node );
            if (language) {
               lua_pushstring(L, language);
               lua_setfield(L, -2, "language");
            }
         }

         {
            librdf_uri *p_uri =  librdf_node_get_literal_value_datatype_uri(
               *pp_node );
            lua_bindings_redland_uri_new_mt(L);
            if (lua_bindings_redland_uri_wrap(L, p_uri)) {
               lua_setfield(L, -2, "datatype");
            } else {
               lua_pop(L, 1);
            }
         }
         return 1;

      } else {
         return 0;
      }
   }
}

int
lua_bindings_redland_node_get_resource(lua_State *L) {
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 1);

   if (librdf_node_is_resource(*pp_node)) {
      librdf_uri *p_uri =  librdf_node_get_uri(*pp_node);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_node_new_blank(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -1
      ,  world_userdata_type );

   lua_pop(L, 1);

   {
      librdf_node *p_node =  librdf_new_node_from_blank_identifier(
            *pp_arg_1
         ,  NULL );
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}

int
lua_bindings_redland_node_new_literal(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );

   lua_getfield(L, -1, "value");
   const unsigned char *val =  luaL_checkstring(L, -1);
   lua_pop(L, 1);

   librdf_uri **pp_type =  NULL;
   lua_getfield(L, -1, "type");
   if (!lua_isnil(L, -1)) {
      lua_bindings_redland_uri_clone(L);
      pp_type =   (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );
   }
   lua_pop(L, 1);

   const char *language =  NULL;
   lua_getfield(L, -1, "language");
   if (!lua_isnil(L, -1)) {
      language =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   lua_Integer is_wf_xml =  0;
   lua_getfield(L, -1, "is_wf_xml");
   if (!lua_isnil(L, -1)) {
      is_wf_xml =  luaL_checkinteger(L, -1);
   }
   lua_pop(L, 1);

   lua_pop(L, 2);

   {
      librdf_node *p_node =  NULL;

      if (pp_type && *pp_type) {
         p_node =  librdf_new_node_from_typed_literal(
               *pp_arg_1
            ,  val
            ,  language
            ,  *pp_type );
      } else {
         p_node =  librdf_new_node_from_literal(
               *pp_arg_1
            ,  val
            ,  language
            ,  is_wf_xml );
      }

      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}

int
lua_bindings_redland_node_new_resource(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   librdf_uri **pp_arg_2 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );
   lua_bindings_redland_uri_clone(L);

   {
      librdf_node *p_node =  librdf_new_node_from_uri(
            *pp_arg_1
         ,  *pp_arg_2 );
      lua_bindings_redland_node_new_mt(L);

      lua_insert(L, -2);
      lua_setfield(L, -2, "uri");

      lua_insert(L, -2);
      lua_setfield(L, -2, "world");

      return lua_bindings_redland_node_wrap(L, p_node);
   }
}

int
lua_bindings_redland_node_renew_blank(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const char *arg_2 =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   {
      librdf_node *p_node =  librdf_new_node_from_blank_identifier(
            *pp_arg_1
         ,  arg_2 );
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_node_new_mt(lua_State *L) {
   luaL_newmetatable(L, node_userdata_type);
      
   lua_pushcfunction(L, &lua_bindings_redland_node_eq);
   lua_setfield(L, -2, "__eq");
      
   lua_pushcfunction(L, &lua_bindings_redland_node_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_node_wrap(lua_State *L, librdf_node *p_node) {
   if (p_node) {
      librdf_node **pp_node =  (librdf_node **) lua_newuserdata(
            L
         ,  sizeof(librdf_node *) );
      *pp_node =  p_node;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_node(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_node_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_node_get_blank);
   lua_setfield(L, -2, "get_blank");

   lua_pushcfunction(L, &lua_bindings_redland_node_get_li_number);
   lua_setfield(L, -2, "get_li_number");

   lua_pushcfunction(L, &lua_bindings_redland_node_get_literal);
   lua_setfield(L, -2, "get_literal");

   lua_pushcfunction(L, &lua_bindings_redland_node_get_resource);
   lua_setfield(L, -2, "get_resource");

   lua_pushcfunction(L, &lua_bindings_redland_node_new_blank);
   lua_setfield(L, -2, "new_blank");

   lua_pushcfunction(L, &lua_bindings_redland_node_new_literal);
   lua_setfield(L, -2, "new_literal");

   lua_pushcfunction(L, &lua_bindings_redland_node_new_resource);
   lua_setfield(L, -2, "new_resource");

   lua_pushcfunction(L, &lua_bindings_redland_node_renew_blank);
   lua_setfield(L, -2, "renew_blank");

   return 1;
}