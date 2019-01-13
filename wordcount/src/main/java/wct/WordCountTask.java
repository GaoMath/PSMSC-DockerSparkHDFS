package wct;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import scala.Tuple2;

import java.util.Arrays;

import static jersey.repackaged.com.google.common.base.Preconditions.checkArgument;

/**
 * The spark word count task.
 *
 * @author Guillaume Hugonnard and Tom Ragonneau
 * @version 1.0
 */
public class WordCountTask {

  /**
   * The Logger constant.
   */
  private static final Logger LOGGER = LoggerFactory.getLogger(WordCountTask.class);

  /**
   * The main executed method.
   *
   * @param args The path of input file and output file.
   */
  public static void main(String[] args) {
    checkArgument(args.length > 1, "Please provide the path of input file and output dir as parameters.");
    new WordCountTask().run(args[0], args[1]);
  }

  /**
   * The spark word count task.
   *
   * @param inputFilePath The input file.
   * @param outputFile The output file.
   */
  public void run(String inputFilePath, String outputFile) {
    SparkConf conf = new SparkConf().setAppName(WordCountTask.class.getName());
    JavaSparkContext sc = new JavaSparkContext(conf);

    JavaRDD<String> textFile = sc.textFile(inputFilePath);
    JavaPairRDD<String, Integer> counts = textFile
            .flatMap(s -> Arrays.asList(s.split(" ")).iterator())
            .mapToPair(word -> new Tuple2<>(word, 1))
            .reduceByKey((c1, c2) -> c1 + c2);
    counts.saveAsTextFile(outputFile);
  }

}
