use "collections/combi_type.sig";
use "collections/naming_pointered_type_extension.sig";
use "collections/pointered_type.sig";
use "general/sum_type.sig";
use "collections/unit_pointered_type_extension.sig";

functor CombiPointeredType(X:
   sig
      structure NPT: NamingPointeredTypeExtension
      structure UPT: UnitPointeredTypeExtension
      structure PointerType: CombiType
      structure BaseType: SumType
      sharing BaseType.FstType =  NPT.PointeredType.BaseType
      sharing BaseType.SndType =  UPT.PointeredType.BaseType
   end ): PointeredType =
   struct
      structure BaseType =  X.BaseType
      structure ContainerType =
         struct
            type T =  X.NPT.PointeredType.ContainerType.T * X.UPT.PointeredType.ContainerType.T
         end
      structure PointerType =  X.PointerType

      fun select (pointer, (m_n, m_u))
         =  PointerType.traverse (
                  (fn s => Option.map BaseType.fst_inj (X.NPT.PointeredType.select(X.NPT.StringType.point s, m_n)))
               ,  (fn () => Option.map BaseType.snd_inj (X.UPT.PointeredType.select(X.UPT.UnitType.point, m_u))) )
               pointer

      exception NonFunctorial
      fun non_functorial_a x
         =  BaseType.traverse ((fn x => x), (fn y => raise NonFunctorial)) x
      fun non_functorial_b y
         =  BaseType.traverse ((fn x => raise NonFunctorial), (fn y => y)) y
      fun map phi (m_n, m_u)
         =  let
               val m'_n =  X.NPT.PointeredType.map (fn (x) => non_functorial_a(phi(BaseType.fst_inj x))) m_n
               val m'_u =  X.UPT.PointeredType.map (fn (x) => non_functorial_b(phi(BaseType.snd_inj x))) m_u
            in
               (m'_n, m'_u)
            end

      val empty =  (X.NPT.PointeredType.empty, X.UPT.PointeredType.empty)

      fun is_empty (m_n, m_u) =  (X.NPT.PointeredType.is_empty m_n) andalso (X.UPT.PointeredType.is_empty m_u)

      fun all phi (m_n, m_u)
         =   (X.NPT.PointeredType.all (fn (x) => phi(BaseType.fst_inj x)) m_n)
            andalso
             (X.UPT.PointeredType.all (fn (x) => phi(BaseType.snd_inj x)) m_u)

      fun all_zip phi ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =   (X.NPT.PointeredType.all_zip (fn (x, y) => phi(BaseType.fst_inj x, BaseType.fst_inj y)) (m_n_1, m_n_2))
            andalso
             (X.UPT.PointeredType.all_zip (fn (x, y) => phi(BaseType.snd_inj x, BaseType.snd_inj y)) (m_u_1, m_u_2))

      fun fe b
         =  BaseType.traverse ((fn x => (X.NPT.PointeredType.fe x, X.UPT.PointeredType.empty)), (fn x => (X.NPT.PointeredType.empty, X.UPT.PointeredType.fe x))) b

      fun fop phi (m_n, m_u)
         =  let
               fun fn_a phi x =  case (phi(BaseType.fst_inj x)) of
                  (a, b) => a
               fun fn_b phi y =  case (phi(BaseType.snd_inj y)) of
                  (a, b) => b
               val m_n_1 =  X.NPT.PointeredType.fop (fn_a phi) m_n
               val m_u_1 =  X.UPT.PointeredType.fop (fn_b phi) m_u
            in (m_n_1, m_u_1)
            end

      fun is_in (b, (m_n, m_u))
         =  BaseType.traverse ((fn x => X.NPT.PointeredType.is_in(x, m_n)), (fn x => X.UPT.PointeredType.is_in(x, m_u))) b

      fun subeq ((m_n_1, m_u_1), (m_n_2, m_u_2))
         =  X.NPT.PointeredType.subeq(m_n_1, m_n_2) andalso X.UPT.PointeredType.subeq(m_u_1, m_u_2)

      fun filter phi (m_n, m_u)
         =  let
               val m_n_1 =  X.NPT.PointeredType.filter (fn x => phi(BaseType.fst_inj x)) m_n
               val m_u_1 =  X.UPT.PointeredType.filter (fn x => phi(BaseType.snd_inj x)) m_u
            in (m_n_1, m_u_1)
            end

      fun transition phi (m_n, m_u) b
         =  let
               val b_1 =  X.NPT.PointeredType.transition (fn (x, b') => phi(BaseType.fst_inj x, b')) m_n b
               val b_2 =  X.UPT.PointeredType.transition (fn (x, b') => phi(BaseType.snd_inj x, b')) m_u b_1
            in
               b_2
            end

   end;
