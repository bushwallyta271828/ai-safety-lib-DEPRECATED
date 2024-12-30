import Mathlib
set_option autoImplicit false

def P1 := sorry

def sureThingPrinciple {States Consequences : Type}
  [nonempty States] [nonempty Consequences]
  (weaklyPrefer : (States → Consequences) → (States → Consequences) → Prop)
  : Prop := sorry
