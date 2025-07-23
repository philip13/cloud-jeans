module SvgHelper
  def svg(name, **attributes)
    markup = render(file: "#{Rails.root}/app/views/shared/svg/#{name}.svg")
    xml = Nokogiri::XML(markup)

    attributes&.each do |key, value|
      xml.root.set_attribute(key, value)
    end

    xml.root.to_xml.html_safe
  end
end
