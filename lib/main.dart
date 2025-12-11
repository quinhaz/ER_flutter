// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(repository: InMemoryRepository()),
    child: const GRIApp(),
  ));
}

/*
  GRIApp - Entrypoint
*/
class GRIApp extends StatelessWidget {
  const GRIApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GRI - Gestão de Registos da Igreja',
      theme: ThemeData(useMaterial3: true),
      home: const MainShell(),
    );
  }
}

/* ------------------------------
   Domain models
   ------------------------------ */
enum Role { Padre, Administracao, Fiel, Voluntario, Gestao }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final Role role;

  User({required this.id, required this.name, required this.email, required this.password, required this.role});
}

enum CelebrationType { Batismo, Casamento, Obito }

class Celebration {
  final String id;
  final CelebrationType type;
  final DateTime date;
  final String details;
  String? signedByUserId;
  DateTime? signedAt;

  Celebration({
    required this.id,
    required this.type,
    required this.date,
    required this.details,
    this.signedByUserId,
    this.signedAt,
  });

  bool get isSigned => signedByUserId != null;
}

enum FeeStatus { Pendente, Pago }

class Document {
  final String id;
  final String celebrationId;
  final String ownerUserId; // Fiel
  final String type; // e.g., "Certidão de Batismo"
  final double feeAmount;
  FeeStatus feeStatus;
  String? fileContent; // simulated PDF content

  Document({
    required this.id,
    required this.celebrationId,
    required this.ownerUserId,
    required this.type,
    required this.feeAmount,
    this.feeStatus = FeeStatus.Pendente,
    this.fileContent,
  });

  bool get available => feeStatus == FeeStatus.Pago;
}

/* ------------------------------
   Repository interface + In-memory impl
   ------------------------------ */
abstract class Repository {
  // users
  Future<User?> findUserByEmail(String email);
  Future<User> createUser(String name, String email, String password, Role role);
  Future<User?> getUserById(String id);

  // celebrations
  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details);
  Future<void> signCelebration(String celebrationId, String padreUserId);
  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to);
  Future<List<Celebration>> getAllCelebrations();

  // documents & fees
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee);
  Future<List<Document>> getDocumentsForUser(String userId);
  Future<Document?> getDocumentById(String docId);
  Future<void> markFeePaid(String documentId);
}

class InMemoryRepository implements Repository {
  final List<User> _users = [];
  final List<Celebration> _celebrations = [];
  final List<Document> _documents = [];

  InMemoryRepository() {
    // seed: an admin and a padre for quicker testing
    _users.addAll([
      User(id: 'u_admin', name: 'Admin Local', email: 'admin@gri.local', password: 'admin123', role: Role.Administracao),
      User(id: 'u_padre', name: 'Padre José', email: 'padre@gri.local', password: 'padre123', role: Role.Padre),
      User(id: 'u_fiel', name: 'Fiel Maria', email: 'fiel@gri.local', password: 'fiel123', role: Role.Fiel),
    ]);
    // seed a celebration and a document for the fiel to show flows
    var c = Celebration(
      id: _nextId('c'),
      type: CelebrationType.Batismo,
      date: DateTime.now().subtract(const Duration(days: 40)),
      details: 'Batismo de João',
      signedByUserId: 'u_padre',
      signedAt: DateTime.now().subtract(const Duration(days: 39)),
    );
    _celebrations.add(c);
    _documents.add(Document(
      id: _nextId('d'),
      celebrationId: c.id,
      ownerUserId: 'u_fiel',
      type: 'Certidão de Batismo',
      feeAmount: 10.0,
      feeStatus: FeeStatus.Pendente,
      fileContent: 'CERTIDAO-BATISMO-JOAO (conteudo simulado)',
    ));
  }

  String _nextId(String prefix) => '$prefix-${Random().nextInt(100000)}';

  @override
  Future<User?> findUserByEmail(String email) async {
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User> createUser(String name, String email, String password, Role role) async {
    if (_users.any((u) => u.email == email)) {
      throw Exception('Email already registered');
    }
    var u = User(id: _nextId('u'), name: name, email: email, password: password, role: role);
    _users.add(u);
    return u;
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details) async {
    var c = Celebration(id: _nextId('c'), type: type, date: date, details: details);
    _celebrations.add(c);
    return c;
  }

  @override
  Future<void> signCelebration(String celebrationId, String padreUserId) async {
    var c = _celebrations.firstWhere((e) => e.id == celebrationId, orElse: () => throw Exception('celebration not found'));
    c.signedByUserId = padreUserId;
    c.signedAt = DateTime.now();
    // create official document for owner(s) if there are associated owners - for this demo, we do not auto-associate owners
  }

  @override
  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to) async {
    return _celebrations.where((c) => !c.date.isBefore(from) && !c.date.isAfter(to)).toList();
  }

