import Mathlib
set_option autoImplicit false
set_option diagnostics true

open Classical

def completeTransitive {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    (∀ f g : States → Consequences, notBetterThan f g ∨ notBetterThan g f)
    ∧ (∀ f g h : States → Consequences, notBetterThan f g → notBetterThan g h → notBetterThan f h)

def sureThingPrinciple {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    ∀ event : Set States, ∀ f f' g : States → Consequences,
      notBetterThan (fun s : States => if s ∈ event then f s else g s) (fun s : States => if s ∈ event then f' s else g s) →
        ∀ g' : States → Consequences, notBetterThan (fun s : States => if s ∈ event then f s else g' s) (fun s : States => if s ∈ event then f' s else g' s)
