class JointTest{
        
        Box sensor;//sensor
        Box shatai; //車体
        
        JointTest(float x, float y){
          
                sensor  = new Box(x,y-40,10,10);//車輪
                shatai  = new Box(x,y,10,10);//車体  
                
                
                    
                //ディスタンスジョイントの定義
                DistanceJointDef djd = new DistanceJointDef();
                
                //ディスタンスジョイントの設定
                //Vec2 anchorA = sensor.body.getWorldCenter().add(box2d.vectorPixelsToWorld(new Vec2(0,-0)));
                //Vec2 anchorB = shatai.body.getWorldCenter();
                //djd.initialize(sensor.body,shatai.body,anchorA,anchorB);
                djd.bodyB = sensor.body;
                djd.bodyA = shatai.body;
                djd.length = box2d.scalarPixelsToWorld(30);
                djd.frequencyHz = 10;
                djd.dampingRatio = 1;
                djd.collideConnected = true;
                //ジョイントを作成
                DistanceJoint dj = (DistanceJoint)box2d.world.createJoint(djd);
                
                //直動ジョイントの定義
                PrismaticJointDef pjd = new PrismaticJointDef();
                //直動ジョイントの設定
                Vec2 anchorLine = shatai.body.getWorldCenter(); //アンカーの座標をリンクの先にする．
                Vec2 direction = box2d.vectorPixelsToWorld(PrismaticJointVector);//ボディの可動方向を決める．
                pjd.initialize(sensor.body,shatai.body,anchorLine,direction);//引数は（接続元，接続先，接続先の接続点を示すVec2，可動方向を示すVec2）
                
                //プロパティ
                pjd.motorSpeed = box2d.scalarPixelsToWorld(0);//可動方向へ動く速度
                pjd.maxMotorForce = PrismaticJointForce;//可動方向へ押す力
                pjd.enableLimit = false;//可動範囲を有効にするか 
                pjd.enableMotor = false;//モーターをのON/OFF
                //ジョイントを作成
                PrismaticJoint pj = (PrismaticJoint)box2d.world.createJoint(pjd);
  
                    
        }
        
        //////////////////////////////////////////
        //----------------描画-----------------///
        //////////////////////////////////////////
        void display(){
                
                sensor.display();
                
                shatai.display();
                
        }
        
        
        //
        float displacement(){
            float d = box2d.getBodyPixelCoord(sensor.body).y- box2d.getBodyPixelCoord(shatai.body).y;
            
            return d;
        }
            
        
        


}
