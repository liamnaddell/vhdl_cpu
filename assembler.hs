#!/usr/bin/env runhaskell

import Data.Word
import Data.Bits
import Control.Applicative
import Data.String
import Data.Maybe
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Builder as BLB
--cabal install --lib split
import Data.List.Split (splitOn)
import System.Environment

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

txtToOp :: String -> Opcode
txtToOp "add" = OpAnd
txtToOp "mul" = OpMul
txtToOp "and" = OpAnd
txtToOp "xor" = OpXor

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

assemble :: Instruction -> Maybe Word8
assemble i = foldr (liftA2 (+)) (Just 0) [opc, dst, src, imm]
  where opc = return $ opToBin $ opcode i
        shiftL' x = (liftA2 (flip shiftL)) (Just x)
        dst = shiftL' 2 (ckReg (regDst i))
        src = shiftL' 4 (ckReg (regSrc i))
        imm = shiftL' 6 (ckImm (immVal i))

build :: Program -> Maybe BL.ByteString
build (Program ins) 
  | (length m_list) == (length good) = Just (BL.pack good)
  | otherwise = Nothing
  where m_list = map assemble ins
        good = catMaybes m_list

parseLine :: String -> Instruction
parseLine line = instr op rd rs imm
  where tokens = splitOn " " line
        op = txtToOp $ tokens !! 0
        rd = read $ tokens !! 1
        rs = read $ tokens !! 2
        imm = read $ tokens !! 3

parse :: String -> Program
parse program = Program $ map parseLine ls
  where ls = lines program


main = do
  --let i1 = instr OpAdd 0 0 2
  --let i2 = instr OpMul 1 0 2
  --let i3 = instr OpAnd 2 1 1
  --let i4 = instr OpXor 3 2 3

  args <- getArgs
  programText <- readFile (args !! 0)
  let program' = parse programText
  let program = fromJust $ build $ program'
  BLB.writeFile "input.bin" (BLB.lazyByteString program)
  return ()


