module StudyDiaryMethods
  def print_results_message(size, mode:)
    puts '', case mode
             when SEARCH
               case size
               when 0 then 'Não foi encontrado nenhum item'
               when 1 then 'Foi encontrado 1 item'
               else "Foram encontrados #{size} itens"
               end
             when LIST_BY_CATEGORY
               case size
               when 0 then 'Não foi encontrado nenhum item da categoria escolhida'
               when 1 then 'Foi encontrado 1 item da categoria escolhida'
               else "Foram encontrados #{size} itens da categoria escolhida"
               end
             when DELETE
               case size
               when 0 then 'Não foi encontrado nenhum item com o título indicado. Nenhum item apagado.'
               when 1 then 'Foi apagado 1 item'
               else "Foram apagados #{size} itens"
               end
             when MARK_AS_CONCLUDED
               case size
               when 0 then 'Não foi encontrado nenhum item com o título indicado'
               when 1 then 'Foi encontrado e marcado como concluído 1 item'
               else "Foram encontrados e marcados como concluídos #{size} itens"
               end
             when VIEW_CONCLUDED
               case size
               when 0 then 'Não há atualmente nenhum item marcado como concluído'
               when 1 then 'Há atualmente um total de 1 item marcado como concluído'
               else "Há atualmente um total de #{size} itens marcados como concluídos"
               end
             else ''
             end

    puts '' unless size == 0
  end

  def print_items(items, show_index:, show_description:, show_category:)
    items.each_index do |index|
      print "##{index + 1} - " if show_index
      print "#{items[index].title}"
      print " - #{items[index].category_name}" if show_category
      print " - #{items[index].description}" if show_description && items[index].description?
      puts ''
    end
  end
end
