package org.pubmath.factory

/**
 * @author Alexander Temerev
 */
object FactoryGenerator {
/*
  def main(args: Array[String]) = {
    println(generateWiringsString("0122"))
  }

  val magic = Array(
    Map(Trit(0) -> Trit.mkTrits("002112"), Trit(1) -> Trit.mkTrits("211200"), Trit(2) -> Trit.mkTrits("122100")),
    Map(Trit(0) -> Trit.mkTrits("112120"), Trit(1) -> Trit.mkTrits("212011"), Trit(2) -> Trit.mkTrits("202111"))
    )

  def generateWiringsString(trits: String):String = {
    val wires = "[" + generateWirings(Trit.mkTrits(trits)).mkString(",") + "]"
    val n = trits.length
    val result = wires.replace("(" + n + ",L))", "(0,X)),((0,X),(" + n + ",L))")
    println(wires)
    println(result)
    result
  }


  def generateWirings(data: List[Trit]): List[String] = {
    // padded data should contain even number of elements
    val workData = (if (data.length % 2 == 0) data else (data ::: List(Trit(0)))).reverse
    val len = workData.length
    val size = len + 1

    var lastOut = Trit.mkTrits("001212")
    var result = List[String]("((2,L),(0,L))","((2,R),(0,R))","((3,L),(1,L))","((3,R),(1,R))")

    for (i <- 0 to len - 1) {
      // Left out of the i-th layer should be workData(i)
      // For that we must permute lastOut to magic(i % 2)(workData(i))
      val permutation = findPermutation(lastOut, magic(i % 2)(workData(i)))

      result = result ++ (0 to 5).map(n => "(" + connectionName(size, i, permutation(n)) + "," + connectionName(size, i - 1, n) + ")")
      val nextIn = permutation.map(n => lastOut(n))
      lastOut = List[Trit](
        nextIn(0) - nextIn(1), nextIn(0) * nextIn(1) - 1,
        nextIn(2) - nextIn(3), nextIn(2) * nextIn(3) - 1,
        nextIn(4) - nextIn(5), nextIn(4) * nextIn(5) - 1
        )
      println(lastOut(0))
    }
    result = result ++ ""
    
    return result
  }

  def connectionName(len: Int, row: Int, col: Int): String = {
    require(0 <= col && col < 6 && -1 <= row && row < len)

    if (row == -1 && col == 0) return "(" + (3 * len - 1) + ",L)"
    if (row == -1 && col == 1) return "(" + (3 * len - 1) + ",R)"

    val side = if (col % 2 == 0) "L" else "R"
    val gateCol = col >> 1

    if (row < 0 && gateCol == 0) throw new IllegalArgumentException

    val gateNum = (
            if (row < 0) (
                    2 * row + gateCol + 3
                    ) else if (row < len - 2) (
                    3 * row + gateCol + 4
                    ) else if (gateCol == 0) (
                    2 * len + row
                    ) else (
                    2 * (row - len) + gateCol + 3
                    )
            )
    return "(" + gateNum + "," + side + ")"
  }


  def findPermutation(in: List[Trit], out: List[Trit]): List[Int] = {
    val mutableIn = in.toBuffer
    var result = List[Int]()
    for (o <- out) {
      val Search = new Breaks
      Search.breakable {
        for (i <- 0 to in.length - 1) {
          if (o == mutableIn(i)) {
            result = result ::: List(i)
            mutableIn(i) = null
            Search.break
          }
        }
      }
    }
    return result
  }
*/
}