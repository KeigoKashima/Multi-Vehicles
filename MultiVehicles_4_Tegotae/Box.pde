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
                fd.density = 0.1;
                fd.friction = Friction;
                fd.restitution = Restitution;
                
                //フィクスチャを使ってボディにシェイプをアタッチする．
                body.createFixture(fd);
        }
      
      
        //=========================描画================================///       
        void display() {
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
        void killBody() {
                box2d.destroyBody(body);
        }
}
