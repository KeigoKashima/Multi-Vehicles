import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.joints.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.collision.shapes.Shape; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.dynamics.contacts.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MultiVehicles_4_Tegotae extends PApplet {

 //
//
//

//物理エンジンBox2D









//////////////////////////////////////////
//////////////////////////////////////////

ArrayList<Robot>cars;        //Robotオブジェクトを格納するリスト
ArrayList<Particle>particles;

Surface surface;//地形のオブジェクト
LoadRectangle load; //積載物用のオブジェクト
//LoadSphere load; //積載物用のオブジェクト

Box2DProcessing box2d;


//----------------グローバル変数-----------------//
static int WindowWidth = 1500;
static int WindowHeight = 500;

//地形
public float Frequency = 5;//周波数
public float Amplitude = 20;//振幅

//物理パラメータ
public float Friction = 0.8f;//摩擦
public float Restitution = 0.01f;//反発係数

//ロボット
private int  NUM = 15;//Robotの個数
public float BodyWidth   = 10;//車体_幅
public float BodyHeight  = 15;//車体_高さ
public float WheelRadius = BodyWidth/2;//車輪_半径
public float RobotHeight = 50;//車体と車輪の距離

//積荷
public float LoadWidth   = 150;//積荷_幅
public float LoadHeight  =  30;//積荷_高さ
public float LoadInitialPosX = 108;//積荷_初期位置_X
public float LoadInitialPosY = 100;//積荷_初期位置_Y
public float LoadDensity = 2;//積荷_密度

//回転ジョイント
public float MotorSpeed = 2*PI;//モータの速さ
public float MotorTorque = 1000.0f;//モータトルクの強度
//直動ジョイント
public Vec2 PrismaticJointVector= new Vec2(0, -1);//ボディの可動方向
public float PrismaticJointForce = 1000.0f;//可動方向へ動くモータの力
public float PGain = 2500;

public float frequencyHz = 10;
public float dampingRatio = 1;

//////////////////////////////////////////
//----------------設定-----------------///
//////////////////////////////////////////
public void setup() {
        
        //Box2Dワールドの初期化と作成
        box2d = new Box2DProcessing(this);
        box2d.createWorld();

        cars  = new ArrayList<Robot>(); //Robotオブジェクトを作成
        surface = new Surface(); //Surfaceオブジェクトを作成
        //LoadRectangleオブジェクトを作成
        load = new LoadRectangle(LoadInitialPosX, LoadInitialPosY);
        //LoadSphereオブジェクトを作成
        //load = new LoadSphere(LoadInitialPosX,LoadInitialPosY);

        //NUM個の一輪Robotを用意して，リストに格納する
        for (int i=0; i<NUM; i++) {
                Robot car =  new Robot(5*BodyWidth*(i)/4+30, height/2+40);
                cars.add(car);
        }

        //パーティクル
        //particles = new ArrayList<Particle>();
}


//////////////////////////////////////////
//----------------描画-----------------///
//////////////////////////////////////////
public void draw() {
        //背景
        background(255);

        //描画に必要な関数
        box2d.step();

        // 環境を描画
        surface.display();
        //積載物を描画
        load.display();

        int i = 0;
        for (Robot car : cars) {
                // 全てのRobotを描画
                car.display();
                //高さを変える関数
                if (car.motorOn()) car.changeHeight();
                if(i == 2) car.textDistance();
                i++;
        }

        ////パーティクルの描画
        //Particle particle =  new Particle(random(30, width), 0);
        //particles.add(particle);
        //for (Particle p : particles) {
        //  p.display();
        //}

        //モーターの状態を保持
        String status = "OFF";
        for (Robot car : cars) {
                if (car.motorOn()) status = "ON";
        }




        //====テキスト====//
        //文字の色
        fill(0);

        //==プロパティ==//
        //地形情報
        text("Frequency : "+Frequency+", "+"Amplitude:"+Amplitude, width/20, 15*height/20);
        //RevoluteJointモーターのON/OFF
        text("Motor : "+status,width/20,16*height/20);
        //積載物の質量
        text( "Load Weight : "+load.body.getMass(),width/20, 17*height/20);
        text( "PrismatidJointForce : "+PrismaticJointForce,width/20, 18*height/20);
        //比例ゲイン
        text( "Proportional Gain : "+PGain,width/20, 19*height/20);

        //==データ==//
        textSize(16);
        text( "Load Angle : "+180*load.body.getAngle()/PI,5*width/20, 15*height/20);


        text( "m : Switch Motor",15*width/20, 15*height/20);
        text( "p : Set initDistance",15*width/20, 16*height/20);
        text( "x : Stop",15*width/20, 17*height/20);
        text( "s : Resume",15*width/20, 18*height/20);
        text( "w : Exit",15*width/20, 19*height/20);



        //====動画用====//
        //静止画を保存
        //frameSave();



}
//二つの正方形を上下に重ねたもの
//常に水平を保つ


class Box {
        Body body;
        float w,h;//長方形の幅，高さ
      
        //////////////////////////////////////////
        Box(float x, float y,float w_, float h_) {
                w = w_;
                h = h_;
                
                ////////////////////////////////////////// 
                //ボディを定義 
                BodyDef bd = new BodyDef();
                bd.type = BodyType.DYNAMIC;
                bd.fixedRotation = true;//回転を固定する
                bd.position.set(box2d.coordPixelsToWorld(x, y));
                //ボディを作成する    
                body = box2d.createBody(bd);
            
            
                ////////////////////////////////////////// 
                //シェイプを定義
                //荷台用のBox
                PolygonShape ps = new PolygonShape();
            
                //幅と高さをピクセルからBox2Dワールドに変換
                float box2dW = box2d.scalarPixelsToWorld(w/2);
                float box2dH = box2d.scalarPixelsToWorld(h/2);
                
            
                //シェイプを長方形として定義する．
                ps.setAsBox(box2dW, box2dH);
            
                //フィクスチャを作成し，シェイプをボディに割り当てる
                FixtureDef fd = new FixtureDef();
                fd.shape = ps;
                //各パラメータ
                fd.density = 0.1f;
                fd.friction = Friction;
                fd.restitution = Restitution;
                
                //フィクスチャを使ってボディにシェイプをアタッチする．
                body.createFixture(fd);
        }
      
      
        //=========================描画================================///       
        public void display() {
                Vec2 pos = box2d.getBodyPixelCoord(body);
                float a = body.getAngle();
            
                //現在の座標を保存
                pushMatrix();
                //Vec2の位置と浮動小数点の角度を使用して，長方形を移動，回転
                translate(pos.x, pos.y);
            
                fill(175);
                stroke(0);
                rectMode(CENTER);    
                rect(0, 0, w, h);
            
                //元の座標に戻す．
                popMatrix();
        }
        //Box2Dワールドからボディを取り除く関数
        public void killBody() {
                box2d.destroyBody(body);
        }
}
//////////////////////////////////////////
//////////////////////////////////////////
public void keyPressed() {
        //モーターのオンオフを切り替える
        if (key == 'm') { 
                for (Robot car: cars) {
                        car.toggleMotor();   
                }  
        }
        
        //初期位置を取得する
         if (key == 'p') { 
                for (Robot car: cars) {
                        car.setPos();   
                }  
        }
        
        //一時停止
        if (key == 'x'){
                noLoop();
        } 
        //再開
        if (key == 's'){
                loop();
        }         
        //終了
        if (key == 'w') {
                exit();
        }
        
}
//境界のBox2オブジェクト
class Line{
        ArrayList<Vec2> line;
        float d = RobotHeight;
        Body body;
        
        Line(float x,float y){        
                //ボディを定義
                BodyDef bd = new BodyDef();
                //ボディの位置を設定
                bd.position.set(box2d.coordPixelsToWorld(x,y));
                bd.fixedRotation = true;//回転を固定する
                bd.type = BodyType.DYNAMIC;
                body = box2d.world.createBody(bd);
                
                line = new ArrayList<Vec2>();
                line.add(new Vec2(0,0));
                line.add(new Vec2(0,-d));
               
                //シェイプを定義する
                ChainShape chain = new ChainShape();                                                                                                                                       
                //シェイプを設定する
                //頂点の配列を指定する
                Vec2[] vertices = new Vec2[line.size()];
                for (int i= 0; i<vertices.length; i++){
                         vertices[i] = box2d.coordPixelsToWorld(line.get(i));//頂点の座標をピクセル表記からワールド表記に
                }
                   
                //頂点のチェーンを作成するために，createChain()関数に配列を渡す
                chain.createChain(vertices, vertices.length);
                
                //Fixtureを作成し，Shapeを割り当てる
                FixtureDef fd = new FixtureDef();
                fd.shape = chain;
                fd.density = 0.01f;
                fd.friction = Friction;
                fd.restitution = Restitution;
                
                body.createFixture(fd);      
        }
        
        public void display(float l, float c){
                //車体と荷台の距離
                Vec2 pos = box2d.getBodyPixelCoord(body);
                //現在の座標を保存
                pushMatrix();
                //Vec2の位置と浮動小数点の角度を使用して，線分を移動，回転
                translate(pos.x, pos.y);
                fill(c);
                stroke(3);
                line(0,0,0,-l);
                //元の座標に戻す．
                popMatrix();
         }
         
}

class LoadRectangle{
          Body body;
          
          float w = LoadWidth;   //高さ
          float h = LoadHeight;  //高さ

          //////////////////////////////////////////
          //////////////////////////////////////////
          LoadRectangle(float x, float y){              
                    //ボディを定義 
                    BodyDef bd = new BodyDef();
                    bd.type = BodyType.DYNAMIC;
                    bd.position.set(box2d.coordPixelsToWorld(x,y));
                    //ボディを作成する    
                    body = box2d.createBody(bd);
                   
                    //シェイプを定義
                    PolygonShape ps = new PolygonShape();
                    
                    ////幅と高さをピクセルからBox2Dワールドに変換
                    float box2dW = box2d.scalarPixelsToWorld(w/2);
                    float box2dH = box2d.scalarPixelsToWorld(h/2);
                  
                    //シェイプを長方形として定義する．
                    ps.setAsBox(box2dW,box2dH);
                    
                    //フィクスチャを作成し，シェイプをボディに割り当てる
                    FixtureDef fd = new FixtureDef();
                    fd.shape = ps;
                    
                    
                    //各パラメータ
                    fd.density = LoadDensity;
                    fd.friction = Friction;
                    fd.restitution = Restitution;
                   
                    //フィクスチャを使ってボディにシェイプをアタッチする．
                    body.createFixture(fd);
          }
  
  
          //////////////////////////////////////////
          //////////////////////////////////////////
          public void display(){
                    Vec2 pos = box2d.getBodyPixelCoord(body);
                    float a = body.getAngle();
                   
                    //現在の座標を保存
                    pushMatrix();
                    //Vec2の位置と浮動小数点の角度を使用して，長方形を移動，回転
                    translate(pos.x,pos.y);
                    rotate(-a);
                    fill(175);
                    stroke(0);
                    rectMode(CENTER);
                    rect(0,0,w,h);
                    
                   
                    //元の座標に戻す．
                    popMatrix();
                    
          }
           //Box2Dワールドからボディを取り除く関数
          public void killBody(){
                    box2d.destroyBody(body);
          }
}

class LoadSphere{
          Body body;
          
          float w = LoadWidth;   //高さ
          float h = LoadHeight;  //高さ

          //////////////////////////////////////////
          //////////////////////////////////////////
          LoadSphere(float x, float y){              
                    //ボディを定義 
                    BodyDef bd = new BodyDef();
                    bd.type = BodyType.DYNAMIC;
                    bd.position.set(box2d.coordPixelsToWorld(x,y));
                    //ボディを作成する    
                    body = box2d.createBody(bd);
                   
                    //シェイプを定義
                    //PolygonShape ps = new PolygonShape();
                    CircleShape cs = new CircleShape();
                    cs.m_radius = box2d.scalarPixelsToWorld(h);
                    
                    ////幅と高さをピクセルからBox2Dワールドに変換
                    //float box2dW = box2d.scalarPixelsToWorld(w/2);
                    //float box2dH = box2d.scalarPixelsToWorld(h/2);
                  
                    //シェイプを長方形として定義する．
                    //ps.setAsBox(box2dW,box2dH);
                    
                    //フィクスチャを作成し，シェイプをボディに割り当てる
                    FixtureDef fd = new FixtureDef();
                    //fd.shape = ps;
                    fd.shape = cs;
                    
                    
                    //各パラメータ
                    fd.density = LoadDensity;
                    fd.friction = Friction;
                    fd.restitution = Restitution;
                   
                    //フィクスチャを使ってボディにシェイプをアタッチする．
                    body.createFixture(fd);
          }
  
  
          //////////////////////////////////////////
          //////////////////////////////////////////
          public void display(){
                    Vec2 pos = box2d.getBodyPixelCoord(body);
                    float a = body.getAngle();
                   
                    //現在の座標を保存
                    pushMatrix();
                    //Vec2の位置と浮動小数点の角度を使用して，長方形を移動，回転
                    translate(pos.x,pos.y);
                    rotate(-a);
                    fill(175);
                    stroke(0);
                    rectMode(CENTER);
                    //rect(0,0,w,h);
                    ellipse(0,0,h*2,h*2);
                   
                    //元の座標に戻す．
                    popMatrix();
                    
          }
           //Box2Dワールドからボディを取り除く関数
          public void killBody(){
                    box2d.destroyBody(body);
          }
}
//Wheel(車輪)とline(リンク)を回転ジョイントで接続
//line(リンク)とBox(荷台)を直動ジョイントで接続する
//

class Robot{
            RevoluteJoint rj;
            DistanceJoint dj;
            PrismaticJoint pj1;
            PrismaticJoint pj2;
            
            Wheel wheel;//車輪
            Line line1;  //車輪と回転ジョイントで繋がるリンク
            Line line2;  //line1とディスタンスジョイントで繋がるリンク
            Box nidai; //荷台:line2と直動ジョイントで繋がる
            
            //初期状態におけるline1とline2y座標の差
            float initDistance = 0;
            
            //////////////////////////////////////////
            //----------------設定-----------------///
            //////////////////////////////////////////
            Robot(float x, float y){
                    float distance = 50;
              
                    //オブジェクトを作成
                    line1 = new Line(x,y); //車輪と車体を繋ぐリンク
                    line2 = new Line(x,y-distance); //車輪と車体を繋ぐリンク
                    wheel = new Wheel(x,y,WheelRadius);//車輪
                    nidai = new Box(x,y-line1.d-distance,BodyWidth,BodyHeight);//車体              

                    //wheelとline1
                    //回転ジョイントの定義
                    RevoluteJointDef rjd = new RevoluteJointDef(); 
                    //回転ジョイントの設定
                    Vec2 anchor = wheel.body.getWorldCenter(); //アンカーの座標を車輪の中心にする．
                    rjd.initialize(line1.body,wheel.body,anchor); //最初の二つの引数がボディ，３つ目がアンカーの座標
                    //プロパティを設定
                    //モーターのオンオフ
                    rjd.enableMotor = false; 
                    rjd.motorSpeed = -MotorSpeed;    //モーターの速度
                    rjd.maxMotorTorque = MotorTorque;//モーターの強度
                    //ジョイントを作成
                    rj = (RevoluteJoint) box2d.createJoint(rjd);
                     
                     
                    //line1とline2
                    //ディスタンスジョイントの定義
                    DistanceJointDef djd = new DistanceJointDef();
                    //ディスタンスジョイントの設定
                    djd.bodyA = line1.body;
                    djd.bodyB = line2.body;
                    djd.length = box2d.scalarPixelsToWorld(distance);//静止長
                    djd.frequencyHz = frequencyHz;
                    djd.dampingRatio = dampingRatio;
                    //ジョイントを作成
                    dj = (DistanceJoint)box2d.world.createJoint(djd);
                    
                    //line1とline2
                    //直動ジョイントの定義
                    PrismaticJointDef pjd1 = new PrismaticJointDef();
                    //直動ジョイントの設定
                    Vec2 anchorLine1 = line1.body.getWorldCenter(); //アンカーの座標をリンクの先にする．
                    Vec2 direction1 = box2d.vectorPixelsToWorld(PrismaticJointVector);//ボディの可動方向を決める．
                    pjd1.initialize(line2.body,line1.body,anchorLine1,direction1);//引数は（接続元，接続先，接続先の接続点を示すVec2，可動方向を示すVec2）
                    //プロパティ
                    pjd1.motorSpeed = box2d.scalarPixelsToWorld(0);//可動方向へ動く速度
                    pjd1.maxMotorForce = PrismaticJointForce;//可動方向へ押す力
                    pjd1.enableLimit = false;//可動範囲を有効にするか 
                    pjd1.enableMotor = false;//モーターをのON/OFF
                    //ジョイントを作成
                    pj1 = (PrismaticJoint)box2d.world.createJoint(pjd1);

                    
                    //line2とnidai
                    //直動ジョイントの定義
                    PrismaticJointDef pjd2 = new PrismaticJointDef();
                    //直動ジョイントの設定
                    Vec2 anchorLine2 = nidai.body.getWorldCenter(); //アンカーの座標をリンクの先にする．
                    Vec2 direction2 = box2d.vectorPixelsToWorld(PrismaticJointVector);//ボディの可動方向を決める．
                    pjd2.initialize(line2.body,nidai.body,anchorLine2,direction2);//引数は（接続元，接続先，接続先の接続点を示すVec2，可動方向を示すVec2）
                    //変形範囲
                    pjd2.upperTranslation = box2d.scalarPixelsToWorld(line2.d/2);
                    pjd2.lowerTranslation = box2d.scalarPixelsToWorld(-line2.d/2);
                    //プロパティ
                    pjd2.motorSpeed = box2d.scalarPixelsToWorld(0);//可動方向へ動く速度
                    pjd2.maxMotorForce = PrismaticJointForce;//可動方向へ押す力
                    pjd2.enableLimit = true;//可動範囲を有効にするか 
                    pjd2.enableMotor = true;//モーターをのON/OFF
                    //ジョイントを作成
                    pj2 = (PrismaticJoint)box2d.world.createJoint(pjd2);
            }
            
            //////////////////////////////////////////
            //----------------描画-----------------///
            //////////////////////////////////////////
            public void display(){
                    float l = box2d.getBodyPixelCoord(wheel.body).y- box2d.getBodyPixelCoord(nidai.body).y;
                    wheel.display();
                    line1.display(3,255);
                    line2.display(3,3);
                    nidai.display();
                    fill(0);
            }
            
            public void textDistance(){
                    float distance = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);       
                    float l = initDistance-distance;
                    text(l,10*width/20, 15*height/20);
            }
            
            
            
            //モーターをオンまたはオフに
            public void toggleMotor(){
                      rj.enableMotor(!rj.isMotorEnabled());
            }
            public boolean motorOn(){
                      return rj.isMotorEnabled();
            }
            
                        
           
           
            //=========================高さに関する関数================================///
            //引数に入れたオブジェクトの車輪のy座標と車体の高さから自身の高さを更新する関数
            //引数にRobotオブジェクト
            public void changeHeight() {    
                    float distance = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);       
                    float l = initDistance-distance;
                    pj2.setMotorSpeed(l*PGain);  
            }
            
            //初期状態でのline1とline2のy座標の差を取得
            public void setPos(){
                    float l = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);
                    initDistance = l;
            }
            
            
            //直動ジョイントのモーターをONにする
            public void SwitchMotor(){ 
                    pj2.enableMotor(true);//直動ジョイントをONにする  
            }
}
//境界のBox2オブジェクト
class Surface{
        ArrayList<Vec2> surface;
        
