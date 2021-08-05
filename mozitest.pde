import processing.serial.*;
Serial myPort;
String str_get_data = null;
String buf[];
float gx, gy, gz;//ジャイロ
float pregx, pregy, pregz;//一つ前のジャイロ

float dx, dy, dz;//角度
float dt, t;
boolean buttonPushed;
boolean resetPushed;

float roll, pitch, yaw;//Madgwickフィルターで調整した角度

import net.sourceforge.tess4j.*;
import net.sourceforge.tess4j.ITessAPI.TessPageIteratorLevel;
import net.sourceforge.tess4j.ITessAPI.TessOcrEngineMode;
import java.awt.Image;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.util.List;

import java.io.FileWriter;

import java.util.Calendar;

int   y  =  year( ) ;         
int  m  =  month( ) ;    //  1 – 12
int  d  =  day( ) ;           //  1 – 31
int  h  =  hour( ) ;         //  1 – 23
int  mi  =  minute( ) ; //  0 – 59
int  s  =  second( ) ;    //  0 – 59
String time =  y + "/" + m + "/" + d + "_" + h + ":" + nf(mi, 2) + ":" + nf(s, 2);

PImage target;
List<Word> words;

void setup() {
  size(1200, 800);
  background(255);


  myPort = new Serial(this, "COM5", 115200);
  paintGyroPre();
}
void draw() {
  background(255);
  dt = (millis() - t) / 1000.0;
  t = millis();

  paintGyro();

  //  dx += (gx - reggx) * dt;
  //  dy += (gy - reggy) * dt;
  //  dz += (gz - reggz) * dt;

  dx += (pregx + gx) * dt/2;
  dy += (pregy + gy) * dt/2;
  dz += (pregz + gz) * dt/2;

  println("gx:"+gx);
  println("gy:"+gy);
  println("gz:"+gz);
  println("dx:"+dx);
  println("roll:"+roll);
  println("dy:"+dy);
  println("pitch:"+pitch);
  println("dz:"+dz);
  println("yaw:"+yaw);
  println("switch:"+ buttonPushed);
  println("reset:"+ resetPushed);

  if (k_run == true) {
    kaiseki();
    pX = width/3;
    pY = height/4;
    dy = 0;
    k_run = false;
  }
}
void serialEvent(Serial myPort) {
  pregx = gx;
  pregy = gy;
  pregz = gz;
  str_get_data = myPort.readStringUntil(' ');
  if (str_get_data != null) {
    //str_get_data = trim(str_get_data);
    buf = split(str_get_data, ',');
    try {
      gx = float(buf[0]);
      gy = float(buf[1]);
      gz = float(buf[2]);

      buttonPushed = boolean(int(float(buf[3])));
      resetPushed = boolean(int(float(buf[4])));

      roll = float(buf[5]);
      pitch = float(buf[6]);
      yaw = float(buf[7]);
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}

void kaiseki() {
  //size(1199,695);

  //画像を読み取り、モノクロ化する
  target = loadImage("data/memoImage/memoimage"+ pngNo +".jpg");
  //pngNo++;
  // ImageMono();

  //ImageをBufferedImageに変換する
  BufferedImage bimg = ChangeImage( target.getImage());

  //Tess4J インスタンス生成
  ITesseract instance = new Tesseract();
  //日本語解析を指定
  instance.setLanguage("jpn");

  //必要な文字のみホワイトリストに指定する
  instance.setTessVariable("tessedit_char_whitelist", 
   // "0123456789:"
     "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげごさじずぜぞだぢづでどばびぶべぼっぱぴぷぺぽゃゅょ茶");

  //１ライン単位に解析する       
  words = instance.getWords(bimg, TessPageIteratorLevel.RIL_TEXTLINE);

  //結果をテキストファイルに吐き出す
  String result[] = new String[0];
  for ( Word w : words ) {
    result = append(result, w.getText());
  }  
  saveStrings( dataPath("\\memoChar") + "\\memoChar"+ pngNo +".txt", result );

  if (pngNo ==0) {
    textWrite( dataPath("\\memo") + "\\memo.txt", "\r\n"+time+"\r\n・");
  }
  textWrite( dataPath("\\memo") + "\\memo.txt", result[0] );



  pngNo++;
}

//モノクロ化処理
void ImageMono( ) {
  //描画キャンパス生成
  PGraphics  pg = createGraphics(target.width, target.height);
  //描画開始
  pg.beginDraw();
  pg.background(target);
  //モノクロ化
  pg.filter(GRAY);
  //描画終了
  pg.endDraw();
  target = pg;
}

//ImageをBufferedImageに変換する
BufferedImage ChangeImage(Image imageFile) {
  //RGBの空BufferedImage作成
  BufferedImage bimg = new BufferedImage(
    imageFile.getWidth(null), 
    imageFile.getHeight(null), 
    BufferedImage.TYPE_INT_RGB); 
  //空BufferedImageにImageを描画
  Graphics g = bimg.getGraphics();
  g.drawImage(imageFile, 0, 0, null);
  g.dispose();
  return bimg;
}

void textWrite( String fileName, String msg ) {
  try {
    FileWriter fw = new FileWriter( fileName, true );
    //以下なら上書き
    //FileWriter fw = new FileWriter( fileName );     
    fw.write(msg); 
    fw.close();
  } 
  catch (Exception ex) {
    //例外
    ex.printStackTrace();
  }
}

String timestamp() {//ここ全体がjava.util.Calendarの機能
  //これでtimestamp()に、現在のタイムスタンプが文字列(string)として返される
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
