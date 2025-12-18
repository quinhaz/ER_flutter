## er_proj

## 1. Pré-requisitos instalados

- [Flutter SDK](https://flutter.dev/docs/get-started/install)  
- [VSCode](https://code.visualstudio.com/)
- [Xampp](https://www.apachefriends.org/)

## 2. Instalação do Flutter no Windows

1. Download e config do Flutter SDK: (https://flutter.dev/docs/get-started/install/windows) - isto está super bem explicado
2. Extrai a pasta flutter para C:\Users\<teu-user>\flutter  
3. Para Windows, certifica-te de adicionar o Flutter ao PATH do sistema:
   
   > Nota: **isto é feito, apenas se o teu VS Code não te pediu para adicionar o Path**
   - *Win + S* → digita “Environment Variables” → *Editar variáveis de ambiente do sistema*  
   - Em *System Variables, encontra **Path* → *Editar* → *Novo* → adiciona:
     
     C:\Users\<teu-user>\flutter\bin
     
   - Confirma tudo e reinicia a Shell e o VSCode (to make sure que a versão do flutter está ok).

## 3. Clone do repo

- [GitHub](https://github.com/quinhaz/ER_flutter.git)
- Após ter o clone do git, é preciso mover os files da base de dados e conexões.
-    Os quais estarão na pasta db_xampp no projeto -> e isto tem de entrar na pasta do xampp e procurar htdocs (deverá estar em C:\xampp\htdocs).

## 4. Incialização do xampp:

1. Inicializar o Apache.
2. inicializar o MySQL.
3. Abrir o Admin do MySQL, criar a base de dados com nome "gri" e exportar a base de dados con nome "GRI_db.sql".

## 5. Testar instalação + dependências:

- Na shell:
-> flutter --version
-> flutter pub get

## 6. Have fun:

Para testar no terminal:

- flutter run -d windows.
- flutter run -d chrome (Preferivelmente utilizar o Chrome).

- Durante a execução, o Flutter permite interatividade no terminal:
  -> r → Hot reload
  -> R → Hot restart
  -> q → Sair da execução

## 7. Estrutura essencial do projeto
- ER_PROJ/
- ├─ db_xampp/            <-- base de dados, cujos files devem ser movidos para ..\xampp\htdocs
- ├─ lib/ main.dart       <-- entrada app e maioria do código


