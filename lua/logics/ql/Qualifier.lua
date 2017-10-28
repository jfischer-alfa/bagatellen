local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()

package.loaded["logics.ql.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"

function Qualifier:id_factory(sort)
   local retval =  self:__new()
   retval.qualword =  List:empty_list_factory()
   retval.d0 =  sort
   retval.d1 =  sort
   return retval
end

function Qualifier:is_id()
   return self.qualword:is_empty()
end

function Qualifier:get_d0()
   return self.d0
end

function Qualifier:get_d1()
   return self.d1
end

function Qualifier:append_terminal_symbol(symbol, d1)
   self.qualword:append(symbol)
   self.d1 =  d1
end

function Qualifier:append_qualifier(other)
   self.qualword:append_list(other.qualword)
   self.d1 =  other:get_d1()
end

function Qualifier:get_lhs_chopped_copy(qualifier)
   local retval =  self:__clone()
   if retval.qualword:drop_initial_seq(qualifier.qualword)
   then
      return retval
   end
end

function Qualifier:get_rhs_chopped_copy(qualifier)
   local retval =  self:__clone()
   if retval.qualword:drop_final_seq(qualifier.qualword)
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
   indentation:insert(String:string_factory("(logics::ql::Qualifier "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Qualifier"))
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
