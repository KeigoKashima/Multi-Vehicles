import matplotlib.pyplot as plt #matplotlib.pyplotをpltという名前でインポート
import numpy as np #numpyをnpという名前でインポート
import matplotlib.cm as cm

frequency = 3.0
amplitude = 5.0
j = 0
dispersion = [[]]*12
#グラフの描画先の準備
fig = plt.figure()

while frequency<20.0:

    fileName = 'F'+str(frequency)+'_A'+str(amplitude)
    #CSVファイル'temp_data.csv'の1列目float型で読み出し、タプルに変換しpointに代入
    step=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=0)

    # 分散を折れ線グラフで表示
    # CSVファイルの12列目をfloat型で読み出し、リストdispersionに代入
    dispersion[j]=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=12)
    plt.plot(step,dispersion[j],linewidth=1,label=fileName,color=cm.hsv(j/12.0))
    plt.legend() #凡例を表示
    
    frequency += 2.0
    j += 1



plt.xlabel("step") #X軸ラベルを表示
plt.ylabel("dispersion") #Y軸ラベルを表示
# グラフをファイルに保存する
fig.savefig("dispersion.png")
plt.show()

