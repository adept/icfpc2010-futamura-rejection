package org.pubmath

case class Trit (val value: Int) {
  require(value >= 0 && value < 3)

  override def toString = value.toString

  def +(b: Trit) = Trit.mod(this.value + b.value)
  def +(b: Int) = Trit.mod(this.value + b)
  def -(b: Trit) = Trit.mod(this.value - b.value + 3)
  def -(b: Int) = Trit.mod(this.value + 2 * b)
  def *(b: Trit) = Trit.mod(this.value * b.value)
  def *(b: Int) = Trit.mod(this.value * b)

}

object Trit {
  def mod(n: Int) = Trit(n % 3)
  def mkTrits(in: String): List[Trit] = in.toCharArray.map(x => Trit(x.toInt - '0'.toInt)).toList
}