use "logics/literals/in.sig";
use "logics/variables.sig";

signature Literals =
   sig
      structure LiteralsIn: LiteralsIn
      structure Variables: Variables
      structure Construction:
         sig
            type T
         end
      structure Multi:
         sig
            structure Variables:  Variables
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
            val is_empty:     T -> bool
            val vmap:         (Variables.T -> Variables.T) -> T -> T
         end
      structure Single:
         sig
            structure Variables:  Variables
            type T
            val equate:       T * T -> bool
            val eq:           T * T -> bool
            val vmap:         (Variables.T -> Variables.T) -> T -> T
         end
      structure Clause:
         sig
            structure Variables:  Variables
            type T =  { antecedent: Multi.T, conclusion: Single.T }
            val eq:           T * T -> bool
            val vmap:         (Variables.T -> Variables.T) -> T -> T
         end
      sharing Multi.Variables = Variables
      sharing Single.Variables = Variables
      sharing Clause.Variables = Variables

      val resolve:    Clause.T -> LiteralsIn.PT.PointerType.T -> Multi.T -> Multi.T Option.option

      val replace:    Single.T * Multi.T -> Multi.T -> Multi.T
      val transition: (Single.T * 'b -> 'b Option.option) -> Multi.T -> 'b -> 'b

  end;
