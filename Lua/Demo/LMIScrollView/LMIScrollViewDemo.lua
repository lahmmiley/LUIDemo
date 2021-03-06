LMIScrollViewDemo = LMIScrollViewDemo or BaseClass(BaseDemo)

function LMIScrollViewDemo:__init(transform)
    local scrollView = LMIScrollView.New(transform:Find("Test1"), {LMIScrollViewDemoItem, LMIScrollViewDemoItem1, LMIScrollViewDemoItem2})
    scrollView:SetGap(5)
    scrollView.ItemSelectEvent:AddListener(function(index, item)
        scrollView:SetCommonData(index)
    end)
    self.scrollView = scrollView
    math.randomseed(os.time())
    local dataList = {}
    for i = 1, 100 do
        table.insert(dataList, {type = math.random(1, 3), data = i})
    end
    self.dataList = dataList
    transform:Find("Button1").gameObject:SetActive(true)
    UtilsUI.AddButtonListener(transform, "Button1", function()
        local index = math.random(1, 100)
        UtilsUI.GetText(transform, "Button1/Text").text = string.format("Focus(%s)", index)
        scrollView:Focus(index, true)
    end)
    transform:Find("Button2").gameObject:SetActive(true)
    UtilsUI.AddButtonListener(transform, "Button2", function()
        local length = math.random(1, 100)
        UtilsUI.GetText(transform, "Button2/Text").text = string.format("SetData(%s)", length)
        local dataList = {}
        for i = 1, length do
            table.insert(dataList, {type = math.random(1, 3), data = i})
        end
        scrollView:SetData(dataList)
    end)
end

function LMIScrollViewDemo:SetData()
    self.scrollView:SetData(self.dataList)
end
