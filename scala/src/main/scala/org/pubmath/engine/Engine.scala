package main.scala.org.pubmath.engine

abstract class Fuel {
  // calculate transfer rate from air element i to j. total size is n-by-n.
  def unapply(n: Int, i: Int, j: Int): Double
}

case class FuelTank(id: Int) {
  require(id >= 0 && id < 6)
}

case class Chamber(val upperPipe: List[FuelTank], val lowerPipe: List[FuelTank]) {
  def isConnected = {

    // tank t depends on tank s directly,
    // if there is a chamber c such that tank s feeds some section of c's upper pipe, 
    // and tank t feeds some section of c's lower pipe
    def dependsDirectly(fromT: FuelTank, toS: FuelTank) = upperPipe.contains(toS) && lowerPipe.contains(fromT);

    // toDo
    true;
  }

}

case class Engine(val n: Int, val chambers: List[Pair[Chamber, Boolean]]) {
  require(chambers.isEmpty || chambers.map(_._2).contains(true), "Engine must have at least one main chamber")

  def numberOfTanks = chambers.map(_._1).
          map(c => (c.upperPipe.toSet + c.lowerPipe.toSet).size).
          reduceLeft[Int](_ + _)

  def acceptsFuels(fuels: List[Fuel]) = {
    require(fuels.size == numberOfTanks)

  }
}