#!/usr/bin/env runhaskell

import Data.Word
import Data.Bits
import Control.Applicative
import Data.String
import Data.Maybe

w2c :: Word8 -> Char
w2c = toEnum . fromEnum

i2w :: Int -> Word8
i2w = toEnum . fromEnum

data Opcode = OpAdd | OpMul | OpAnd | OpXor

opToBin :: Opcode -> Word8
opToBin OpAdd = 0
opToBin OpMul = 1
opToBin OpAnd = 2
opToBin OpXor = 3

newtype Register = Register Word8
newtype Immediate = Immediate Word8

--checks word8 can fit in 2 bits
ckImm :: Immediate -> Maybe Word8
ckImm (Immediate w)
  | w < 4 = Just w
  | otherwise = Nothing

ckReg :: Register -> Maybe Word8
ckReg (Register r)
  | r < 4 = Just r
  | otherwise = Nothing


data Instruction = Instruction 
  { opcode :: Opcode
  , regDst :: Register
  , regSrc :: Register
  , immVal    :: Immediate
  }

instr :: Opcode -> Int -> Int -> Int -> Instruction
instr op rd rs im = Instruction { opcode=op
                                , regDst=(Register (i2w rd))
                                , regSrc = (Register (i2w rs))
                                , immVal = (Immediate (i2w im))
                                }

newtype Program = Program [Instruction]




class Assembly a where
  assemble :: a -> Maybe Word8 
  --disassemble :: Word8 -> Maybe a

instance Assembly Instruction where
  assemble i = foldr (liftA2 (+)) (Just 0) [opc, dst, src, imm]
    where opc = return $ opToBin (opcode i)
          shiftR' x = (liftA2 (flip shiftR)) (Just x)
          dst = shiftR' 2 (ckReg (regDst i))
          src = shiftR' 4 (ckReg (regSrc i))
          imm = shiftR' 6 (ckImm (immVal i))
  --disassemble i = 

build :: Program -> Maybe ([Word8])
build (Program ins) 
  | (length m_list) == (length good) = good
  | otherwise = Nothing
  where m_list = map assemble ins
        good = return $ catMaybes m_list



main = do
  let i1 = instr OpAdd 0 0 1
  let i2 = instr OpMul 1 0 2
  let i3 = instr OpAnd 2 1 1
  let i4 = instr OpXor 3 2 3
  let program' = build $ Program [i1,i2,i3,i4]
  let program = fromJust program'
  writeFile "input.bin" (map w2c program)
  return ()


