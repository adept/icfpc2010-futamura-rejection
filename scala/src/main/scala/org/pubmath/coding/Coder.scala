package org.pubmath.coding

/**
 * @author Alexander Temerev
 */

object Coder {

  def main(args: Array[String]) {
    for (i <- 0 to 25) println(i + ": " + encode(i) + " : " + decode(encode(i)))
  }

  def encode(n: Int): String = {
    if (n == 0) "0"
    else if (n <= 3) "1" + toBaseThree(n - 1)
    else {
      val mantissaLength = math.ceil(math.log(n) / math.log(3)).toInt
      "2" + encode(mantissaLength - 2) + toBaseThree(n - math.pow(3, mantissaLength - 1).toInt - 1, mantissaLength)
    }
  }

  def decode(s: String): Int = decodeStream(s)._1

  def decodeStream(s: String): Pair[Int, String] = {
    val c = s.head
    if (c == '0') return (0, s.tail)
    if (c == '1') return (Integer.parseInt(s.charAt(1).toString) + 1, s.substring(2))
    if (c == '2') {
      val (len, rem) = decodeStream(s.tail)
      return (fromBaseThree(rem.substring(0, len + 2)) + 1 + (math.pow(3, (len + 1))).toInt, rem.substring(len + 2))
    }
    throw new IllegalArgumentException("Wrong trit: " + s)
  }

  def toBaseThree(n: Int, padding: Int = 0): String = {
    val s = Integer.toString(n, 3)
    val times = math.max(0, padding - s.length)
    "0"*times + s 
  }
  def fromBaseThree(s: String):Int = Integer.parseInt(s, 3)
}