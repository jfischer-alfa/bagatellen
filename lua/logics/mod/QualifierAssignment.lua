local Type =  require "base.type.aux.Type"

local QualifierAssignment =  Type:__new()

package.loaded["logics.mod.QualifierAssignment"] =  QualifierAssignment
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function QualifierAssignment:new(qualifier, d0, d1)
   local retval =  self:__new()
   retval.qualifier =  qualifier
   retval.d0 =  d0
   retval.d1 =  d1
   return retval
end

function QualifierAssignment:get_qualifier()
   return self.qualifier
end

function QualifierAssignment:get_d0()
   return self.d0
end

function QualifierAssignment:get_d1()
   return self.d1
end

function QualifierAssignment:get_chopped_copy(qualifier)
   local ret_qual =  self:get_qualifier():get_chopped_copy(qualifier)
   if ret_qual
   then
      return QualifierAssignment:new(
            ret_qual
         ,  qualifier:get_d1()
         ,  self:get_d1() )
   end
end

function QualifierAssignment:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::mod::QualifierAssignment "))
   self:get_qualifier():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(": "))
   self:get_d1():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function QualifierAssignment:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::mod::QualifierAssignment"))
   indentation:insert_newline()
   local is_last_elem_multiple_line =  true
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =  self:get_qualifier():__diagnose_complex(deeper_indentation)
      deeper_indentation:insert(String:string_factory(": "))
      self:get_d1():__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return QualifierAssignment