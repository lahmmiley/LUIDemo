LSIScrollViewTest = LSIScrollViewTest or BaseClass(BaseTest)

LSIScrollViewTest.Config = {
    -- {column = 1, dataLength = 10, sizeType = TestDefine.SizeType.fix},
    -- {column = 1, dataLength = 20, gapVertical = 4, sizeType = TestDefine.SizeType.fix},
    -- {column = 1, dataLength = 20, paddingTop = 10, sizeType = TestDefine.SizeType.specified},
    -- {column = 2, dataLength = 19, sizeType = TestDefine.SizeType.fix},
    -- {column = 2, dataLength = 40, startIndex = 3, gapVertical = 10, gapHorizontal = 10, sizeType = TestDefine.SizeType.decrease},
    -- {column = 4, dataLength = 10000, startIndex = 1000, gapVertical = 10, gapHorizontal = 10, paddingLeft = 5, paddingRight = 20, paddingTop = 40, paddingBottom = 50, sizeType = TestDefine.SizeType.fix},
    -- {column = 2, dataLength = 19, startIndex = 11, gapVertical = 30, gapHorizontal = 20, paddingLeft = 40, paddingRight = 40, paddingTop = 40, paddingBottom = 40, sizeType = TestDefine.SizeType.specified1},
    -- {row = 1, dataLength = 28, gapHorizontal = 10, paddingTop = 20, sizeType = TestDefine.SizeType.specified2},
    -- {row = 2, dataLength = 20, startIndex = 4, gapHorizontal = 10, paddingLeft = 40, paddingRight = 40, paddingTop = 40, paddingBottom = 40, sizeType = TestDefine.SizeType.decrease},
    -- {row = 2, dataLength = 20, startIndex = 4, gapHorizontal = 10, paddingLeft = 40, paddingRight = 40, paddingTop = 40, paddingBottom = 40, sizeType = TestDefine.SizeType.fix},
    {column = 2, dataLength = 20, bottomData = 40, sizeType = TestDefine.SizeType.fix},
    -- {column = 2, dataLength = 20, sizeType = TestDefine.SizeType.fix},
}

function LSIScrollViewTest:__init(gameObject)
    local transform = gameObject.transform
    -- local scrollView = LScrollView.New(transform:Find("Test0"), LTestItem, 1, 2)
    -- scrollView:SetData()
    -- local scrollView = LScrollView.New(transform:Find("Test01"), LTestItem, 3, 4)
    -- scrollView:SetData({})
    for i = 1, #LSIScrollViewTest.Config do
        local config = LSIScrollViewTest.Config[i]
        -- local scrollView = LSIScrollView.New(transform:Find("Test" .. i), LTestItem, config.row, config.column)
        local scrollView = LSIScrollView.New(transform:Find("Test11"), LTestItem, config.row, config.column)
        scrollView:SetGap(config.gapHorizontal, config.gapVertical)
        scrollView:SetPadding(config.paddingLeft, config.paddingRight, config.paddingTop, config.paddingBottom)
        -- if config.startIndex then
        --     scrollView:SetStartIndex(config.startIndex)
        -- end
        if config.bottomData then
            local once = true
            scrollView.ReachBottomEvent:AddListener(function()
                if once then
                    once = false
                    scrollView:SetData(self:CreateDataList(config.bottomData), {sizeType = config.sizeType})
                end
            end)
        end
        scrollView:SetData(self:CreateDataList(config.dataLength), {sizeType = config.sizeType})
        if i == 12 then
            local button = transform:Find("Button12"):GetComponent(Button).onClick:AddListener(function()
                local randomValue = math.random(0, 100)
                scrollView:SetData(self:CreateDataList(randomValue), {sizeType = config.sizeType})
            end)
        end
    end
end
