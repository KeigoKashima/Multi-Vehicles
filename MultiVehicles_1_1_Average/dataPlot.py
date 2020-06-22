import matplotlib.pyplot as plt #matplotlib.pyplotをpltという名前でインポート
import numpy as np #numpyをnpという名前でインポート

name = 'F2.0_A30.0.csv'
#CSVファイル'temp_data.csv'の1列目float型で読み出し、タプルに変換しpointに代入
step=np.loadtxt(fname=name,dtype='float',delimiter=',',comments='#',skiprows=0,usecols=0)

height = [[]]*10
for i in range(0,10):
#CSVファイル'temp_data.csv'の2列目をfloat型で読み出し、リストlatitudeに代入
    height[i]=np.loadtxt(fname='F2.0_A30.0.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=i+1)

#CSVファイル'temp_data.csv'の3列目をfloat型で読み出し、リストsurfaceに代入
surface=np.loadtxt(fname='F2.0_A30.0.csv',dtype='float',delimiter=',',comments='#',skiprows=0,usecols=11)


for i in range(0,10):
    #各リスト、タプルの値を7回順番に読み出し、その値を元に緯度vs気温の散布図を描画。  
    plt.scatter(step,height[i],linewidths='0.1',marker=None,label = "Robot"+str(i))
plt.scatter(step,surface,linewidths='0.1',marker=None,label = "Surface")


plt.legend() #凡例を表示
plt.title(name) #グラフタイトルを表示
plt.xlabel("height") #X軸ラベルを表示
plt.ylabel("step") #Y軸ラベルを表示
plt.show() #プロットを表示