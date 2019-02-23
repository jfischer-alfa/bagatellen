use "collections/dictset.fun";
use "collections/pointered_type.sig";
use "collections/dict_map.fun";
use "logics/literals.sig";
use "logics/variables.sig";
use "logics/variable_contexts.sig";

functor VariableContexts(X:
   sig
      structure Var: Variables
      structure PT: PointeredType
      sharing PT.BaseType = Var
   end) =
   struct
      structure DictSet =  DictSet(X.Var)
      structure Dicts =  DictSet.Dicts

      structure Variables =  X.Var
      structure PointeredType =  X.PT

      structure VariableContext =
         struct
            structure Variables =  Variables
            type T =  X.PT.ContainerType.T
            val eq =  X.PT.all_zip (X.Var.eq)
            val vmap =  X.PT.map
            val filter_bound_vars =  X.PT.filter (Variables.is_bound)
            val filter_unbound_vars =  X.PT.filter (not o Variables.is_bound)
         end;

      structure DictMap =  DictMap(
         struct
            structure DS = DictSet
            structure End = Variables
         end )

      type AlphaConverter = { ctxt: VariableContext.T, alpha: Variables.T Dicts.dict }

      val get_variable_context: AlphaConverter -> VariableContext.T =  #ctxt

      fun alpha_convert (vc: VariableContext.T)
        = let
             val var_dict
                =  X.PT.transition
                      (fn (v, d) => Option.SOME (Dicts.set(v, (Variables.copy v), d)))
                      vc
                      Dicts.empty
             val dict_map =  DictMap.apply (DictMap.get_map var_dict)
             val ctxt_map =  X.PT.map dict_map
             val vc' =  ctxt_map vc
          in
             { ctxt = vc', alpha = var_dict }: AlphaConverter
          end

      exception OutOfContext
      fun apply_alpha_converter (alpha: AlphaConverter) x
        = case(Dicts.deref(x, #alpha alpha)) of
             Option.NONE => raise OutOfContext
          |  Option.SOME v => v

      fun alpha_zip_all ((alpha: AlphaConverter), (beta: AlphaConverter)) P
        = Dicts.all P (Dicts.zip ((#alpha alpha), (#alpha beta)))

   end;
