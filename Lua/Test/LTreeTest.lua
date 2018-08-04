LTreeTest = LTreeTest or BaseClass(BaseTest)

LTreeTest.Config = {
    {
        name = "总共",
        dataList =
        {
            {name = "滚动组件",
            dataList =
                {
                    {name = "LScrollView",
                    dataList =
                        {
                            {name = "测试1"},
                        }
                    },
                    {name = "LScrollView"},
                    {name = "LScrollView"},
                }
            },
            {name = "固定组件",
            dataList =
                {
                    {name = "LList"}
                }
            },
        }
    },
}

function LTreeTest:__init(gameObject)
    local transform = gameObject.transform
    for i = 1, #LTreeTest.Config do
        local config = LTreeTest.Config[i]
        pError("New")
        local tree = LTree.New(transform:Find("Test" .. i), LTreeNode)
        pError("New End")
        -- tree:SetGap(config.gapHorizontal, config.gapVertical)
        -- tree:SetPadding(config.paddingLeft, config.paddingRight, config.paddingTop, config.paddingBottom)
        tree:SetData(config.dataList)
    end
end