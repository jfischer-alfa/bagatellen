use "logics/variables.sig";

signature VariableContexts =
   sig
      structure Variables: Variables

      type T
      type VariableContext
      type AlphaConverter

      val alpha_convert:         VariableContext -> AlphaConverter
      val get_variable_context:  AlphaConverter -> VariableContext
      val apply_alpha_converter: AlphaConverter -> T Variables.Variable -> T Variables.Variable Option.option

   end;
