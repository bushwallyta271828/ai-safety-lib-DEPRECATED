import Mathlib
set_option autoImplicit false
-- Huge credit to [name redacted until I get permission to mention]!


inductive History (Actions : Type) where
  | finite : List Actions → History Actions
  | infinite : (ℕ → Actions) → History Actions

def History.length {Actions : Type} : History Actions → ENat
  | History.finite l => l.length
  | History.infinite _ => ⊤

def History.truncate {Actions : Type} (history : History Actions) (length : ENat) : History Actions := match history, length with
  | h, ⊤ => h
  | History.finite l, some n => History.finite (l.take n)
  | History.infinite f, some n =>
    History.finite (List.ofFn fun i : Fin n ↦ f i)

def History.isPrefixOf {Actions : Type} (firstHistory : History Actions) (secondHistory : History Actions) : Prop :=
  truncate secondHistory firstHistory.length = firstHistory

--theorem uniquePrefix {Actions : Type} (h1 h2 : History Actions) : h1.isPrefixOf h2 → h1 = h2.truncate h1.length := by
--  unfold History.isPrefixOf
--  rw [eq_comm]
--  simp

-- def History.isTerminal {Actions : Type} (h : History Actions) (isValid : History Actions → Prop) :

structure ExtensiveGame where
  Player : Type
  [finitePlayers : Fintype Player]
  Actions : Type
  isValid : History Actions → Prop
  (emptyHistory : isValid (History.finite []))
  (prefixes : ∀ h1 h2 : History Actions, h1.isPrefixOf h2 → isValid h2 → isValid h1)
  (infiniteClosure : ∀ h : History Actions, (∀ n : ℕ, isValid (h.truncate n)) → isValid h)
  --(infiniteClosure : ∀ h : History Actions, (∀ h' : History Actions, h'.length ≠ ⊤ → h'.isPrefixOf h → isValid h') → isValid h)

  isTerminal : History Actions → Prop
  -- (terminalDef : ∀ h : History Actions, isValid h → (isTerminal h ↔ h.length = ⊤ ∨ ∀ a : Actions,
  --(terminalDef : ∀ h : History Actions, isTerminal h ↔ ∀ h2 : History Actions, isValid h2 → h.isPrefixOf h2 → h = h2)
  available : History Actions → Set Actions
  (availableFinite : ∀ l : List Actions, available (History.finite l) = {a : Actions | isValid (History.finite (l.concat a))})
  (availableInfinite : ∀ f : ℕ → Actions, available (History.infinite f) = ∅)
  (terminalDef : ∀ h : History Actions, isTerminal h ↔ available h = ∅)

  player : History Actions → Option Player
  natureSigmaAlgebra : (h : History Actions) → MeasurableSpace (available h)
  natureProbMeasure : (h : History Actions) → MeasureTheory.Measure (available h)
  (isProbMeasure : ∀ h : History Actions, MeasureTheory.IsProbabilityMeasure (natureProbMeasure h))

  --This definition is still incomplete!
