## er_proj

## 1. Pré-requisitos instalados

- [Flutter SDK](https://flutter.dev/docs/get-started/install)  
- [VSCode](https://code.visualstudio.com/)
- [Git](https://git-scm.com/downloads) (convém)

## 2. Instalação do Flutter no Windows

1. Download e config do Flutter SDK: (https://flutter.dev/docs/get-started/install/windows) - isto está super bem explicado
2. Extrai a pasta `flutter` para `C:\Users\<teu-user>\flutter`  
3. > Para Windows, certifica-te de adicionar o Flutter ao PATH do sistema:
   - **Win + S** → digita “Environment Variables” → **Editar variáveis de ambiente do sistema**  
   - Em **System Variables**, encontre **Path** → **Editar** → **Novo** → adiciona:
     ```
     C:\Users\<teu-user>\flutter\bin
     ```
   - Confirma tudo e reinicia a Shell e o VSCode (to make sure que a versão do flutter está ok).

## 3. Clone do repo

## 4. Testar instalação + dependências:

# Na shell:
flutter --version
flutter pub get

## 5. Have fun:

Para testar online:
- https://dartpad.dev/

- 

flutter run -d windows
flutter run -d chrome

- Durante a execução, o Flutter permite interatividade no terminal:
  -> r → Hot reload
  -> R → Hot restart
  -> q → Sair da execução

## 6. Estrutura do projeto
lib/
├─ main.dart       <-- entrada app e maioria do código
├─ pages/          <-- telas
├─ widgets/        <-- widgets reutilizáveis
├─ models/         <-- classes data
├─ services/       <-- lógica e APIs

## 7. Commits