        Surface(){  
                //周波数と振幅
                float Freq = -Frequency;
                float Amp  = Amplitude;
              
                surface = new ArrayList<Vec2>();
                
                //サインカーブの地形
                float NUM = 1000;
                surface.add(new Vec2(0,50+height/2));
                for (int t = 0; t< (NUM+1); t++){
                        surface.add(new Vec2((t+200)*1500/NUM, Amp*sin(Freq*(t-NUM/2)*2*PI/NUM)+50+height/2));
                }
                
                
                //シェイプを定義する
                ChainShape chain = new ChainShape();                                                                                                                                       
                 
                //シェイプを設定する
                //頂点の配列を指定する
                Vec2[] vertices = new Vec2[surface.size()];
                for (int i= 0; i<vertices.length; i++){
                         vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
                }
                   
                //頂点のチェーンを作成するために，createChain()関数に配列を渡す
                chain.createChain(vertices, vertices.length);
                
                //ShapeをBodyにアタッチする
                BodyDef bd = new BodyDef();
                Body body = box2d.world.createBody(bd);
               
                 //Fixtureを作成し，Shapeを割り当てる
                FixtureDef fd = new FixtureDef();
                fd.shape = chain;
                fd.density = 1;
                fd.friction = Friction;
                fd.restitution = Restitution;
                
                body.createFixture(fd);      
        }
        
