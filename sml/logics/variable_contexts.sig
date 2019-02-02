use "collections/pointer_type.sig";
use "logics/variables.sig";
use "logics/variables_depending_thing.sig";

signature VariableContexts =
   sig
      structure PointerType: PointerType
      structure Variables: Variables
      structure VariableContext: VariablesDependingThing
      sharing VariableContext.Variables =  Variables
      sharing PointerType.BaseType =  Variables

      type AlphaConverter

      val alpha_convert:                 (Variables.Base -> Variables.Base) -> VariableContext.T -> AlphaConverter
      val get_variable_context:          AlphaConverter -> VariableContext.T
      val apply_alpha_converter:         AlphaConverter -> Variables.T -> Variables.T

      val alpha_zip_all:                 AlphaConverter * AlphaConverter -> (Variables.T * Variables.T -> bool) -> bool
      val alpha_map:                     (Variables.Base -> Variables.Base) -> AlphaConverter -> AlphaConverter
   end;
