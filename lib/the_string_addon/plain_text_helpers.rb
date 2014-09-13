class String
  def noendl
    self.gsub("\n", '')
  end

  def endl2br
    self.gsub("\n", "<br />")
  end
end
