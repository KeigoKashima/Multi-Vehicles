//////////////////////////////////////////
//////////////////////////////////////////
void keyPressed() {
        //モーターのオンオフを切り替える
        if (key == 'm') { 
                for (Robot car: cars) {
                        car.toggleMotor();   
                }  
        }
        
        //初期位置を取得する
         if (key == 'p') { 
                for (Robot car: cars) {
                        car.setPos();   
                }  
        }
        
        //一時停止
        if (key == 'x'){
                noLoop();
        } 
        //再開
        if (key == 's'){
                loop();
        }         
        //終了
        if (key == 'w') {
                exit();
        }
        
}
