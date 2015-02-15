Element = class("Sprite",function(parameters)
	local spr = cc.Node:create()
    return spr
end)

Element.col = nil;
Element.row = nil;
Element.type = nil;
Element.curTag = nil
Element.prevTag = nil

Element.WIDTH = 60
Element.HEIGHT = 60

Element.TAG_NORMAL = 10
Element.TAG_SPECIAL = 20
Element.TAG_MATCH = 30
Element.TAG_SELECT = 40
Element.TAG_DESTROY = 50

function Element:create(col,row,type)
    local continer = Element.new(col,row,type)
    return continer
end

function Element:ctor(col,row,type)
    self.col = col
    self.row = row
    self.type = type
    self:gotoAndStop(Element.TAG_NORMAL)
    self:setCascadeOpacityEnabled(true)
end

--跳转到指定帧
function Element:gotoAndStop(tag)
    self.prevTag = self.curTag
    local spr = nil
    if self:getChildByTag(tag) == nil then--没有则创建
        spr = cc.Sprite:createWithSpriteFrameName("icon"..(tag+self.type)..".png")
        spr:setTag(tag)
        self:addChild(spr)
    else 
        spr = self:getChildByTag(tag)
    end
    self.curTag = tag
    --隐藏标签外元素
    local children = self:getChildren()
    for i=1,#children do
        children[i]:setVisible(false)
    end
    self:hideTips()
    spr:setVisible(true)
end

function Element:showTips()
    local hide = cc.FadeTo:create(0.6,100)
    local show = cc.FadeIn:create(1)
    local seq = cc.Sequence:create(hide,show)
    local rep = cc.Repeat:create(seq,2)
    rep:setTag(TAG_TIPS)
    self:runAction(rep)
end

function Element:hideTips()
    --还原
    self:setOpacity(255)
    self:stopActionByTag(TAG_TIPS)
end

return Element