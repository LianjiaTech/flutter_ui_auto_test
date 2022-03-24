（Android&iOS）UI自动化框架中，为混合型或纯flutter UI自动化提供便捷的能力。
详细原理可参考：[Flutter UI测试自动化原理与实践](https://mp.weixin.qq.com/s/htimPf_vt94i4Oz8H9_MQQ)

## 环境：
python环境：python3<br>
XX：

## 快速使用

### Dart测项目配置
1. 在Flutter工程的yaml文件中依赖本库
2. 在项目的main()函数入口增加启动FutService的代码，如下所示。

```dart
void main(){
	runApp(...);
	
	// 这个服务提供了自动化测试运行时的操作页面元素的能力
	// port：该服务占用系统端口号
	// 初始化至少要放在runApp()的后面
	// 如果App中有两个Flutter容器，port端口号也要不同
	FutService.initService(port: 1234);
}
```
> **注意：**本库提供的能力基于AspectD hook系统能力来实现，所以在项目中需要配置AspectD能力。使用见(https://github.com/LianjiaTech/Beike_AspectD)


### 获取页面元素

> 本项目中提供一个FutConfigPage的配置页面，这个页面可以开启flutter UI自动化测试获取元素ID的配置，可以在合适入口处打开。建议用Native能力写一个全局悬浮弹窗。

1. 执行python/flutter_weditor.py ，可在控制台查看到当前IP
2. 手机端从“悬浮窗”入口进入FutConfigPage配置页面
3. 将控制台IP输入，点击连接，此时即与Service端建立连接
4. 点击底部“开启”按钮，左下脚展示搜索图标，则代表开启
5. 点击返回，退出配置页面。点击搜索图标，再点击任意按钮，即可在PC端控制台查看到相关ID信息


### python侧：
安装依赖：pip install -r requirements.txt <br>

1. 连接设备：<br>`fd = fd.connect('ip')//ip为测试机IP地址`
2. 根据ID获取元素操作点击：<br>`fd.click_id_by_position(element_id='XXX', logtext='点击')`
3.  根据ID直接点击<br> `fd.click_id('XX')`
4.  输入文字<br>`fd.set_text('XXX', '123')`
5. 断言<br>`fd.assert_toast('保存成功')`
6. 关闭<br>`fd._close_()`
    

> 上层操作API在python/下，可独立与客户端的flutter侧建立链接。与在原生UI自动化框架混合，需要要保持FlutterDirver持续建立链接。




