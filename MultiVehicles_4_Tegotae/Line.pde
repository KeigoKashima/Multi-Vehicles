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
                fd.density = 0.01;
                fd.friction = Friction;
                fd.restitution = Restitution;
                
                body.createFixture(fd);      
        }
        
        void display(float l, float c){
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
