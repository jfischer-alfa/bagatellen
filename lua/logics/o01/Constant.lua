local Type =  require "base.type.aux.Type"

local Constant =  Type:__new()

package.loaded["logics.ql.Constant"] =  Constant

function Constant:new(symbol, qualifier)
   local retval =  self:__new()
   retval.symbol =  symbol
   retval.qualifier =  qualifier
   return retval
end

function Constant:new_ql_instance_added_qualifier(qualifier)
   local new_qual =  self:get_qualifier():__clone()
   new_qual:append_qualifier(qualifier)
   return self:new_ql_instance(new_qual)
end

function Constant:new_ql_instance(qualifier)
   return self.__index:new(self:get_symbol(), qualifier)
end

function Constant:get_symbol()
   return self.symbol
end

function Constant:get_qualifier()
   return self.qualifier
end

function Constant:get_variable()
end

function Constant:get_object_variable()
end

function Constant:get_constant()
   return self
end

function Constant:append_qualifier(qualifier)
   self.qualifier:append_qualifier(qualifier)
end

function Constant:assign_object_variable_to_meta_variable(variable)
   return true
end

function Constant:be_a_constant(constant)
   if self == constant
   then
      return self
   end
end

function Constant:equate(other)
   local retval =  false
   local other_constant =  other:be_a_constant(self)
   if other_constant
   then
      local this_qual =  self:get_qualifier()
      local rhs_qual =  other:get_lhs_chopped(this_qual)
      if rhs_qual
      then
         this_qual:append_qualifier(rhs_qual)
         retval =  true
      end
   end
   return retval
end

function Constant:devar(var_assgnm)
   local dev_qual =  self:get_qualifier():devar(var_assgnm)
   return self.__index:new(self:get_symbol(), dev_qual)
end

function Constant:__eq(other)
   local retval =  false
   local other_constant =  other:get_constant()
   if other_constant
   then
      retval =
            self:get_symbol() == other:get_symbol()
        and self:get_qualifier() == other:get_qualifier()
   end
   return retval
end


-- --- refactoring.

function Constant:get_rhs_chopped_copy(qualifier)
   local new_lhs, new_rhs
      =  self:get_qualifier():get_rhs_chopped_copy(qualifier)
   if new_lhs
   then
      return
            self.__index:new(
                  self:get_symbol()
               ,  new_lhs )
         ,  new_rhs
   end
end

function Constant:append_qualifier(qualifier)
   self:get_qualifier():append_qualifier(qualifier)
end

return Constant