  @override
  Future<List<Celebration>> getAllCelebrations() async => List.from(_celebrations);

  @override
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee) async {
    var doc = Document(id: _nextId('d'), celebrationId: celebrationId, ownerUserId: ownerUserId, type: docType, feeAmount: fee, feeStatus: FeeStatus.Pendente, fileContent: null);
    _documents.add(doc);
    return doc;
  }

  @override
  Future<List<Document>> getDocumentsForUser(String userId) async {
    return _documents.where((d) => d.ownerUserId == userId).toList();
  }

  @override
  Future<Document?> getDocumentById(String docId) async {
    try {
      return _documents.firstWhere((d) => d.id == docId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> markFeePaid(String documentId) async {
    var d = _documents.firstWhere((x) => x.id == documentId, orElse: () => throw Exception('document not found'));
    d.feeStatus = FeeStatus.Pago;
    // unlock the file content (simulate generation)
    d.fileContent ??= 'PDF-${d.type}-${d.id} (conteúdo simulado). Emitido em ${DateTime.now()}';
  }
}

/* ------------------------------
   AppState (provider)
   ------------------------------ */
class AppState extends ChangeNotifier {
  final Repository repository;
  User? _currentUser;
  AppState({required this.repository});

  User? get currentUser => _currentUser;
  bool get loggedIn => _currentUser != null;

  Future<void> register(String name, String email, String password, Role role) async {
    var user = await repository.createUser(name, email, password, role);
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    var user = await repository.findUserByEmail(email);
    if (user == null) return false;
    if (user.password != password) return false;
    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // celebrations
  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details) => repository.createCelebration(type, date, details);

  Future<void> signCelebration(String celebrationId) async {
    if (_currentUser == null || _currentUser!.role != Role.Padre) {
      throw Exception('Apenas Padre pode assinar');
    }
    await repository.signCelebration(celebrationId, _currentUser!.id);
    notifyListeners();
  }

  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to) => repository.searchCelebrations(from, to);
  Future<List<Celebration>> getAllCelebrations() => repository.getAllCelebrations();

  // documents & fees
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee) {
    return repository.createDocumentForCelebration(celebrationId, ownerUserId, docType, fee);
  }

  Future<List<Document>> getDocumentsForUser(String userId) => repository.getDocumentsForUser(userId);
  Future<Document?> getDocumentById(String docId) => repository.getDocumentById(docId);

  Future<void> payFee(String documentId) async {
    // Simulate payment processing (in real life call gateway)
    await repository.markFeePaid(documentId);
    notifyListeners();
  }
}

/* ------------------------------
   UI Shell + NavigationRail (similar pattern ao exemplo)
   ------------------------------ */

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const LoginPage(),
      const RegisterPage(),
      const PadrePanelPage(),
      const SearchCelebrationsPage(),
      const DocumentsPage(),
      const PaymentsPage(),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('GRI - Gestão de Registos'),
          actions: [
            Consumer<AppState>(builder: (context, s, _) {
              if (!s.loggedIn) return const SizedBox.shrink();
              return Row(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('${s.currentUser!.name} (${s.currentUser!.role.name})'),
                ),
                TextButton(
                  onPressed: () {
                    s.logout();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sessão terminada')));
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ]);
            })
          ],
        ),
        body: Row(children: [
          SafeArea(
              child: NavigationRail(
            extended: constraints.maxWidth >= 700,
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => setState(() => selectedIndex = i),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.login), label: Text('Login')),
              NavigationRailDestination(icon: Icon(Icons.person_add), label: Text('Registar')),
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Painel Padre')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Pesquisar')),
              NavigationRailDestination(icon: Icon(Icons.folder), label: Text('Documentos')),
              NavigationRailDestination(icon: Icon(Icons.payment), label: Text('Pagamentos')),
            ],
          )),
          Expanded(child: Container(color: Colors.grey.shade100, child: pages[selectedIndex]))
        ]),
      );
    });
  }
}

