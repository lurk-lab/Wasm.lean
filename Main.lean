import Wasm
import Wasm.Wast.Expr
import Wasm.Wast.Name
import Wasm.Wast.Num

open  Wasm.Wast.Expr
open  Wasm.Wast.Name
open  Wasm.Wast.Num
open  Num.Digit
open  Num.Nat

def sameName (_n₁ : Option $ Name x) (_n₂ : Option $ Name x) : Option (Name "kek") := mkName "kek"
#eval sameName (mkName "lol") (mkName "lol")
-- #eval sameName (mkName "lol") (mkName "kek")

def main : IO Unit := do

  IO.println "(9) WASM demo coming soon."

  IO.println "Let's count the dots (should be two for constructing and zero for extracting Nat with .g)!"
  let x23 : Xf 23 := {}
  let x23' : Xf 23 := {}
  let x55 : Xf 55 := {}
  IO.println s!"So... We actually parsed only twice, but we've got three values: {x23.g x23.y}, {x23'.g x23.y}, {x55.g x55.y}"
  IO.println s!"Over and over again: {x23.g x23.y}, {x23'.g x23.y}, {x55.g x55.y}"
  IO.println s!"And again: {x23.g x23.y}, {x23'.g x23.y}, {x55.g x55.y}"

  IO.println "Also, Lean is known to be a technology from the future:"
  let xx23 : X 23 := {}
  IO.println s!"Such reduction: {xx23.g xx23.y}"
  IO.println s!"Much techmology: {xx23.g xx23.y}"
  IO.println s!"Wow: {xx23.g xx23.y}"

  IO.println s!"Digits also parse rather efficiently!"
  let d11 : Digit 'b' := {doesParse := Exists.intro {} $ by trivial}
  IO.println s!"{(d11 : Nat)} == 11" -- We can 'Coe'rce!

  IO.println s!"We have numbers!"
  let n22 : Option $ Nat' "22" := mkNat' "22"
  let nHd : Option $ Nat' "Herder" := mkNat' "Herder"

  match n22 with
  | .some sn22 => IO.println s!"{(sn22 : Nat)} == 22"
  | .none => IO.println "/_!_\\ BUG IN Nat' \"22\" clause /_!_\\"

  match nHd with
  | .some _ => IO.println "/_!_\\ BUG IN Nat' \"Herder\" clause /_!_\\"
  | .none => IO.println s!":thumbs_up:"

  pure ()
