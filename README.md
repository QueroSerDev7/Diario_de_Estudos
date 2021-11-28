# Diário de Estudos
Projeto da etapa de aquecimento do processo seletivo Quero Ser Dev 2021, da Locaweb.

## Antes de iniciar

Em ambientes UNIX-like, antes de executar o programa pela primeira vez, execute o arquivo `setup`, localizado dentro do diretório `bin`. Ele instalará as dependências necessárias, caso ainda não estejam instaladas. A senha de superusuário pode ser requisitada. Este programa utiliza a gem SQLite 3/Ruby [https://github.com/sparklemotion/sqlite3-ruby].

`$ bin/setup`


Será dada a opção ao usuário de criar um atalho na área de trabalho. Não é necessário executar este procedimento mais de 1 vez.

## Execução

Com o ambiente preparado, execute o arquivo `study_diary`

`$ ./study_diary`

Na primeira vez em que o programa for executado, um diretório chamado `db` será criado. É nele em que a sessão do usuário será salva.

## Opções

- Cadastrar um item para estudar

O programa permite que sejam cadastrados itens diferentes que tenham o mesmo título; por exemplo, podem ser cadastrados os itens "Sintaxe" da categoria Ruby, e "Sintaxe" da categoria HTML.

É obrigatório que todo item de estudo tenha exatamente 1 categoria. Caso o usuário não defina uma categoria, será atribuída uma genérica (atualmente definida como "miscelânea").

Opcionalmente o usuário pode dar uma descrição ao item de estudo.

- Ver todos os itens não concluídos

- Buscar um item de estudo

- Listar por categoria

- Apagar um item

Itens com o título indicado serão apagados.

- Marcar um item como concluído

- Sair

Também é possível apertar Ctrl+C para interromper a execução do programa a qualquer momento.

## Remoção

A sessão é salva dentro do diretório 'db'.

Para remover este programa, simplesmente delete, do seu computador, o diretório em que o programa se encontra; apague também o atalho da área de trabalho, caso tenha escolhido criá-lo.

## Compatibilidade:
Testado em ambiente GNU/Linux.

*projeto em evolução contínua*
