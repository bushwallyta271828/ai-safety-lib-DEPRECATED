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

def conditionalNotBetterThan {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  (event : Set States)
  (f : States → Consequences)
  (g : States → Consequences)
  : Prop :=
    ∀ h : States → Consequences, notBetterThan (event.piecewise f h) (event.piecewise g h)

def sureThingPrinciple {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    ∀ event : Set States, ∀ f g h : States → Consequences,
      notBetterThan (event.piecewise f h) (event.piecewise g h) →
        (conditionalNotBetterThan notBetterThan event) f g

def null {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  (event : Set States)
  : Prop :=
    ∀ f g : States → Consequences,
      (conditionalNotBetterThan notBetterThan event) f g

def constantComparison {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    ∀ x y : Consequences, ∀ event : Set States, ¬(null notBetterThan event) →
      notBetterThan (fun _ => x) (fun _ => y) ↔ (conditionalNotBetterThan notBetterThan event) (fun _ => x) (fun _ => y)

def constantEventComparison {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    ∀ A B : Set States, ∀ v w x y : Consequences,
      ¬(notBetterThan (fun _ => v) (fun _ => w))
      → ¬(notBetterThan (fun _ => x) (fun _ => y))
      → (notBetterThan (fun s => if s ∈ B then v else w) (fun s => if s ∈ A then v else w))
      → (notBetterThan (fun s => if s ∈ B then x else y) (fun s => if s ∈ A then x else y))

def opinionated {States Consequences : Type}
  [Nonempty States] [Nonempty Consequences]
  (notBetterThan : (States → Consequences) → (States → Consequences) → Prop)
  : Prop :=
    ∃ x y : Consequences, ¬(notBetterThan (fun _ => x) (fun _ => y))
