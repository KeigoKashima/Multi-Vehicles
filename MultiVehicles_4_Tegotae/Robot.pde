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


            //固有角速度
            float omega = PI/10;
            //位相振動子
            float phi = 0;
            //高さの変化量
            float dH = 0;

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
            void display(){
                    float l = box2d.getBodyPixelCoord(wheel.body).y- box2d.getBodyPixelCoord(nidai.body).y;
                    wheel.display();
                    line1.display(l,255);
                //     line2.display(3,3);
                    nidai.display();
                    fill(0);
            }
            
            void textDistance(){
                    float distance = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);       
                    float l = initDistance-distance;
                    text(phi,10*width/20, 15*height/20);
            }
            
            
            
            //モーターをオンまたはオフに
            void toggleMotor(){
                      rj.enableMotor(!rj.isMotorEnabled());
            }
            boolean motorOn(){
                      return rj.isMotorEnabled();
            }
            
                        
           
           
            //=========================高さに関する関数================================///
            //引数に入れたオブジェクトの車輪のy座標と車体の高さから自身の高さを更新する関数
            //引数にRobotオブジェクト
            void changeHeight() {  
                    //うける力をバネの変位量で表現  
                    float distance = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);       
                    float l = initDistance-distance;
                    //バネの変位量を力に変換
                    float N = l*PGain;

                    //振動子の時間発展
                    float dPhi = omega - (1/(1+N))*sin(2*phi); 
                    phi += dPhi;

                    //phiの範囲は -PI<phi<PI
                    if(phi > PI)  phi -= 2*PI;
                    if(phi < -PI) phi += 2*PI;

                    //phiによって高さの移動方向を決める
                    if(phi>-(PI/2) && phi<PI/2) dH = PrismaticMotorSpeed;
                    else dH = -PrismaticMotorSpeed;
                    
                    //高さの速度をセット
                    pj2.setMotorSpeed(dH);

            }
            
            //初期状態でのline1とline2のy座標の差を取得
            void setPos(){
                    float l = box2d.scalarPixelsToWorld(line1.body.getPosition().y)-box2d.scalarPixelsToWorld(line2.body.getPosition().y);
                    initDistance = l;
            }
            
            
            //直動ジョイントのモーターをONにする
            void SwitchMotor(){ 
                    pj2.enableMotor(true);//直動ジョイントをONにする  
            }
}