        public void display(){
                 strokeWeight(3);
                 stroke(0);
                 noFill();
                 
                 beginShape();
                 for (Vec2 v: surface){
                         vertex(v.x,v.y);
                 }
                 endShape();
         }
         
}
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A circular particle

class Wheel {
        // We need to keep track of a Body and a radius
        Body body;
        float r; //車輪の半径
        Wheel(float x, float y, float r_) {
          
                  r = r_;
                  //ボディを定義
                  BodyDef bd = new BodyDef();
                  //ボディの位置を設定
                  bd.position = box2d.coordPixelsToWorld(x,y);
                  bd.type = BodyType.DYNAMIC;
                  body = box2d.world.createBody(bd);
              
                  //シェイプを円形にする
                  CircleShape cs = new CircleShape();
                  cs.m_radius = box2d.scalarPixelsToWorld(r);
                  
                  FixtureDef fd = new FixtureDef();
                  fd.shape = cs;
                  
                  //物理に影響与えるパラメータ
                  fd.density = 100;
                  fd.friction = Friction;
                  fd.restitution = Restitution;
                  
                  //ボディにフィクスチャーをアタッチ
                  body.createFixture(fd);
        }
        
        // Box2Dワールドからオブジェクトを除去する関数
        public void killBody() {
                  box2d.destroyBody(body);
        }
      
