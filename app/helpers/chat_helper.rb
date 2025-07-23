module ChatHelper
  def whatsapp_message_to_html(text)
    html = text.dup
    
    # Convertir **texto** a <strong>texto</strong>
    html.gsub!(/\*\*(.*?)\*\*/, '<strong>\1</strong>')
    
    # Convertir *texto* a <em>texto</em> (pero no al inicio de línea para listas)
    html.gsub!(/(?<!^|\n)\*(.*?)\*/, '<em>\1</em>')
    
    # Convertir emojis a su representación HTML (opcional)
    html.gsub!(/😉/, '&#x1F609;')
    html.gsub!(/😊/, '&#x1F60A;')
    
    # Convertir listas
    lines = html.split("\n")
    processed_lines = []
    in_list = false
    
    lines.each do |line|
      if line.strip.start_with?('*   ')
        unless in_list
          processed_lines << '<ul class="list-unstyled mb-2">'
          in_list = true
        end
        content = line.strip.sub(/^\*\s+/, '')
        processed_lines << "<li class=\"mb-1\">#{content}</li>"
      else
        if in_list
          processed_lines << '</ul>'
          in_list = false
        end
        processed_lines << line unless line.strip.empty?
      end
    end
    
    # Cerrar lista si quedó abierta
    processed_lines << '</ul>' if in_list
    
    # Unir y convertir saltos de línea restantes
    html = processed_lines.join("\n")
    html.gsub!(/\n(?!<)/, '<br>')
    
    html.html_safe
  end
end
