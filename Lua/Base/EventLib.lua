-- 事件系统
local _table_insert = table.insert
local _pairs = pairs
local _xpcall = xpcall

EventLib = EventLib or BaseClass()

function EventLib:__init()
    self.handlers = nil
    self.args = nil
    self.handlerList = {}
end

function EventLib:__release()
    self:RemoveAll()
end

function EventLib:AddListener(handler)
    self:Add(handler)
end

function EventLib:AddOnceListener(handler)
    self:AddOnce(handler)
end

function EventLib:Add(handler)
    if self.handlers == nil then
        self.handlers = {}
    end
    for k,v in _pairs(self.handlers) do
        if v == handler then
            return
        end
    end
    _table_insert(self.handlers, handler)
end

function EventLib:RemoveListener(handler)
    self:Remove(handler)
end
function EventLib:Remove(handler)
    if not handler then
        self.handlers = nil
    else
        if self.handlers then
            for k, v in _pairs(self.handlers) do
                if v == handler then
                    self.handlers[k] = nil
                    return k
                end
            end
        end
    end
end

function EventLib:RemoveAll()
    self:Remove()
end

function EventLib:Fire(args1, args2, args3, args4, args5)
    if args5 ~= nil then
        pError("Fire目前不支持超过4个参数，需要在EventLib中调整")
    end
    if self.handlers then
        for _, func in _pairs(self.handlers) do
            local call = function() func(args1, args2, args3, args4) end
            _xpcall(call, function(errinfo)
                pError("EventLib:Fire出错了" .. tostring(errinfo).."\n"..debug.traceback())
            end)
        end
    end
end