package org.pubmath.factory

import org.pubmath.Trit

abstract class Gate

case class ExternalGate(var in: Wire, var out: Wire) extends Gate {
  def this() = this (null, null)
}

case class InternalGate(var leftIn: Wire, var rightIn: Wire, var leftOut: Wire, var rightOut: Wire) extends Gate {
  def this() = this (null, null, null, null)
}

class Factory(var gateType: Array[Pair[Trit, Trit]], factorySource: String) {
  val lines = factorySource.split("""(:|,)\s*\n*""");
  val count = lines.length - 2
  val internalGates = (0 to (count - 1)).map(n => new InternalGate()).toList

  private val SimpleGateRegex = """^(\d+)(\w)$""".r
  private val SimpleGateRegex(inNum, inDir) = lines(0).trim
  private var _outNum = 0
  private var _outDir: String = null

  val extGate: ExternalGate = new ExternalGate(null, new ForwardWire)
  for (i <- 0 to (count - 1)) {
    // num<>char<>num<>char<>0<>#<>num<>char<>num<>char
    val GateRegex = """^(\d*)(\w)(\d*)(\w)0#(\d*)(\w)(\d*)(\w)$""".r
    val GateRegex(leftInNum, leftInDir, rightInNum, rightInDir, leftOutNum, leftOutDir, rightOutNum, rightOutDir) = lines(i + 1).trim

    // quite enterprisey!

    if (leftInDir == "X") {
      if (inNum.toInt != i || inDir != "L") throw new WrongWiringException
      internalGates(i).leftIn = extGate.out
    } else if (leftInNum.toInt < i) {
      val gate = internalGates(leftInNum.toInt)
      internalGates(i).leftIn = if (leftInDir == "L") gate.leftOut else if (leftInDir == "R") gate.rightOut else throw new WrongSyntaxException
    } else {
      internalGates(i).leftIn = new BackwardWire
    }

    if (rightInDir == "X") {
      if (inNum.toInt != i || inDir != "R") throw new WrongWiringException
      internalGates(i).rightIn = extGate.out
    } else if (rightInNum.toInt < i) {
      val gate = internalGates(rightInNum.toInt)
      internalGates(i).rightIn = if (rightInDir == "L") gate.leftOut else if (rightInDir == "R") gate.rightOut else throw new WrongSyntaxException
    } else {
      internalGates(i).rightIn = new BackwardWire
    }

    if (leftOutDir == "X") {
      _outNum = i
      _outDir = "L"
      internalGates(i).leftOut = new ForwardWire
    } else if (leftOutNum.toInt <= i) {
      val gate = internalGates(leftOutNum.toInt)
      internalGates(i).leftOut = if (leftOutDir == "L") gate.leftIn else if (leftOutDir == "R") gate.rightIn else throw new WrongSyntaxException
    } else {
      internalGates(i).leftOut = new ForwardWire
    }

    if (rightOutDir == "X") {
      _outNum = i
      _outDir = "R"
      internalGates(i).rightOut = new ForwardWire
    } else if (rightOutNum.toInt <= i) {
      val gate = internalGates(rightOutNum.toInt)
      internalGates(i).rightOut = if (rightOutDir == "L") gate.leftIn else if (rightOutDir == "R") gate.rightIn else throw new WrongSyntaxException
    } else {
      internalGates(i).rightOut = new ForwardWire
    }
  }

  val SimpleGateRegex(outNum, outDir) = lines(lines.length - 1).trim
  if (outNum.toInt != _outNum || outDir != _outDir) throw new WrongWiringException else {
    val gate = internalGates(_outNum)
    extGate.in = if (_outDir == "L") gate.leftOut else if (_outDir == "R") gate.rightOut else throw new WrongSyntaxException
  }


  def evalGate(left: Trit, right: Trit) = gateType(left.value * 3 + right.value)

  def step(input: Trit): Trit = {
    extGate.out.put(input)
    internalGates.map(g => {
      val result = evalGate(g.leftIn.value, g.rightIn.value)
      g.leftOut.put(result._1)
      g.rightOut.put(result._2)
    })
    extGate.in.value
  }

  def run(inputSequence: List[Trit]): List[Trit] = {
    inputSequence.map(step(_))
  }

}

abstract class Wire {
  var value: Trit = Trit(0);
  def put(value: Trit)
}

class ForwardWire extends Wire {
  override def put(value: Trit) = {
    this.value = value
  }
}

class BackwardWire extends Wire {
  var nextValue: Trit = Trit(0);

  override def put(value: Trit) = {
    this.nextValue = value
    this.value = nextValue
  }
}

class WrongWiringException extends RuntimeException
class WrongSyntaxException extends RuntimeException