        //スクリーン外ならボディを消してtrueを返す
        public boolean done() {
              //ボディの位置を取得
              Vec2 pos = box2d.getBodyPixelCoord(body);
              //スクリーン外に出たか確認
              if (pos.y > height+r*2) {
                    killBody();
                    return true;
              }
              return false;
        }
        
        public void display() {
              //各ボディの位置を取得
              Vec2 pos = box2d.getBodyPixelCoord(body);
              //角度も取得
              float a = body.getAngle();
              
              pushMatrix();
              translate(pos.x,pos.y);
              rotate(-a);
              fill(127);
              stroke(0);
              strokeWeight(2);
              ellipse(0,0,r*2,r*2);
              //回転が見えるように線を追加
              line(0,0,r,0);
              popMatrix();
        }


}
 
public void frameSave(){ 
          if(frameCount >  300){
                          if(frameCount%100 == 0){
                                  saveFrame("frames/####.png");
                                          if (frameCount >= 2000) {
                                                    exit();
                                          }        
                          }
          }
}
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A circular particle

class Particle {
          // We need to keep track of a Body and a radius
          Body body;
          float r;  
          
          Particle(float x, float y) {
                    r = 5;
                    //ボディを定義
                    BodyDef bd = new BodyDef();
                    //ボディの位置を設定
                    bd.position = box2d.coordPixelsToWorld(x,y);
                    bd.type = BodyType.DYNAMIC;
                    body = box2d.world.createBody(bd);
                
                    //シェイプを円形にする
                    CircleShape cs = new CircleShape();
                    cs.m_radius = box2d.scalarPixelsToWorld(r);
                    
                    FixtureDef fd = new FixtureDef();
                    fd.shape = cs;
                    
                    //物理に影響与えるパラメータ
                    fd.density = 0.1f;
                    fd.friction = 1;
                    fd.restitution = 0.001f;
                    
                    //ボディにフィクスチャーをアタッチ
                    body.createFixture(fd);
                    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
          }
          // Box2Dワールドからオブジェクトを除去する関数
          public void killBody() {
                    box2d.destroyBody(body);
      }
      
      //スクリーン外ならボディを消してtrueを返す
      public boolean done() {
            //ボディの位置を取得
            Vec2 pos = box2d.getBodyPixelCoord(body);
            //スクリーン外に出たか確認
            if (pos.y > height+r*2) {
                  killBody();
                  return true;
            }
            return false;
      }
    
      public void display() {
            //各ボディの位置を取得
            Vec2 pos = box2d.getBodyPixelCoord(body);
            //角度も取得
            float a = body.getAngle();
            done();
            
            pushMatrix();
            translate(pos.x,pos.y);
            rotate(-a);
            fill(127);
            stroke(0);
            strokeWeight(2);
            ellipse(0,0,r*2,r*2);
            //回転が見えるように線を追加
            line(0,0,r,0);
            popMatrix();
      }


}
  public void settings() {  size(1500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MultiVehicles_4_Tegotae" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
