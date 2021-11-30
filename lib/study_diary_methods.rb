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
               when 0 then 'Não foi encontrado nenhum item'
               when 1 then 'Foi encontrado 1 item'
               else "Foram encontrados #{size} itens"
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

  def boolean?(variable)
    variable == !!variable
  end

  def any_key_to_continue
    puts '', 'Pressione qualquer tecla para continuar'

    $stdin.getch(intr: true)

    # Gets will absorb extraneous characters coming from getch, if any.
    # It occurs for example when the user presses the Page Up key, or the arrow keys.
    $stdin.raw(min: 0, time: 0.001, intr: true) { gets }
  end
end
