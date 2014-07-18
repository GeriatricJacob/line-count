class Symbol
  def t(params = {})
    I18n.t(self, params)
  end
end

class String
  def t(params = {})
    I18n.t(self.to_s, params)
  end
end

class Time
  def l(params={})
    I18n.l(self, params)
  end
end

class DateTime
  def l(params={})
    I18n.l(self, params)
  end
end

class Date
  def l(params={})
    I18n.l(self, params)
  end
end

