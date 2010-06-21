package main.scala.org.pubmath

/**
 * Created by IntelliJ IDEA.
 * User: Alexander Kosenkov
 * Date: 18.06.2010
 * Time: 22:57:31
 * To change this template use File | Settings | File Templates.
 */

object Filter {
  val in = trits("01202101210201202")

  def main(args: Array[String]): Unit = {
    val m = new Mapping()

    while (true) {

      val mSize = m.size

      // 1-d state
      runPic2(m)
      runPic25(m)
      runPic7(m)
      runPic4(m)

      // 2-d state
      runPic9(m)
      runPic6(m)
      runPic3(m)
      runPic8(m)

      // complex 2-d state
      runPic5(m)

      if (mSize == m.size) {
        println("No more data. Collected " + m.size)
        println(m)
        return
      }
    }

  }

  def runPic2(m: Mapping): Unit = {
    var st = 0
    for (t <- in.zip(trits("02120112100002120"))) {

      val i = t._1
      val o = t._2
      m.setLeft(i, st, o)
      val st2 = m.get(i, st)._2

      if (st2.isEmpty) return else st = st2.get
    }
  }

  def runPic25(m: Mapping): Unit = {
    var st = 0
    for (t <- in.zip(trits("22022022022022022"))) {

      val i = t._1
      val o = t._2
      m.setRight(st, i, o)
      val st2 = m.get(st, i)._1

      if (st2.isEmpty) return else st = st2.get
    }
  }

  def runPic4(m: Mapping): Unit = {
    var st = 0
    for (t <- in.zip(trits("22120221022022120"))) {

      val i = t._1
      val o = t._2

      m.setRight(i, st, o)
      val st2 = m.get(i, st)._1

      if (st2.isEmpty) return else st = st2.get
    }
  }

  def runPic7(m: Mapping): Unit = {
    var st = 0
    for (t <- in.zip(trits("01210221200001210"))) {

      val i = t._1
      val o = t._2

      m.setLeft(st, i, o)
      val st2 = m.get(st, i)._2

      if (st2.isEmpty) return else st = st2.get
    }
  }


  def runPic9(m: Mapping): Unit = {
    var st1 = 0
    var st2 = 0

    for (t <- in.zip(trits("20002102102102102"))) {
      val i = t._1
      val o = t._2

      val out1 = m.get(st1, i)
      if (out1._2.isEmpty) return

      m.setLeft(out1._2.get, st2, o)
      val out2 = m.get(out1._2.get, st2)

      if (out1._1.isEmpty) return else st1 = out1._1.get
      if (out2._2.isEmpty) return else st2 = out2._2.get
    }
  }

  def runPic6(m: Mapping): Unit = {
    var st1 = 0
    var st2 = 0

    for (t <- in.zip(trits("22022020222220202"))) {
      val i = t._1
      val o = t._2

      val out1 = m.get(i, st1)
      if (out1._1.isEmpty) return

      m.setRight(st2, out1._1.get, o)
      val out2 = m.get(st2, out1._1.get)

      if (out1._2.isEmpty) return else st1 = out1._2.get
      if (out2._1.isEmpty) return else st2 = out2._1.get
    }
  }

  def runPic3(m: Mapping): Unit = {
    var st1 = 0
    var st2 = 0

    for (t <- in.zip(trits("00100202221110100"))) {
      val i = t._1
      val o = t._2

      val out1 = m.get(i, st1)
      if (out1._1.isEmpty) return

      m.setLeft(out1._1.get, st2, o)
      val out2 = m.get(out1._1.get, st2)

      if (out1._2.isEmpty) return else st1 = out1._2.get
      if (out2._2.isEmpty) return else st2 = out2._2.get
    }
  }

  def runPic8(m: Mapping): Unit = {
    var st1 = 0
    var st2 = 0

    for (t <- in.zip(trits("21202210221202210"))) {
      val i = t._1
      val o = t._2

      val out1 = m.get(st1, i)
      if (out1._2.isEmpty) return

      m.setRight(st2, out1._2.get, o)
      val out2 = m.get(st2, out1._2.get)

      if (out1._1.isEmpty) return else st1 = out1._1.get
      if (out2._1.isEmpty) return else st2 = out2._1.get
    }
  }

  def runPic5(m: Mapping): Unit = {
    var st1 = 0
    var st2 = 0

    for (t <- in.zip(trits("20122122012222020"))) {
      val i = t._1
      val o = t._2

      m.setRight(i, st1, o)
      val out1 = m.get(i, st1)

      if (out1._1.isEmpty) return
      val out2 = m.get(out1._1.get, st2)

      if (out2._1.isEmpty) return else st1 = out2._1.get
      if (out2._2.isEmpty) return else st2 = out2._2.get
    }
  }

  def trits(in: String): List[Int] = in.toCharArray.map(x => x.toInt - '0'.toInt).toList

}

class Mapping {
  // known
  var mL = scala.collection.mutable.Map[Pair[Int, Int], Int]()
  var mR = scala.collection.mutable.Map[Pair[Int, Int], Int]()

  def setLeft(leftK: Int, rightK: Int, leftV: Int) = {
    val key = Pair(leftK, rightK)
    val old = mL.put(key, leftV);
    require(old.getOrElse(leftV) == leftV, "bad mapping " + key + " -> " + leftV + ",*")

    if (old.isEmpty) println(key + " -> " + get(leftK, rightK))
  }

  def setRight(leftK: Int, rightK: Int, rightV: Int) = {
    val key = Pair(leftK, rightK)
    val old = mR.put(key, rightV);
    require(old.getOrElse(rightV) == rightV, "bad mapping " + key + " -> *, " + rightV)

    if (old.isEmpty) println(key + " -> " + get(leftK, rightK))
  }

  def get(leftK: Int, rightK: Int) = {
    val k = Pair(leftK, rightK)
    getK(k)
  }

  def getK(k: Pair[Int, Int]) = Pair(mL.get(k), mR.get(k))

  override def toString = (mL.keySet ++ mR.keySet).map(k => "" + k + " -> " + getK(k)).toList.sorted.mkString("\n")

  def size = mL.size + mR.size

}