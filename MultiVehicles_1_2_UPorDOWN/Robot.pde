//Wheel(車輪)とline(リンク)を回転ジョイントで接続
//line(リンク)とBox(荷台)を直動ジョイントで接続する
//

class Robot{
            RevoluteJoint rj;
            DistanceJoint dj;
            PrismaticJoint pj;
            
            Wheel wheel;//車輪
            Line line;  //車輪と車体を繋ぐリンク
            Box nidai; //荷台
            
            //////////////////////////////////////////
            //----------------設定-----------------///
            //////////////////////////////////////////
            Robot(float x, float y){
                    //オブジェクトを作成
                    line    = new Line(x,y); //車輪と車体を繋ぐリンク
                    wheel   = new Wheel(x,y,WheelRadius);//車輪
                    nidai  = new Box(x,y-line.d,BodyWidth,BodyHeight);//車体              
                    
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
                     
                    
                    //直動ジョイントの定義
                    PrismaticJointDef pjd = new PrismaticJointDef();
                    //直動ジョイントの設定
                    Vec2 anchorLine = line.body.getWorldCenter(); //アンカーの座標をリンクの先にする．
                    Vec2 direction = box2d.vectorPixelsToWorld(PrismaticJointVector);//ボディの可動方向を決める．
                    pjd.initialize(line.body,nidai.body,anchorLine,direction);//引数は（接続元，接続先，接続先の接続点を示すVec2，可動方向を示すVec2）
                    //変形範囲
                    pjd.upperTranslation = box2d.scalarPixelsToWorld(line.d/2);
                    pjd.lowerTranslation = box2d.scalarPixelsToWorld(-line.d/2);
                    //プロパティ
                    pjd.motorSpeed = box2d.scalarPixelsToWorld(0);//可動方向へ動く速度
                    pjd.maxMotorForce = PrismaticJointForce;//可動方向へ押す力
                    pjd.enableLimit = true;//可動範囲を有効にするか 
                    pjd.enableMotor = true;//モーターをのON/OFF
                    
                    //ジョイントを作成
                    pj = (PrismaticJoint)box2d.world.createJoint(pjd);
                    
                     
            }
            
            //////////////////////////////////////////
            //----------------描画-----------------///
            //////////////////////////////////////////
            void display(){
                      float l = box2d.getBodyPixelCoord(wheel.body).y- box2d.getBodyPixelCoord(nidai.body).y;
                      wheel.display();
                      line.display(l);
                      nidai.display();
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
 
                    float y = box2d.getBodyPixelCoord(nidai.body).y;  //真ん中のロボットのy座標
                    
                    int counter = 0;
                    for (Robot robot : args) {
                            float difference  = y - box2d.getBodyPixelCoord(robot.nidai.body).y;
                            if( difference > 1) counter += 1;//真ん中より高ければ 1
                            else if (difference < -1)counter -= 1;//真ん中より低ければ -1
                            else counter += 0;
                    }
                    
                    //両隣が高ければ1
                    //両隣が低ければ-1
                    //両隣がばらばらなら0
                    if (counter > 0) counter = 1;
                    else if(counter < 0) counter = -1;
                    else counter = 0;

                    pj.setMotorSpeed(counter*MotorGain);    
            }
}
