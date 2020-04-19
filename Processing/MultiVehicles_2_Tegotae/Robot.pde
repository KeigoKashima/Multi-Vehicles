//Wheel(車輪)とline(リンク)を回転ジョイントで接続
//line(リンク)とBox(荷台)を直動ジョイントで接続する
//

class Robot{
            RevoluteJoint rj;
            DistanceJoint dj;
            PrismaticJoint pj;
            
            Wheel wheel;//車輪
            Line line;  //車輪と車体を繋ぐリンク
            Box shatai; //車体
            
            //////////////////////////////////////////
            //----------------設定-----------------///
            //////////////////////////////////////////
            Robot(float x, float y){
                    //オブジェクトを作成
                    line    = new Line(x,y); //車輪と車体を繋ぐリンク
                    wheel   = new Wheel(x,y,WheelRadius);//車輪
                    shatai  = new Box(x,y-line.d,BodyWidth,BodyHeight);//車体              
                    
                    //回転ジョイントの定義
                    RevoluteJointDef rjd = new RevoluteJointDef(); 
                    //回転ジョイントの設定
                    Vec2 anchor = wheel.body.getWorldCenter(); //アンカーの座標を車輪の中心にする．
                    rjd.initialize(line.body,wheel.body,anchor); //最初の二つの引数がボディ，３つ目がアンカーの座標
                    //プロパティを設定
                    //モーターのオンオフ
                    rjd.enableMotor = false; 
                    rjd.motorSpeed = -MotorSpeed;    //モーターの速度
                    rjd.maxMotorTorque = MotorTorque;//モーターの強度
                    //ジョイントを作成
                    rj = (RevoluteJoint) box2d.createJoint(rjd);
                     
                     
                    //ディスタンスジョイントの定義
                    DistanceJointDef djd = new DistanceJointDef();
                    //静止長を決定
                    djd.length = box2d.scalarPixelsToWorld(0);
                    //ディスタンスジョイントの設定
                    Vec2 anchorA = wheel.body.getWorldCenter().add(box2d.vectorPixelsToWorld(new Vec2(0,-line.d)));
                    Vec2 anchorB = shatai.body.getWorldCenter();
                    djd.initialize(line.body,shatai.body,anchorA,anchorB);
                    djd.frequencyHz = 1;
                    djd.dampingRatio = 0.5;
                    //ジョイントを作成
                    dj = (DistanceJoint)box2d.world.createJoint(djd);
                    
                    
                    //直動ジョイントの定義
                    PrismaticJointDef pjd = new PrismaticJointDef();
                    //直動ジョイントの設定
                    Vec2 anchorLine = shatai.body.getWorldCenter(); //アンカーの座標をリンクの先にする．
                    Vec2 direction = box2d.vectorPixelsToWorld(PrismaticJointVector);//ボディの可動方向を決める．
                    pjd.initialize(line.body,shatai.body,anchorLine,direction);//引数は（接続元，接続先，接続先の接続点を示すVec2，可動方向を示すVec2）
                    //変形範囲
                    pjd.upperTranslation = box2d.scalarPixelsToWorld(line.d/2);
                    pjd.lowerTranslation = box2d.scalarPixelsToWorld(-line.d/2);
                    //プロパティ
                    pjd.motorSpeed = box2d.scalarPixelsToWorld(0);//可動方向へ動く速度
                    pjd.maxMotorForce = PrismaticJointForce;//可動方向へ押す力
                    pjd.enableLimit = true;//可動範囲を有効にするか 
                    pjd.enableMotor = false;//モーターをのON/OFF
                    //ジョイントを作成
                    pj = (PrismaticJoint)box2d.world.createJoint(pjd);
            }
            
            //////////////////////////////////////////
            //----------------描画-----------------///
            //////////////////////////////////////////
            void display(){
                    float l = box2d.getBodyPixelCoord(wheel.body).y- box2d.getBodyPixelCoord(shatai.body).y;
                    wheel.display();
                    line.display(l);
                    shatai.display();
                    text("PrismaticJoint："+pj.isMotorEnabled(),10*width/20, 14*height/20);
            }
            
            //モーターをオンまたはオフに
            void toggleMotor(){
                      rj.enableMotor(!rj.isMotorEnabled());
            }
            boolean motorOn(){
                      return rj.isMotorEnabled();
            }
            
           
            //=========================高さを変える関数================================///
            //引数に入れたオブジェクトの車輪のy座標と車体の高さから自身の高さを更新する関数
            //引数にRobotオブジェクト
            void changeHeight(Robot...args) {      
                    float y = box2d.getBodyPixelCoord(shatai.body).y;  //真ん中のロボットのy座標
                    float distance = 0;
                    for (Robot robot : args) {
                            distance += box2d.getBodyPixelCoord(robot.shatai.body).y ; //周りの荷台のy座標を足していく
                    }
                    float sp = y-(y+distance)/(args.length+1);
                    
                    pj.setMotorSpeed(sp*MotorGain);    
            }
            
            void Tegotae(){ 
                    pj.enableMotor(true);//直動ジョイントをONにする
                    
            }
}
