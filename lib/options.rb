module Options
  # dizzy mode
  OPTIONS_MENU = ['Criar um atalho na área de trabalho (somente GNU/Linux)',
                  # 'Habilitar/desabilitar feedback sonoro',
                  # 'Habilitar/desabilitar formatação rica',
                  'Apagar tudo e recomeçar',
                  'Retornar']

  def options
    loop do
      $stdout.clear_screen

      puts '============================================================='

      OPTIONS_MENU.each_index { |index| puts "[#{index + 1}] - #{OPTIONS_MENU[index]}" }

      print 'Por favor selecione uma opção: '
      option = gets.chomp

      case option
      when '1' then create_desktop_shortcut
      # when '2' then puts 'Desculpe, funcionalidade não implementada.'# toggle beep()
      # when '3' then puts 'Desculpe, funcionalidade não implementada.'# toggle COLOR
      when '2' then TableFile.restart
      when '3' then return
      else puts 'Opção inválida. Por Favor tente novamente.'
      end

      any_key_to_continue

      $stdout.clear_screen
    end
  end

  private

  def create_desktop_shortcut
    application_directory = File.realdirpath("#{__dir__}/..")

    file = File.new("#{Dir.home}/Área de Trabalho/.desktop", 'w')

    file.write(<<~SHORTCUT)
               [Desktop Entry]
               Version = 0.9
               Name = Diário de Estudos
               Comment = Projeto da etapa de aquecimento do programa QSD2021
               Exec = #{application_directory}/"Diário de Estudos"
               Icon = #{application_directory}/icon.png
               Terminal = true
               Type = Application
    SHORTCUT

    file.chmod(0744)

    file.close

    puts 'Atalho criado. Pode ser necessário clicar com o botão direito do mouse e '\
         'selecionar "Permitir iniciar" ou algo semelhante.'
  end
end
