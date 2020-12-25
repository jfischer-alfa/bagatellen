use "logics/literal_equate.sig";
use "logics/multi_literal.sig";

signature Literal =
   sig
      structure Single: LiteralEquate
      structure Multi: MultiLiteral

      type variableMap_t
      type variableContext_t
      val copy: variableMap_t
      val context_alpha_transform: variableMap_t -> variableContext_t -> variableContext_t
      val single_alpha_transform: variableMap_t -> Single.T -> Single.T
      val multi_alpha_transform: variableMap_t -> Multi.T -> Multi.T

   end