/* ------------------------------
   Pages
   ------------------------------ */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context, listen: false);
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                var ok = await app.login(_email.text.trim(), _password.text);
                setState(() => _loading = false);
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciais inválidas')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login efetuado')));
                }
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            const Text('Contas de teste: admin@gri.local / admin123, padre@gri.local / padre123, fiel@gri.local / fiel123', style: TextStyle(fontSize: 12)),
          ])),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  Role _role = Role.Fiel;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context, listen: false);
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(width: 520, child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Registo de Utilizador', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 8),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Perfil: '),
              const SizedBox(width: 12),
              DropdownButton<Role>(
                value: _role,
                items: Role.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
                onChanged: (v) => setState(() { if (v != null) _role = v; }),
              )
            ]),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                try {
                  await app.register(_name.text.trim(), _email.text.trim(), _password.text, _role);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registo e login OK')));
                } catch (ex) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                } finally {
                  setState(() => _loading = false);
                }
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Registar e Entrar'),
            )
          ])),
        ),
      ),
    );
  }
}

/* Padre panel: criação e assinatura de celebrações */
class PadrePanelPage extends StatefulWidget {
  const PadrePanelPage({super.key});
  @override
  State<PadrePanelPage> createState() => _PadrePanelPageState();
}
class _PadrePanelPageState extends State<PadrePanelPage> {
  final _details = TextEditingController();
  CelebrationType _type = CelebrationType.Batismo;
  DateTime _date = DateTime.now();
  bool _loading = false;
  List<Celebration> _list = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    var s = Provider.of<AppState>(context, listen: false);
    var list = await s.getAllCelebrations();
    setState(() => _list = list);
  }

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context);
    if (!app.loggedIn || app.currentUser!.role != Role.Padre) {
      return const Center(child: Text('Área restrita a utilizadores com o perfil Padre.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('Criar Registo de Celebração', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                const Text('Tipo:'),
                const SizedBox(width: 12),
                DropdownButton<CelebrationType>(
                  value: _type,
                  items: CelebrationType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                  onChanged: (v) => setState(() { if (v != null) _type = v; }),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () async {
                    var picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(1900), lastDate: DateTime(2100));
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: Text('Data: ${_date.toLocal().toString().split(' ')[0]}'),
                )
              ]),
              const SizedBox(height: 8),
              TextField(controller: _details, decoration: const InputDecoration(labelText: 'Detalhes da celebração')),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : () async {
                  setState(() => _loading = true);
                  try {
                    var c = await app.createCelebration(_type, _date, _details.text.trim());
                    // opcional: criar automaticamente documento associado para um fiel (no mundo real associar o fiel)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Celebração criada (aguarda assinatura)')));
                    _details.clear();
                    await _loadAll();
                  } catch (ex) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                  } finally {
                    setState(() => _loading = false);
                  }
                },
                child: _loading ? const CircularProgressIndicator() : const Text('Criar'),
              )
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Celebrações (todas)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (c, i) {
                      var e = _list[i];
                      return ListTile(
                        title: Text('${e.type.name} — ${e.date.toLocal().toString().split(' ')[0]}'),
                        subtitle: Text(e.details + (e.isSigned ? '\nAssinado por: ${e.signedByUserId} em ${e.signedAt}' : '\nNão assinado')),
                        isThreeLine: true,
                        trailing: e.isSigned ? null : ElevatedButton(
                          onPressed: () async {
                            try {
                              await app.signCelebration(e.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assinatura registada')));
                              await _loadAll();
                            } catch (ex) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                            }
                          },
                          child: const Text('Assinar'),
                        ),
                      );
                    }
                  ),
                )
              ]),
            ),
          ),
        )
      ]),
    );
  }
}

