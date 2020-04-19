
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
          void display(){
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
          void killBody(){
                    box2d.destroyBody(body);
          }
}
