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
        
        void display(){
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
