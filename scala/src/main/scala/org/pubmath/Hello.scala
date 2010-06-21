import org.pubmath.factory.{GateTypes, Factory}
import org.pubmath.Trit
import util.Random

object Hello {

  val random = new Random()

  def main(args: Array[String]): Unit = {

    val factory = new Factory(GateTypes.BRUTE, args(0))

    for (i <- 1 to 20) {
      val input = randomTrits(1000)
      val result = factory.run(Trit.mkTrits("0" + input))
      if (result.mkString.tail != input) throw new IllegalStateException("Fuck up!")
    }
    println("Victory!")
  }

  def randomTrits(n: Int): String = (1 to n).map(x => random.nextInt(3)).mkString
}