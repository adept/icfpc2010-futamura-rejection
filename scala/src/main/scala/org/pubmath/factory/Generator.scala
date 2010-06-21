package main.scala.org.pubmath.factory

import org.pubmath.Trit
import org.pubmath.factory.{ForwardWire, InternalGate}
import collection.immutable.List
//   http://sync.in/CgHccQAR6j

// pubmath.factory.Generator.fromString("100")

object Generator {
  def fromString(data: String) = fromList(trits(data))

  def fromList(data: Iterable[Trit]) = {

    val layersRequired = data.zipWithIndex.
            map(z => if (z._2 % 2 == 0) output0(z._1) else output1(z._1))

    var state = initial

    val wires = layersRequired.map(target => {
      val wire = findWiring(state, target)
      state = target
      wire
    })

    wires
  }

  def toGates(wiring: List[Array[Int]]) = {

    // 3 pairs of loopback
    val loopBack = (1 to 3).map(_ => Pair(new ForwardWire(), new ForwardWire()))

    // 3 gates in a slice
    val head = loopBack.map(p => new InternalGate(p._1, p._2, new ForwardWire(), new ForwardWire())).toArray

    var state = head
    val body = wiring.map(wiresOrder => {

      // 6 incoming wires
      val wiresIn = state.flatMap(gate => List(gate.leftOut, gate.rightOut))
      val wiresInOrdered = wiresOrder map wiresIn // I love Scala!

      // new 6 wires
      val wiresOut = (1 to 6).map(_ => new ForwardWire())

      val i = wiresInOrdered
      val o = wiresOut

      state = Array(
        new InternalGate(i(0), i(1), o(0), o(1)),
        new InternalGate(i(2), i(3), o(2), o(3)),
        new InternalGate(i(4), i(5), o(4), o(5))
        )

      state
    })

    val last = body.last
    // toDo finish cycle - connect with head

    head :: body
  }


  def findWiring(source: List[Trit], target: List[Trit]): List[Int] = {
    val used = new scala.collection.mutable.ArrayBuffer[Int]

    target.map(t => {
      val candidates = source.
              zipWithIndex.
              filter(z => z._1 == t).
              filterNot(z => used.contains(z._2))

      val wire = candidates.head._2
      used.append(wire)
      wire
    })
  }

  implicit def toTrit(v: Int): Trit = Trit(v)

  // we may replace it with Map for performance
  def output0(data: Trit) = data match {
    case Trit(0) => slice(0, 0, 2, 1, 1, 2)
    case Trit(1) => slice(2, 1, 1, 2, 0, 0)
    case Trit(2) => slice(1, 2, 2, 1, 0, 0)
  }

  // toDo due to bug in specifications in http://sync.in/CgHccQAR6j   at line 53
  // toDo BUG here - this list has no meaning; it contains shit. akukle, please fix this
  def output1(data: Trit) = data match {
    case Trit(0) => slice(1, 1, 2, 0, 2, 0)
    case Trit(1) => slice(2, 1, 2, 0, 1, 0)
    case Trit(2) => slice(2, 0, 2, 1, 1, 0)
  }

  def initial = slice(0, 0, 1, 2, 1, 2)

  //////////////

  def trits(in: String): List[Trit] = in.toCharArray.map(x => Trit(x.toInt - '0'.toInt)).toList

  def wiring(v: Iterable[Int]) = v.toArray

  def slice(v: Int*): List[Trit] = v.map(toTrit).toList
}
