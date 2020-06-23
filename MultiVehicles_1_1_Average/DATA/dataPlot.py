import matplotlib.pyplot as plt #matplotlib.pyplotをpltという名前でインポート
import numpy as np #numpyをnpという名前でインポート
import matplotlib.cm as cm

frequency = 3.0
amplitude = 5.0
j = 0
dispersion = [[]]*12
while frequency<24.0:
    
    #グラフの描画先の準備
    fig = plt.figure()

    fileName = 'F'+str(frequency)+'_A'+str(amplitude)
    #CSVファイル'temp_data.csv'の1列目float型で読み出し、タプルに変換しpointに代入
    step=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=0)

    height = [[]]*10
    for i in range(0,10):
    #CSVファイル'temp_data.csv'の2列目をfloat型で読み出し、リストlatitudeに代入
        height[i]=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=i+1)

    #CSVファイル'temp_data.csv'の3列目をfloat型で読み出し、リストsurfaceに代入
    surface=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=11)


    for i in range(0,10):
        plt.plot(step,height[i],linewidth='1',label = "Robot"+str(i))
    plt.plot(step,surface,linewidth='1',label = "Surface")
    

    # 分散を折れ線グラフで表示
    #CSVファイル'temp_data.csv'の3列目をfloat型で読み出し、リストdispersionに代入
    # dispersion[j]=np.loadtxt(fname=fileName+'.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=12)
    # # plt.plot(step,dispersion[j],linewidth=1,label=fileName,color=cm.hsv(j/12.0))
    # plt.legend() #凡例を表示
    


    plt.legend() #凡例を表示
    plt.title(fileName) #グラフタイトルを表示
    plt.xlabel("step") #X軸ラベルを表示
    plt.ylabel("height") #Y軸ラベルを表示
    # グラフをファイルに保存する
    fig.savefig(fileName+".png")

    frequency += 2.0
    j += 1

