LDemoItem = LDemoItem or BaseClass(LItem)

function LDemoItem:__init()
    local transform = self.transform
    self.transform = transform
    self.text = transform:Find("Text"):GetComponent(Text)
    local selectTrans = transform:Find("Select")
    if selectTrans then
        self.selectGo = selectTrans.gameObject
    end
    local imageTran = transform:Find("Image")
    if imageTran then
        self.IconClickEvent = EventLib.New()
        UtilsUI.AddButtonListener(transform, "Image", function()
            self.IconClickEvent:Fire(self.index)
        end)
    end
end

function LDemoItem:__release()
    GameObject.Destroy(self.transform.gameObject)
end

function LDemoItem:SetSelect(active)
    if self.selectGo then
        self.selectGo:SetActive(active)
    end
end

function LDemoItem:SetCommonData(commonData)
    self:SetSelect(commonData.selectIndex == self.index)
end

function LDemoItem:SetData(data, commonData)
    self.text.text = self.index
    local sizeType = commonData.sizeType
    self:SetSelect(self.index == commonData.selectIndex)
    if sizeType == TestDefine.SizeType.fix then
    elseif sizeType == TestDefine.SizeType.increase then
        local offset = math.floor((self.index - 1) / 2) * 2
        self.transform.sizeDelta = Vector2(50 + offset, 50 + offset)
    elseif sizeType == TestDefine.SizeType.decrease then
        local offset = math.floor((self.index - 1) / 2) * 2
        self.transform.sizeDelta = Vector2(100 - offset, 100 - offset)
    elseif sizeType == TestDefine.SizeType.specified then
        if self.index % 2 == 1 then
            self.transform.sizeDelta = Vector2(40, 50)
        else
            self.transform.sizeDelta = Vector2(40, 20)
        end
    elseif sizeType == TestDefine.SizeType.specified1 then
        local offset = 0
        if math.floor((self.index - 1) / 2) % 2 == 1 then
            offset = 0
        else
            offset = 30
        end
        self.transform.sizeDelta = Vector2(100, 100 - offset)
    elseif sizeType == TestDefine.SizeType.specified2 then
        if self.index % 2 == 1 then
            self.transform.sizeDelta = Vector2(20, 30)
        else
            self.transform.sizeDelta = Vector2(40, 30)
        end
    elseif sizeType == TestDefine.SizeType.specified3 then
        local row = math.floor((self.index - 1) / 3)
        if (row % 2) == 1 then
            self.transform.sizeDelta = Vector2(100, 50)
        else
            self.transform.sizeDelta = Vector2(70, 50)
        end
    elseif sizeType == TestDefine.SizeType.specified4 then
        local row = math.floor((self.index - 1) / 3)
        if (row % 2) == 1 then
            self.transform.sizeDelta = Vector2(100, 70)
        else
            self.transform.sizeDelta = Vector2(100, 50)
        end
    elseif sizeType == TestDefine.SizeType.specified5 then
        if self.index <= 6 then
            self.transform.sizeDelta = Vector2(50, 50)
        else
            self.transform.sizeDelta = Vector2(100, 50)
        end
    end
end
