return {
  new = (function()
    do
      local _class_0
      local _base_0 = {
        update = function() end,
        draw = function() end
      }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function(self, ui, content)
          self.ui, self.content = ui, content
          self.button = self.ui.bar.button('PRESS ME', function()
            return error('YOU PRESSED ME!')
          end)
          self.button = self.ui.bar.button('NOT PRESS ME', function()
            return error('YOU PRESSED ME OLOLO!')
          end)
        end,
        __base = _base_0,
        __name = nil
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      return _class_0
    end
  end)(),
  name = '',
  description = 'Нужно определить созведздие и назвать каждую звезду своим именем.\nНажмите на звезду, чтобы выбрать её имя.',
  tips = {
    ''
  }
}
