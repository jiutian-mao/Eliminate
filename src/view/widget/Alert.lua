--1、通过注册固定优先级处理事件屏蔽底层控件:addEventListenerWithFixedPriority(listener,-999),并设置setSwallowTouches(true)
--2、设置setContentSize遮挡底层(需考虑坐标影响)
Alert = {}
function Alert:createAlert(node,titleName,okName,cancalName,contentName,title,content,okFunc,cancalFunc)
    local alert = ccui.Helper:seekWidgetByName(node,"alert");
    alert:getParent():removeChild(alert)
    local alertTitle = ccui.Helper:seekWidgetByName(alert,titleName)
    alertTitle:setText(title)
    
    local alertContent = ccui.Helper:seekWidgetByName(alert,contentName)
    alertContent:setText(content)

    local alertOk = ccui.Helper:seekWidgetByName(alert,okName)
    alertOk:addTouchEventListener(okFunc)
    
    local alertNo = ccui.Helper:seekWidgetByName(alert,cancalName)  
    alertNo:addTouchEventListener(cancalFunc)
    
    return alert
end

function Alert:show()
	
end 