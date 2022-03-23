from flutter_api import Device as fd
import uiautomator2 as u2

if __name__ == '__main__':
    # U2建立连接
    d = u2.connect('ip')
    # flutter建立连接
    fd = fd.connect('ip')
    # 启动APP
    d.app_start("app_package_name")
    # 点击原生页面元素跳转到flutter页面
    d("XXX:id/edittext")
    # 根据ID获取元素操作点击
    fd.click_id_by_position(element_id='XXX', logtext='点击')
    # 根据ID直接点击
    fd.click_id('XX')
    # flutter页面输入123
    fd.set_text('XXX', '123')
    fd.assert_toast('保存成功')
    # 点击返回
    d.press("back")
    # 关闭
    fd.__close__()
    d.app_stop("XXX")
