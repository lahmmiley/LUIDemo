LScrollViewDemoItem1 = LScrollViewDemoItem1 or BaseClass(LItem)

function LScrollViewDemoItem1:__init()
    local transform = self.transform
    self.transform = transform
    self.text = transform:Find("Text"):GetComponent(Text)
    self.detailTrans = transform:Find("Detail")
end

function LScrollViewDemoItem1:__release()
    UtilsBase.CancelTween(self, "tweenId")
end

function LScrollViewDemoItem1:SetData(data, commonData)
    UtilsBase.CancelTween(self, "tweenId")
    self.data = data
    self.text.text = self.index
    if self.index == commonData then
        UtilsUI.SetHeight(self.transform, 150)
        self.detailTrans.gameObject:SetActive(true)
    else
        UtilsUI.SetHeight(self.transform, 100)
        self.detailTrans.gameObject:SetActive(false)
    end
end

function LScrollViewDemoItem1:PullDown()
    UtilsUI.SetY(self.detailTrans, -45)
    UtilsBase.CancelTween(self, "tweenId")
    self.tweenId = Tween.Instance:MoveLocalY(self.detailTrans.gameObject, -95, 0.5).id
end
