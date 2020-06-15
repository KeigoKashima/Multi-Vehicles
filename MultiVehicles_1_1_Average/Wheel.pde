// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
// A circular particle

class Wheel {
          
          Body body;
          float r; //車輪の半径
          Wheel(float x, float y, float r_) {
            
                    r = r_;
                    //ボディを定義
                    BodyDef bd = new BodyDef();
                    //ボディの位置を設定
                    bd.position = box2d.coordPixelsToWorld(x,y);
                    bd.type = BodyType.DYNAMIC;
                    body = box2d.world.createBody(bd);
                
                    //シェイプを円形にする
                    CircleShape cs = new CircleShape();
                    cs.m_radius = box2d.scalarPixelsToWorld(r);
                    
                    FixtureDef fd = new FixtureDef();
                    fd.shape = cs;
                    
                    //物理に影響与えるパラメータ
                    fd.density = 100;
                    fd.friction = Friction;
                    fd.restitution = Restitution;
                    
                    //ボディにフィクスチャーをアタッチ
                    body.createFixture(fd);
          }
          // Box2Dワールドからオブジェクトを除去する関数
          void killBody() {
                    box2d.destroyBody(body);
      }
      
      //スクリーン外ならボディを消してtrueを返す
      boolean done() {
            //ボディの位置を取得
            Vec2 pos = box2d.getBodyPixelCoord(body);
            //スクリーン外に出たか確認
            if (pos.y > height+r*2) {
                  killBody();
                  return true;
            }
            return false;
      }
    
      void display() {
            //各ボディの位置を取得
            Vec2 pos = box2d.getBodyPixelCoord(body);
            //角度も取得
            float a = body.getAngle();
            
            pushMatrix();
            translate(pos.x,pos.y);
            rotate(-a);
            fill(127);
            stroke(0);
            strokeWeight(2);
            ellipse(0,0,r*2,r*2);
            //回転が見えるように線を追加
            line(0,0,r,0);
            popMatrix();
      }


}
