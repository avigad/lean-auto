import Lean

open Lean

namespace EvalAuto

/--
  Suppose `env₂` is the environment after running several non-import
  commands starting from `env₁`, then `Environment.newLocalConstants env₁ env₂`
  returns the new `ConstantInfo`s added by these commands
-/
def Environment.newLocalConstants (env₁ env₂ : Environment) :=
  env₂.constants.map₂.toArray.filterMap (fun (name, ci) =>
    if !env₁.constants.map₂.contains name then .some ci else .none)

def mathlibModules : CoreM (Array Name) := do
  let u := (← getEnv).header.moduleNames
  return u.filter (fun name => name.components[0]? == .some `Mathlib)

/-- Pick `n` elements from array `xs`. Elements may duplicate -/
def Array.randPick {α} (xs : Array α) (n : Nat) : IO (Array α) := do
  let mut ret := #[]
  for _ in [0:n] do
    let rd ← IO.rand 0 (xs.size - 1)
    if h : rd < xs.size then
      ret := ret.push (xs[rd]'h)
  return ret

end EvalAuto
