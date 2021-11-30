# Diário de Estudos
Projeto da etapa de aquecimento do processo seletivo Quero Ser Dev 2021, da Locaweb.

## Antes de iniciar
Para executar o código, é necessário um interpretador de Ruby (vide seção compatibilidade para detalhes).

Em ambientes Unix-like, antes de executar o programa pela primeira vez, execute o arquivo `setup`, localizado dentro do diretório `bin`. Ele instalará as dependências necessárias, caso ainda não estejam instaladas. A senha de superusuário pode ser requisitada. Este programa utiliza a [gem SQLite 3/Ruby] (https://github.com/sparklemotion/sqlite3-ruby).

`$ bin/setup`


Não é necessário executar este procedimento mais de 1 vez.

## Execução
Com o ambiente preparado, execute o arquivo `Diário de Estudos`

`$ ./"Diário de Estudos"`

Na primeira vez em que o programa for executado, um diretório chamado `db` será criado. É nele em que a sessão do usuário será salva.

## Opções
É possível rolar a tela para cima para ver opções passadas.
<!-- talvez colocar 4# -->
### Cadastrar um item para estudar
O programa permite que sejam cadastrados itens diferentes que tenham o mesmo título; por exemplo, podem ser cadastrados os itens "Sintaxe" da categoria Ruby, e "Sintaxe" da categoria HTML.

É obrigatório que todo item de estudo tenha exatamente 1 categoria. Caso o usuário não defina uma categoria, será atribuída uma genérica (atualmente definida como "miscelânea").

Opcionalmente o usuário pode dar uma descrição ao item de estudo.

### Ver todos os itens não concluídos

### Buscar um item de estudo

### Listar por categoria

### Apagar um item
Itens com o título indicado serão apagados.

### Marcar um item como concluído
Itens com o título indicado serão marcados como concluído.

### Sair
Também é possível apertar Ctrl+C para interromper a execução do programa a qualquer momento.

## Remoção
Para remover este programa, basta deletar do computador o diretório em que o programa se encontra; lembrar de apagar o atalho da área de trabalho, caso tenha sido escolhido criá-lo.

A sessão é salva dentro do diretório 'db', que pode ser apagada caso o usuário deseje
apagar os dados salvos.

## Compatibilidade:
- Testado em Ubuntu 21.10.

- Testado com o interpretador de Ruby MRI versão 2.7.4. Pode funcionar com outras versões.

*projeto em evolução contínua*
