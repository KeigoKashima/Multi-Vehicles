//
//
//

//物理エンジンBox2D
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

//////////////////////////////////////////
//////////////////////////////////////////

ArrayList<Robot>cars;        //Robotオブジェクトを格納するリスト
ArrayList<Particle>particles;

Surface surface;//地形のオブジェクト
LoadRectangle load; //積載物用のオブジェクト
//LoadSphere load; //積載物用のオブジェクト

Box2DProcessing box2d;    


//----------------グローバル変数-----------------//
public int WindowWidth = 1000;
public int WindowHeight = 500; 

//地形
public float Frequency = 2;//周波数
public float Amplitude = 30;//振幅

//物理パラメータ
public float Friction = 0.8;//摩擦
public float Restitution = 0.01;//反発係数

//ロボット
private int  NUM = 10;//Robotの個数
public float BodyWidth   = 15;//車体_幅
public float BodyHeight  = 15;//車体_高さ
public float WheelRadius = BodyWidth/2;//車輪_半径
public float RobotHeight = 50;//車体と車輪の距離

//積荷
public float LoadWidth   = 100;//積荷_幅
public float LoadHeight  =  50;//積荷_高さ
public float LoadInitialPosX = 130;//積荷_初期位置_X
public float LoadInitialPosY = 200;//積荷_初期位置_Y
public float LoadDensity = 0.1;//積荷_密度

//回転ジョイント
public float MotorSpeed = 2*PI;//モータの速さ
public float MotorTorque = 1000.0;//モータトルクの強度
//直動ジョイント
public Vec2 PrismaticJointVector= new Vec2(0, -0.1);//ボディの可動方向
public float PrismaticJointForce = 100.0;//可動方向へ動く速度
public float MotorGain = 10;

//////////////////////////////////////////
//----------------設定-----------------///
//////////////////////////////////////////
void setup() {
        size(1000, 500);
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
void draw() {
        //背景
        background(255);
        
        //描画に必要な関数
        box2d.step();
        
        // 環境を描画
        surface.display();
        //積載物を描画
        load.display();
        
        // 全てのRobotを描画
        for (Robot car : cars) car.display();
        
        for (int i=0; i<NUM; i++) {
                if      (i==0)    cars.get(i).changeHeight(cars.get(i+1));//最後尾の場合
                else if (i==NUM-1)cars.get(i).changeHeight(cars.get(i-1));//先頭の場合
                else              cars.get(i).changeHeight(cars.get(i-1), cars.get(i+1));//それ以外
        }

        ////パーティクルの描画
        //シェイプの確認用
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
        
        fill(0);
        
        
        //テキストの表示
        text("Input Gain："+MotorGain,width/20, 14*height/20);
        text("Motor："+status,width/20,16*height/20);
        text("Frequency："+Frequency+"    "+"Amplitude:"+Amplitude, width/20, 15*height/20);
        
        
        text( "m : Switch Motor",15*width/20, 15*height/20);
        text( "x : Stop",15*width/20, 16*height/20);
        text( "s : Resume",15*width/20, 17*height/20);
        text( "w : Exit",15*width/20, 18*height/20);
}
