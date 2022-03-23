## 简介
BKFlutterUITest是一款轻量级的Flutter UI自动化测试框架，提供页面元素识别、点击、文字输入等基础API，通过FlutterDriver可操作页面元素，并且BKFlutterUITest可快速集成到任意原生（Android&iOS）UI自动化框架中，为混合型或纯flutter UI自动化提供便捷的能力。
详细原理可参考：https://mp.weixin.qq.com/s/htimPf_vt94i4Oz8H9_MQQ

## 环境：
python环境：python3
XX：

## 快速使用
### python侧：
安装依赖：pip install -r requirements.txt
1、连接设备：
    fd = fd.connect('ip')
2、根据ID获取元素操作点击
    fd.click_id_by_position(element_id='XXX', logtext='点击')
3、根据ID直接点击
    fd.click_id('XX')
4、输入文字
    fd.set_text('XXX', '123')
5、断言
    fd.assert_toast('保存成功')
6、关闭
    fd.__close__()

 上层操作API在python/下，可独立与客户端的flutter侧建立链接。与在原生UI自动化框架混合，需要要保持FlutterDirver持续建立链接。

### dart侧：

## 代码导读


## 联系方式



