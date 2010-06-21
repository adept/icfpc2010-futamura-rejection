package main.scala.org.pubmath.engine

import io.Source

/**
 * Created by IntelliJ IDEA.
 * User: Alexander Kosenkov
 * Date: 20.06.2010
 * Time: 18:06:20
 * To change this template use File | Settings | File Templates.
 */

class Generator(upper: String, lower: String) {
  val map = Generator.minus(count(upper), count(lower))

  // DEBEAEF
  def count(s: String) = {
    val tot = s.size

    var m = Map[Char, Float]()
    for (z <- s.toCharArray.zipWithIndex)
      m += z._1 -> (m.getOrElse(z._1, 0.0f) + 1.0f)// * (z._2 + 1) / tot)

    m
  }


  override def toString = map.toString
}

object Generator {
  val pattern = """(\w+) - (\w+) >(=?) 0""".r

  def fromDecoded(file: String) = {

    Source.fromFile(file).
            getLines().
            map(s => pattern.findFirstMatchIn(s).get).
            map(m => new Generator(m.group(1), m.group(2))).
            foldLeft(Map[Char, Float]())((m, g) => plus(m, g.map))


  }

  def minus(upper: Map[Char, Float], lower: Map[Char, Float]) = Map.empty ++ ((upper.keySet ++ lower.keySet).
          map(k => k -> (upper.getOrElse(k, 0.0f) - lower.getOrElse(k, 0.0f))))

  def plus(upper: Map[Char, Float], lower: Map[Char, Float]) = Map.empty ++ ((upper.keySet ++ lower.keySet).
          map(k => k -> (upper.getOrElse(k, 0.0f) + lower.getOrElse(k, 0.0f))))

}