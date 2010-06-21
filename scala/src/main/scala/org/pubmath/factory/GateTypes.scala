package org.pubmath.factory

import org.pubmath.Trit

/**
 * @author Alexander Temerev
 */
object GateTypes {
  val SYMMETRIC_ADDER = Array(
    (Trit(0), Trit(0)),
    (Trit(0), Trit(1)),
    (Trit(0), Trit(2)),
    (Trit(0), Trit(1)),
    (Trit(1), Trit(2)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(2)),
    (Trit(0), Trit(0)),
    (Trit(2), Trit(1))
    )

  val SYMMETRIC_MALBOLGE = Array(
    (Trit(1), Trit(1)),
    (Trit(1), Trit(1)),
    (Trit(2), Trit(2)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(2), Trit(2)),
    (Trit(0), Trit(0)),
    (Trit(2), Trit(2)),
    (Trit(1), Trit(1))
    )

  val ANTISYMMETRIC_MALBOLGE = Array(
    (Trit(1), Trit(1)),
    (Trit(1), Trit(1)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(2)),
    (Trit(0), Trit(2)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(2)),
    (Trit(2), Trit(0)),
    (Trit(1), Trit(1))
    )

  val ANTISYMMETRIC_MALBOLGE_2 = Array(
    (Trit(1), Trit(1)),
    (Trit(1), Trit(1)),
    (Trit(0), Trit(2)),
    (Trit(2), Trit(0)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(2)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(2)),
    (Trit(1), Trit(1))
    )

  val SHIFTED_MALBOLGE = Array(
    (Trit(1), Trit(2)),
    (Trit(1), Trit(2)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(1)),
    (Trit(0), Trit(1)),
    (Trit(2), Trit(0)),
    (Trit(0), Trit(1)),
    (Trit(2), Trit(0)),
    (Trit(1), Trit(2))
    )


  val ZERO = Array(
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0)),
    (Trit(0), Trit(0))
    )

  val BRUTE = Array(
    (Trit(0), Trit(2)),
    (Trit(2), Trit(2)),
    (Trit(1), Trit(2)),
    (Trit(1), Trit(2)),
    (Trit(0), Trit(0)),
    (Trit(2), Trit(1)),
    (Trit(2), Trit(2)),
    (Trit(1), Trit(1)),
    (Trit(0), Trit(0))
    )



  def asString(gt: Array[Pair[Trit, Trit]]) = {
    gt.map(x => x._1.toString + x._2.toString).mkString
  }
}