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
static int WindowWidth = 1500;
static int WindowHeight = 500;

//地形
public float Frequency = 5;//周波数
public float Amplitude = 20;//振幅

//物理パラメータ
public float Friction = 0.8;//摩擦
public float Restitution = 0.01;//反発係数

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
public float MotorTorque = 1000.0;//モータトルクの強度
//直動ジョイント
public Vec2 PrismaticJointVector= new Vec2(0, -1);//ボディの可動方向
public float PrismaticJointForce = 1000.0;//可動方向へ動くモータの力
public float PGain = 2500;

public float frequencyHz = 10;
public float dampingRatio = 1;

//////////////////////////////////////////
//----------------設定-----------------///
//////////////////////////////////////////
void setup() {
        size(1500, 500);
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
