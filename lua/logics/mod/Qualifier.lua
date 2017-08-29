local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()

package.loaded["logics.mod.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"

function Qualifier:id_factory()
   local retval =  Qualifier:__new()
   retval.qualword =  List:empty_list_factory()
   return retval
end

function Qualifier:append_terminal_symbol(symbol)
   self.qualword:append(symbol)
end

function Qualifier:append_qualifier(other)
   self.qualword:append_list(other.qualword)
end

function Qualifier:get_chopped_copy(qualifier)
   local retval =  self:__clone()
   if retval.qualword:drop_initial_seq(qualifier.qualword)
   then
      return retval
   end
end

function Qualifier:get_name()
   local first_time =  true
   local retval =  String:empty_string_factory()
   local delimiter =  String:string_factory(".")
   for terminal in self.qualword:elems()
   do if first_time
      then
         first_time =  false
      else
         retval:append_string(delimiter)
      end
      retval:append_string(terminal)
   end
   return retval
end

function Qualifier:__clone()
   local retval =  Qualifier:__new()
   retval.qualword =  self.qualword:__clone()
   return retval
end

function Qualifier:__eq(other)
   return self.qualword == other.qualword
end

function Qualifier:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.mod.Qualifier"))
   indentation:insert_newline()
   local is_last_elem_multiple_line =  true
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =  deeper_indentation:insert(self:get_name())
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Qualifier
