import Wasm.Wast.BitSize
import Wasm.Wast.Num

open Wasm.Wast.Num.Num.Int
open Wasm.Wast.Num.Num.Float
open Wasm.Wast.Num.Uni

namespace Wasm.Wast.AST
section AST


namespace Type'

inductive Type' where
  | f : BitSize → Type'
  | i : BitSize → Type'
  -- | v : BitSizeSIMD → Type'
  deriving BEq

instance : ToString Type' where
  toString x := match x with
  | .f y => "(Type'.f " ++ toString y ++ ")"
  | .i y => "(Type'.i " ++ toString y ++ ")"
  -- | .v y => "(Type'.v " ++ toString y ++ ")"

def numUniType : NumUniT → Type'
  | .i x => .i x.bs
  | .f x => .f x.bs

end Type'
open Type'


namespace Local

structure Local where
  index : Nat
  name : Option String
  type : Type' -- TODO: We need to pack lists with different related types'. For that we need something cooler than List, but since we're just coding now, we'll do it later.
  deriving BEq

instance : ToString Local where
  toString x := s!"(Local.mk {x.index} {x.name} {x.type})"

end Local
open Local

namespace LabelIndex

structure LabelIndex where
  li : Nat
  deriving Repr, DecidableEq

instance : Coe Nat LabelIndex where
  coe n := ⟨n⟩

instance : Coe LabelIndex Nat where
  coe | ⟨n⟩ => n

instance : ToString LabelIndex where
  toString | ⟨n⟩ => s!"(LabelIndex {n})"

end LabelIndex
open LabelIndex


namespace Get

inductive Get (x : Type') where
| from_stack
| by_name : Local → Get x
| by_index : Local → Get x

instance : ToString (Get α) where
  toString x := "(" ++ (
    match x with
    | .from_stack => "Get.from_stack"
    | .by_name n => "Get.by_name " ++ toString n
    | .by_index i => "Get.by_index " ++ toString i
  ) ++ " : Get " ++ toString α ++ ")"

end Get
open Get


/- TODO: Instructions are rigid WAT objects. If we choose to only support
S-Expressions at this point, we don't need this concept. -/
namespace Instruction
end Instruction


namespace Operation

mutual
  -- Sadge
  inductive Get' where
  | from_stack
  | from_operation : Operation → Get'
  | by_name : Local → Get'
  | by_index : Local → Get'

-- TODO: add support for function type indexes for blocktypes
-- TODO: branching ops can produce and consume operands themselves,
-- e.g. `(br 0 (i32.const 2))`. Right now we don't support it, but should we?
-- TODO: replace `NumUniT` with something supporting `ConstVec` when implemented
-- TODO: generalise Consts the same way Get is generalised so that `i32.const`
-- can't be populated with `ConstFloat`!
  inductive Operation where
  | nop
  | const : Type' → NumUniT → Operation
  | add : Type' → Get' → Get' → Operation
  | block : List Type' → List Operation → Operation
  | loop : List Type' → List Operation → Operation
  | if : List Type' → List Operation → List Operation → Operation
  | br : LabelIndex → Operation
  | br_if : LabelIndex → Operation
end

mutual
  private partial def getToString (x : Get') : String :=
    "(Get'" ++ (
      match x with
      | .from_stack => ".from_stack"
      | .from_operation o => s!".from_operation {operationToString o}"
      | .by_name n => ".by_name " ++ toString n
      | .by_index i => ".by_index " ++ toString i
    ) ++ ")"

  private partial def operationToString : Operation → String
    | .nop => "(Operation.nop)"
    | .const t n => s!"(Operation.const {t} {n})"
    | .add t g1 g2 => s!"(Operation.add {t} {getToString g1} {getToString g2})"
    | .block ts is => s!"(Operation.block {ts} {is.map operationToString})"
    | .loop ts is => s!"(Operation.loop {ts} {is.map operationToString})"
    | .if ts thens elses => s!"(Operation.if {ts} {thens.map operationToString} {elses.map operationToString})"
    | .br li => s!"(Operation.br {li})"
    | .br_if li => s!"(Operation.br_if {li})"

end

instance : ToString Get' where
  toString := getToString

instance : ToString Operation where
  toString := operationToString

end Operation
open Operation


namespace Func

structure Func where
  name : Option String
  export_ : Option String
  -- TODO: Heterogenous lists so that we can promote Type'?
  params : List Local
  results : List Type'
  locals : List Local
  ops : List Operation

instance : ToString Func where
  toString x := s!"(Func.mk {x.name} {x.export_} {x.params} {x.results} {x.locals} {x.ops})"

end Func
open Func


namespace Module

structure Module where
  name : Option String
  func : List Func

instance : ToString Module where
  toString x := s!"(Module.mk {x.name} {x.func})"

end Module


end AST
end Wasm.Wast.AST
