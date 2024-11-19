# Meu projeto de teste de linguagens de programação

[For the English version click here](./README_EN.md)

Esse repositório contém a implementação do meu projeto de teste para linguagens de programação.

> **OBS:** Estou migrando/reescrevendo as implementações nas linguagens que já domino, pois perdi essas implementações com o passar dos anos.

### Lista de linguagens que já implementei esse projeto:

1. Python (em migração)  
2. Java (em migração)  
3. Go (em migração)  
4. JavaScript* (em migração)  
5. TypeScript* (em migração)  
6. V (em migração)  
7. Rust (em migração)  
8. Lua (em migração)  
9. Zig  

\* Eu considero JavaScript e TypeScript como linguagens diferentes, pois, embora TypeScript seja um superset de JavaScript, o DX é substancialmente diferente.

### Lista de linguagens que eu sei, mas **não** implementei esse projeto:

1. Bash  
2. C*  
3. NASM*  

\* NASM e C são linguagens muito de baixo nível. Embora eu consiga implementar esse projeto nelas, não vejo necessidade. Se o fizer, será apenas para "exibir" minhas capacidades de desenvolvimento.

## Descrição do Projeto

### Um programa de biblioteca

Um programa de biblioteca (de filmes, livros etc.; o conteúdo não importa) com as seguintes características:

- **CRUD** com: Criar, Remover, Editar/Atualizar, Pesquisar, Exibir, Tela de Ajuda e Sair.  
- Usar **Tipos de Dados Abstratos (TDAs)** para representar os dados (Livros, Usuários, etc.). Esses TDAs geralmente são structs, classes, etc. Utilize o TDA apropriado para a linguagem de escolha.  
- Uma interface **CLI/TUI.**  
- Uma flag de comando para habilitar uma **REST API.**  
- **Criptografia, autenticação de usuários e permissões/hierarquia de usuários.**  
- Geração de identificadores únicos, como UUIDs.  
- Dados estruturados como uma **árvore** (binária ou não) ou outra estrutura de dados.  
- Dados armazenados em um banco de dados (preferencialmente SQL).  
- Um programa **multithreaded e escalável**, com a seguinte estrutura:
  - Uma thread para o programa principal, escalável para suportar múltiplas entradas simultâneas.  
  - Uma thread para a interface CLI/TUI (apelidada de sessão).  
  - Uma thread para a REST API (apelidada de sessão).  
  - Uma thread para um servidor HTTP, responsável pela renderização de páginas web responsivas e interativas que se comunicam com a REST API, realizando fetchs síncronos e assíncronos (basicamente um web server para desenvolvimento web).  
  - O programa deve suportar **múltiplas sessões simultâneas**, como 3 sessões CLI e 5 sessões REST. Cada sessão deve ter sua própria thread.  
  - Sair de uma sessão finaliza apenas sua interface; o servidor principal continua rodando, exceto se existir somente uma sessão. Nesse caso, o programa deve perguntar ou esperar um parâmetro para finalizar o servidor principal.  
  - As operações do CRUD devem ter uma **ordem de precedência**, da menos computacionalmente custosa para a mais custosa, com as menos custosas tendo prioridade.  
  - As threads do programa devem implementar pelo menos **DOIS modos de comunicação interprocessual (IPC):** memória compartilhada e envio de mensagens (como RPC). A comunicação entre o servidor e as sessões deve ser feita via mensagens, enquanto a comunicação interna do servidor deve ser feita via memória compartilhada, implicando em um design modular para o servidor.  
- O programa deve ser preferencialmente definido em **múltiplos arquivos**, para testar modularidade e compartimentação de código.  
- Utilize **somente** a biblioteca padrão da linguagem de escolha e aproveite ao máximo os recursos disponíveis (ponteiros, referências, etc.) e os tipos (enums, structs, interfaces, etc.).  
- O programa deve ser **tolerante a erros**, identificando e processando problemas, além de fornecer mensagens significativas ao usuário. Deve implementar as práticas recomendadas da linguagem escolhida.  

O programa deve ser bem documentado, com comentários, e seguir as boas práticas e padrões da linguagem de escolha.

### Qual o objetivo?

Esse é um projeto que testa todas as capacidades da linguagem, não apenas casos específicos como "é possível fazer IA?". Ele avalia escalabilidade, estruturas de dados, criptografia, e várias outras áreas. Tento usar o mínimo de frameworks e bibliotecas externas para isso, assim consigo entender em quais áreas e pontos a linguagem é forte (web-dev, back-end, processamento de dados, etc.) e em quais não é (multithreading, etc.). 

Acabo utilizando todos os recursos que a linguagem oferece, da forma que ela espera, e avalio se: a filosofia, a forma de execução e a **experiência de desenvolvimento** (DX) como um todo são agradáveis.