/* Pesquisa de celebrações por intervalo de datas (RF11) */
class SearchCelebrationsPage extends StatefulWidget {
  const SearchCelebrationsPage({super.key});
  @override
  State<SearchCelebrationsPage> createState() => _SearchCelebrationsPageState();
}
class _SearchCelebrationsPageState extends State<SearchCelebrationsPage> {
  DateTime _from = DateTime.now().subtract(const Duration(days: 365));
  DateTime _to = DateTime.now().add(const Duration(days: 365));
  List<Celebration> _result = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              TextButton(onPressed: () async {
                var p = await showDatePicker(context: context, initialDate: _from, firstDate: DateTime(1900), lastDate: DateTime(2100));
                if (p != null) setState(() => _from = p);
              }, child: Text('From: ${_from.toLocal().toString().split(' ')[0]}')),
              const SizedBox(width: 12),
              TextButton(onPressed: () async {
                var p = await showDatePicker(context: context, initialDate: _to, firstDate: DateTime(1900), lastDate: DateTime(2100));
                if (p != null) setState(() => _to = p);
              }, child: Text('To: ${_to.toLocal().toString().split(' ')[0]}')),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                _result = await app.searchCelebrations(_from, _to);
                setState(() => _loading = false);
              }, child: const Text('Pesquisar')),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _loading ? const Center(child: CircularProgressIndicator()) : _result.isEmpty ? const Center(child: Text('Nenhuma celebração encontrada')) :
              ListView.builder(itemCount: _result.length, itemBuilder: (c, i) {
                var e = _result[i];
                return ListTile(title: Text('${e.type.name} — ${e.date.toLocal().toString().split(' ')[0]}'), subtitle: Text(e.details + (e.isSigned ? '\nAssinado' : '\nNão assinado')));
              }),
            ),
          ),
        )
      ]),
    );
  }
}

/* Documentos do fiel (RF29, RF32, RF35): lista, acesso condicionado por taxa */
class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});
  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}
class _DocumentsPageState extends State<DocumentsPage> {
  List<Document> _docs = [];
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    var app = Provider.of<AppState>(context, listen: false);
    if (!app.loggedIn) {
      _docs = [];
    } else {
      _docs = await app.getDocumentsForUser(app.currentUser!.id);
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context);
    if (!app.loggedIn || app.currentUser!.role != Role.Fiel) {
      return const Center(child: Text('Área reservada a utilizadores com perfil Fiel.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton(onPressed: _load, child: const Text('Atualizar')),
        const SizedBox(height: 12),
        _loading ? const CircularProgressIndicator() : Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _docs.isEmpty ? const Center(child: Text('Não tem documentos')) :
              ListView.builder(itemCount: _docs.length, itemBuilder: (c, i) {
                var d = _docs[i];
                return ListTile(
                  title: Text(d.type),
                  subtitle: Text('Taxa: €${d.feeAmount.toStringAsFixed(2)} — Estado: ${d.feeStatus.name}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      if (d.available) {
                        // show document
                        await showDialog(context: context, builder: (_) => AlertDialog(
                          title: Text(d.type),
                          content: Text(d.fileContent ?? 'Ficheiro ainda não gerado.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
                        ));
                      } else {
                        // blocked: inform message per RF35
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Documento disponível apenas após pagamento da taxa.')));
                      }
                    },
                    child: const Text('Abrir'),
                  ),
                );
              }),
            ),
          ),
        )
      ]),
    );
  }
}

/* Pagamentos (RF33, RF34) - lista documentos pendentes e permite pagar (simulado) */
class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});
  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}
class _PaymentsPageState extends State<PaymentsPage> {
  List<Document> _pending = [];
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    var app = Provider.of<AppState>(context, listen: false);
    if (!app.loggedIn) {
      _pending = [];
    } else {
      var all = await app.getDocumentsForUser(app.currentUser!.id);
      _pending = all.where((d) => d.feeStatus == FeeStatus.Pendente).toList();
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    var app = Provider.of<AppState>(context);
    if (!app.loggedIn || app.currentUser!.role != Role.Fiel) {
      return const Center(child: Text('Área reservada a utilizadores com perfil Fiel.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton(onPressed: _load, child: const Text('Ver pendentes')),
        const SizedBox(height: 12),
        _loading ? const CircularProgressIndicator() :
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _pending.isEmpty ? const Center(child: Text('Sem pagamentos pendentes')) :
              ListView.builder(itemCount: _pending.length, itemBuilder: (c, i) {
                var d = _pending[i];
                return ListTile(
                  title: Text(d.type),
                  subtitle: Text('Montante: €${d.feeAmount.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      // Simulate payment flow
                      bool confirmed = await showDialog(context: context, builder: (_) => AlertDialog(
                        title: const Text('Confirmar Pagamento'),
                        content: Text('Pagar €${d.feeAmount.toStringAsFixed(2)} para ${d.type}? (simulado)'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Pagar')),
                        ],
                      )) ?? false;
                      if (!confirmed) return;
                      try {
                        await app.payFee(d.id);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento confirmado — documento desbloqueado')));
                        await _load();
                      } catch (ex) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                      }
                    },
                    child: const Text('Pagar'),
                  ),
                );
              }),
            ),
          ),
        )
      ]),
    );
  }
}
