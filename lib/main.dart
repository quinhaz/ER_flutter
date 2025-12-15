// imports, theme, helpers, domain models

import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(repository: MySQLRepository()),
    child: const GRIApp(),
  ));
}


//THEME & APP

class GRIApp extends StatelessWidget {
  const GRIApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GRI - Sistema Digital de Gestão de Registos da Igreja',
      debugShowCheckedModeBanner: false,
      theme: _buildGRITheme(),
      home: const MainShell(),
    );
  }

  ThemeData _buildGRITheme() {
    // Cores inspiradas no contexto eclesiástico
    const Color primaryColor = Color.fromARGB(255, 142, 46, 135);
    const Color secondaryColor = Color.fromARGB(255, 162, 84, 135);
    const Color accentColor = Color.fromARGB(255, 166, 50, 125);
    const Color backgroundColor = Color(0xFFF8F5F0);
    const Color surfaceColor = Color(0xFFFFFFFF);
    const Color errorColor = Color(0xFFC41E3A);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE8F5E9),
        onPrimaryContainer: Color(0xFF1B5E20),
        secondary: secondaryColor,
        onSecondary: Colors.black,
        secondaryContainer: Color(0xFFFFF8E1),
        onSecondaryContainer: Color.fromARGB(255, 166, 50, 125),
        tertiary: accentColor,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFFFF3E0),
        onTertiaryContainer: Color(0xFF5D4037),
        error: errorColor,
        onError: Colors.white,
        background: backgroundColor,
        onBackground: Color(0xFF1C1C1C),
        surface: surfaceColor,
        onSurface: Color(0xFF1C1C1C),
        surfaceVariant: Color(0xFFF5F5F5),
        onSurfaceVariant: Color(0xFF757575),
        outline: Color(0xFFBDBDBD),
        outlineVariant: Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar temática
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Times New Roman',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // Cards com bordas suaves e sombra sutil
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        color: surfaceColor,
        margin: const EdgeInsets.all(8),
        shadowColor: primaryColor.withOpacity(0.1),
      ),
      
      // Input fields elegantes
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
      ),
      
      // Botões com design consistente
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Tipografia apropriada para o contexto
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryColor,
          fontFamily: 'Georgia',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: primaryColor,
          fontFamily: 'Georgia',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1C),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1C1C),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF333333),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF555555),
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Ícones tema
      iconTheme: IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 20,
      ),
      
      // ListTile mais elegante
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        iconColor: primaryColor,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1C1C1C),
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      
      // Progress indicator temático
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: primaryColor.withOpacity(0.2),
        color: secondaryColor,
        circularTrackColor: primaryColor.withOpacity(0.2),
      ),
      
      // SnackBar com cores apropriadas
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
      
      // Dialog com design elegante
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}

//DOMAIN MODELS

enum Role { Padre, Administracao, Fiel, Voluntario, Gestao }

extension RoleExt on Role {
  String get label {
    switch (this) {
      case Role.Padre:
        return 'Padre';
      case Role.Administracao:
        return 'Administração';
      case Role.Fiel:
        return 'Fiel';
      case Role.Voluntario:
        return 'Voluntário';
      case Role.Gestao:
        return 'Gestão';
    }
  }
  IconData get icon {
    switch (this) {
      case Role.Padre:
        return Icons.church;
      case Role.Administracao:
        return Icons.admin_panel_settings;
      case Role.Fiel:
        return Icons.person;
      case Role.Voluntario:
        return Icons.volunteer_activism;
      case Role.Gestao:
        return Icons.account_balance_wallet;
    }
  }
  Color get color {
    switch (this) {
      case Role.Padre:
        return Color(0xFF2C5530);
      case Role.Administracao:
        return Color(0xFF1565C0);
      case Role.Fiel:
        return Color(0xFF6A1B9A);
      case Role.Voluntario:
        return Color(0xFFF57C00);
      case Role.Gestao:
        return Color(0xFFC62828);
    }
  }
}

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
  final DateTime date;        // data da celebração
  final String details;
  final String ownerUserId;   // fiel associado (titular)

  // Batismo-especifico
  String? nomeBatizado;
  String? pai;
  String? mae;
  String? padrinho1;
  String? padrinho2;
  DateTime? dataNascimento;

  // Casamento-especifico
  String? conjugeUserId; // id do outro fiel
  String? testemunha1;
  String? testemunha2;

  // Óbito-especifico
  String? nomeFalecido;
  DateTime? dataNascimentoFalecido;
  DateTime? dataObito;
  String? localSepultura;

  String? signedByUserId;
  DateTime? signedAt;

  Celebration({
    required this.id,
    required this.type,
    required this.date,
    required this.details,
    required this.ownerUserId,
    this.nomeBatizado,
    this.pai,
    this.mae,
    this.padrinho1,
    this.padrinho2,
    this.dataNascimento,
    this.conjugeUserId,
    this.testemunha1,
    this.testemunha2,
    this.nomeFalecido,
    this.dataNascimentoFalecido,
    this.dataObito,
    this.localSepultura,
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
  final String type;        // ex: Certidão de Batismo
  final double feeAmount;
  FeeStatus feeStatus;
  String? fileContent;
  DateTime? generatedAt;
  String? paymentMethod;
  DateTime? paymentDate;

  // link para celebração original ao renderizar (definido na criação)
  Celebration? originalCelebration;

  Document({
    required this.id,
    required this.celebrationId,
    required this.ownerUserId,
    required this.type,
    required this.feeAmount,
    this.feeStatus = FeeStatus.Pendente,
    this.fileContent,
    this.generatedAt,
    this.paymentMethod,
    this.paymentDate,
    this.originalCelebration,
  });

  bool get available => feeStatus == FeeStatus.Pago;
}

// utilitariios
String fmtDate(DateTime? d) => d == null ? '-' : d.toIso8601String().split('T').first;

String shortId(String id) => id.split('-').last;

// repository (in-memory) and methods
abstract class Repository {
  Future<User?> findUserByEmail(String email);
  Future<User> createUser(String name, String email, String password, Role role);
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);

  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details, String ownerUserId, Map<String, dynamic> extraFields);
  Future<void> signCelebration(String celebrationId, String padreUserId);
  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to);
  Future<List<Celebration>> getAllCelebrations();

  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee);
  Future<List<Document>> getDocumentsForUser(String userId, Role role);
  Future<Document?> getDocumentById(String docId);
  Future<void> markFeePaid(String documentId, String method);
  Future<List<Document>> getPendingDocumentsForUser(String userId);
}

class MySQLRepository implements Repository {
  // We keep local copies to make the app fast, but we load them from the server
  List<User> _users = [];
  List<Celebration> _celebrations = [];
  List<Document> _documents = [];
  
  // ⚠️ CHANGE THIS IP: 
  // Use '10.0.2.2' if using Android Emulator
  // Use your PC's IP (e.g., '192.168.1.5') if using a real phone
  final String apiUrl = "http://10.0.2.2/db_connect.php"; 

  // This method triggers the download
  Future<void> initData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 1. Parse Users
        _users = (data['users'] as List).map((json) {
          return User(
            id: json['id'].toString(),
            name: json['name'],
            email: json['email'],
            password: json['password'],
            role: _parseRole(json['role']), // Helper method below
          );
        }).toList();

        // 2. Parse Celebrations
        _celebrations = (data['celebrations'] as List).map((json) {
          return Celebration(
            id: json['id'].toString(),
            type: _parseCelebType(json['type']),
            date: DateTime.parse(json['date']),
            details: json['details'] ?? '',
            ownerUserId: json['owner_user_id'].toString(), // Check your DB column name!
            // Map specific fields based on columns in your DB
            nomeBatizado: json['nome_batizado'],
            nomeFalecido: json['nome_falecido'],
            // ... Add other fields here matching your PHP JSON keys
          );
        }).toList();

        // 3. Parse Documents
        _documents = (data['documents'] as List).map((json) {
          return Document(
            id: json['id'].toString(),
            celebrationId: json['celebration_id'].toString(),
            ownerUserId: json['owner_user_id'].toString(),
            type: json['type'],
            feeAmount: double.tryParse(json['fee_amount'].toString()) ?? 0.0,
            feeStatus: json['fee_status'] == 'Pago' ? FeeStatus.Pago : FeeStatus.Pendente,
          );
        }).toList();

        print("Data loaded successfully!");
      }
    } catch (e) {
      print("Error connecting to Database: $e");
    }
  }

  // Helper to convert String to Enum
  Role _parseRole(String roleStr) {
    return Role.values.firstWhere(
      (e) => e.toString().split('.').last == roleStr, 
      orElse: () => Role.Fiel
    );
  }
  
  CelebrationType _parseCelebType(String typeStr) {
    return CelebrationType.values.firstWhere(
      (e) => e.name == typeStr, 
      orElse: () => CelebrationType.Batismo
    );
  }

  // --- STANDARD REPOSITORY METHODS (Same as InMemory but simpler) ---

  @override
  Future<User?> findUserByEmail(String email) async {
    // In a real app, you would ask the server again, but for now check the loaded list
    try { return _users.firstWhere((u) => u.email == email); } catch (_) { return null; }
  }

  @override
  Future<List<User>> getAllUsers() async => _users;

  @override
  Future<List<Celebration>> getAllCelebrations() async => _celebrations;

  // For methods that WRITE data (Create, Update), you must send a POST request to PHP
  // For now, we will update the local list so the UI updates, 
  // but you need to write a PHP script to save it permanently.
  @override
  Future<User> createUser(String name, String email, String password, Role role) async {
    // TODO: Send POST request to PHP to insert user
    final u = User(id: DateTime.now().toString(), name: name, email: email, password: password, role: role);
    _users.add(u);
    return u;
  }

  @override
  Future<Celebration> createCelebration(
    CelebrationType type, 
    DateTime date, 
    String details, 
    String ownerUserId, 
    Map<String, dynamic> extraFields
) async {
  
  final url = Uri.parse("http://127.0.0.1/create_celebration.php"); 

  // --- SAFE BODY CREATION ---
  // We check if the dates exist. If they do, we turn them into Strings.
  final Map<String, dynamic> body = {
    'type': type.name,
    'date': date.toIso8601String(),
    'details': details,
    'ownerUserId': ownerUserId,
    
    // String fields are safe to pass directly
    'nomeBatizado': extraFields['nomeBatizado'],
    'pai': extraFields['pai'],
    'mae': extraFields['mae'],
    'padrinho1': extraFields['padrinho1'],
    'padrinho2': extraFields['padrinho2'],
    'conjugeUserId': extraFields['conjugeUserId'],
    'testemunha1': extraFields['testemunha1'],
    'testemunha2': extraFields['testemunha2'],
    'nomeFalecido': extraFields['nomeFalecido'],
    'localSepultura': extraFields['localSepultura'],

    // DATE FIELDS MUST BE CONVERTED TO STRING (Check for null first)
    'dataNascimento': extraFields['dataNascimento']?.toIso8601String(),
    'dataNascimentoFalecido': extraFields['dataNascimentoFalecido']?.toIso8601String(),
    'dataObito': extraFields['dataObito']?.toIso8601String(),
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body), // Now this won't crash!
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final newId = responseData['id'].toString();
      
      final newCelebration = Celebration(
        id: newId,
        type: type,
        date: date,
        details: details,
        ownerUserId: ownerUserId,
        // For the local object, we CAN keep the original DateTime objects
        nomeBatizado: extraFields['nomeBatizado'],
        pai: extraFields['pai'],
        mae: extraFields['mae'],
        padrinho1: extraFields['padrinho1'],
        padrinho2: extraFields['padrinho2'],
        dataNascimento: extraFields['dataNascimento'], 
        conjugeUserId: extraFields['conjugeUserId'],
        testemunha1: extraFields['testemunha1'],
        testemunha2: extraFields['testemunha2'],
        nomeFalecido: extraFields['nomeFalecido'],
        dataNascimentoFalecido: extraFields['dataNascimentoFalecido'],
        dataObito: extraFields['dataObito'],
        localSepultura: extraFields['localSepultura'],
      );

      _celebrations.add(newCelebration);
      return newCelebration;
    } else {
      throw Exception(responseData['message'] ?? "Server error");
    }
  } catch (e) {
    throw Exception("Failed to create celebration: $e");
  }
}
  
  @override
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee) async {
      throw UnimplementedError();
  }

  @override
  Future<Document?> getDocumentById(String docId) async => null;

  @override
  Future<List<Document>> getDocumentsForUser(String userId, Role role) async => _documents;

  @override
  Future<List<Document>> getPendingDocumentsForUser(String userId) async => [];

  @override
  Future<User?> getUserById(String id) async => null;

  @override
  Future<void> markFeePaid(String documentId, String method) async {}

  @override
  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to) async => [];

  @override
  Future<void> signCelebration(String celebrationId, String padreUserId) async {}
}
/*class InMemoryRepository implements Repository {
  final List<User> _users = [];
  final List<Celebration> _celebrations = [];
  final List<Document> _documents = [];

  
  InMemoryRepository() {
    // seed users
    _users.addAll([
      User(id: 'u_admin', name: 'Admin Local', email: 'admin@gri.local', password: 'admin123', role: Role.Administracao),
      User(id: 'u_padre', name: 'Padre José', email: 'padre@gri.local', password: 'padre123', role: Role.Padre),
      User(id: 'u_fiel', name: 'Maria Silva', email: 'maria@gri.local', password: 'fiel123', role: Role.Fiel),
      User(id: 'u_fiel2', name: 'João Pereira', email: 'joao@gri.local', password: 'fiel123', role: Role.Fiel),
    ]);

    // celebração para a Maria (assinada) e o seu doc pendente
    final c1 = Celebration(
      id: _nextId('c'),
      type: CelebrationType.Batismo,
      date: DateTime.now().subtract(const Duration(days: 40)),
      details: 'Batismo do João (associado a Maria)',
      ownerUserId: 'u_fiel',
      nomeBatizado: 'João',
      pai: 'Carlos Silva',
      mae: 'Ana Silva',
      padrinho1: 'Pedro',
      padrinho2: 'Sofia',
      dataNascimento: DateTime.now().subtract(const Duration(days: 3000)),
      signedByUserId: 'u_padre',
      signedAt: DateTime.now().subtract(const Duration(days: 39)),
    );
    _celebrations.add(c1);

    _documents.add(Document(
      id: _nextId('d'),
      celebrationId: c1.id,
      ownerUserId: c1.ownerUserId,
      type: 'Certidão de Batismo',
      feeAmount: 10.0,
      feeStatus: FeeStatus.Pendente,
      originalCelebration: c1,
    ));
  }

  String _nextId(String prefix) => '$prefix-${Random().nextInt(100000)}';

  // Users
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
    if (_users.any((u) => u.email == email)) throw Exception('Email already registered');
    final u = User(id: _nextId('u'), name: name, email: email, password: password, role: role);
    _users.add(u);
    return u;
  }

  @override
  Future<List<User>> getAllUsers() async => List.from(_users);

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  // Celebrations
  @override
  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details, String ownerUserId, Map<String, dynamic> extraFields) async {
    final c = Celebration(
      id: _nextId('c'),
      type: type,
      date: date,
      details: details,
      ownerUserId: ownerUserId,
    );

    // apply extra fields depending on type
    if (type == CelebrationType.Batismo) {
      c.nomeBatizado = extraFields['nomeBatizado'] as String?;
      c.pai = extraFields['pai'] as String?;
      c.mae = extraFields['mae'] as String?;
      c.padrinho1 = extraFields['padrinho1'] as String?;
      c.padrinho2 = extraFields['padrinho2'] as String?;
      c.dataNascimento = extraFields['dataNascimento'] as DateTime?;
    } else if (type == CelebrationType.Casamento) {
      c.conjugeUserId = extraFields['conjugeUserId'] as String?;
      c.testemunha1 = extraFields['testemunha1'] as String?;
      c.testemunha2 = extraFields['testemunha2'] as String?;
    } else if (type == CelebrationType.Obito) {
      c.nomeFalecido = extraFields['nomeFalecido'] as String?;
      c.dataNascimentoFalecido = extraFields['dataNascimentoFalecido'] as DateTime?;
      c.dataObito = extraFields['dataObito'] as DateTime?;
      c.localSepultura = extraFields['localSepultura'] as String?;
    }

    _celebrations.add(c);
    return c;
  }

  @override
  Future<void> signCelebration(String celebrationId, String padreUserId) async {
    final idx = _celebrations.indexWhere((c) => c.id == celebrationId);
    if (idx == -1) throw Exception('Celebration not found');
    final c = _celebrations[idx];
    if (c.isSigned) throw Exception('Already signed');
    c.signedByUserId = padreUserId;
    c.signedAt = DateTime.now();

    // auto-gen um docs para o owner (se ele não existir)
    final exists = _documents.where((d) => d.celebrationId == c.id && d.ownerUserId == c.ownerUserId).toList();
    if (exists.isEmpty) {
      final doc = Document(
        id: _nextId('d'),
        celebrationId: c.id,
        ownerUserId: c.ownerUserId,
        type: _docTypeForCelebration(c.type),
        feeAmount: 10.0,
        feeStatus: FeeStatus.Pendente,
        originalCelebration: c,
      );
      _documents.add(doc);
    }
  }

  static String _docTypeForCelebration(CelebrationType t) {
    switch (t) {
      case CelebrationType.Batismo:
        return 'Certidão de Batismo';
      case CelebrationType.Casamento:
        return 'Certidão de Casamento';
      case CelebrationType.Obito:
        return 'Certidão de Óbito';
    }
  }

  @override
  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to) async {
    return _celebrations.where((c) => !c.date.isBefore(from) && !c.date.isAfter(to)).toList();
  }

  @override
  Future<List<Celebration>> getAllCelebrations() async => List.from(_celebrations);

  // Documentos
  @override
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee) async {
    final doc = Document(
      id: _nextId('d'),
      celebrationId: celebrationId,
      ownerUserId: ownerUserId,
      type: docType,
      feeAmount: fee,
      feeStatus: FeeStatus.Pendente,
      originalCelebration: _celebrations.firstWhere((c) => c.id == celebrationId, orElse: () => throw Exception('celebration not found')),
    );
    _documents.add(doc);
    return doc;
  }

  @override
  Future<List<Document>> getDocumentsForUser(String userId, Role role) async {
    if (role == Role.Padre || role == Role.Administracao) {
      return List.from(_documents);
    }
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
  Future<void> markFeePaid(String documentId, String method) async {
    final idx = _documents.indexWhere((d) => d.id == documentId);
    if (idx == -1) throw Exception('document not found');
    final d = _documents[idx];
    d.feeStatus = FeeStatus.Pago;
    d.paymentMethod = method;
    d.paymentDate = DateTime.now();
    d.generatedAt ??= DateTime.now();
    d.fileContent ??= 'PDF - ${d.type} - ${d.id} - Emitido em ${DateTime.now()}';
  }

  @override
  Future<List<Document>> getPendingDocumentsForUser(String userId) async {
    return _documents.where((d) => d.ownerUserId == userId && d.feeStatus == FeeStatus.Pendente).toList();
  }
}*/

// AppState (Provider) and Shell + navigation
class AppState extends ChangeNotifier {
  final Repository repository;
  User? _currentUser;

  AppState({required this.repository}){_init();}

  Future<void> _init() async {
    if (repository is MySQLRepository) {
      await (repository as MySQLRepository).initData();
      notifyListeners(); // Refresh UI once data arrives
    }
  }

  User? get currentUser => _currentUser;
  bool get loggedIn => _currentUser != null;

  Future<void> register(String name, String email, String password, Role role) async {
    final user = await repository.createUser(name, email, password, role);
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final user = await repository.findUserByEmail(email);
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

  Future<List<User>> getAllUsers() => repository.getAllUsers();

  // celebrações
  Future<Celebration> createCelebration(CelebrationType type, DateTime date, String details, String ownerUserId, Map<String, dynamic> extraFields) =>
      repository.createCelebration(type, date, details, ownerUserId, extraFields);

  Future<void> signCelebration(String celebrationId) async {
    if (_currentUser == null || _currentUser!.role != Role.Padre) throw Exception('Apenas Padre pode assinar');
    await repository.signCelebration(celebrationId, _currentUser!.id);
    notifyListeners();
  }

  Future<List<Celebration>> searchCelebrations(DateTime from, DateTime to) => repository.searchCelebrations(from, to);
  Future<List<Celebration>> getAllCelebrations() => repository.getAllCelebrations();

  // documentos & pagamentos
  Future<Document> createDocumentForCelebration(String celebrationId, String ownerUserId, String docType, double fee) =>
      repository.createDocumentForCelebration(celebrationId, ownerUserId, docType, fee);

  Future<List<Document>> getDocumentsForUser(String userId) => repository.getDocumentsForUser(userId, _currentUser?.role ?? Role.Fiel);

  Future<Document?> getDocumentById(String docId) => repository.getDocumentById(docId);

  Future<void> payFee(String documentId, String method) async {
    await repository.markFeePaid(documentId, method);
    notifyListeners();
  }

  Future<List<Document>> getPendingDocumentsForUser(String userId) => repository.getPendingDocumentsForUser(userId);
}


// MAIN SHELL (Navigation)

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;
  final pages = const [
    LoginPage(),
    RegisterPage(),
    PadrePanelPage(),
    SearchCelebrationsPage(),
    DocumentsPage(),
    PaymentsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: const Text('GRI — Gestão de Registos da Igreja'),
        actions: [
          Consumer<AppState>(builder: (context, s, _) {
            if (!s.loggedIn) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(s.currentUser!.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(s.currentUser!.role.label, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonal(
                    onPressed: () {
                      s.logout();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sessão terminada')));
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: isWide,
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => setState(() => selectedIndex = i),
            labelType: isWide ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.login), label: Text('Login')),
              NavigationRailDestination(icon: Icon(Icons.person_add), label: Text('Registar')),
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Painel Padre')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Pesquisar')),
              NavigationRailDestination(icon: Icon(Icons.folder), label: Text('Documentos')),
              NavigationRailDestination(icon: Icon(Icons.payment), label: Text('Pagamentos')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Container(
                key: ValueKey<int>(selectedIndex),
                padding: const EdgeInsets.all(20),
                child: pages[selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PAGES: Login & Register
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final app = Provider.of<AppState>(context, listen: false);

    final ok = await app.login(_email.text.trim(), _pass.text);
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Login efetuado' : 'Credenciais inválidas')));
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: RawKeyboardListener(
                focusNode: _focusNode,
                onKey: (event) {
                  if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) { // (com Enter submit)
                    if (!_loading) _submit();
                  }
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    children: [
                      Icon(Icons.church, size: 36, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      const Text('Acesso ao GRI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v == null || v.isEmpty ? 'Email obrigatório' : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pass,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Password obrigatória' : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: _loading ? null : _submit,
                        child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Entrar'),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Contas de teste:', style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  const SizedBox(height: 6),
                  const Text('admin@gri.local / admin123  •  padre@gri.local / padre123  •  maria@gri.local / fiel123', style: TextStyle(fontSize: 12)),
                ]),
              ),
            ),
          ),
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
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  Role _role = Role.Fiel;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Icon(Icons.person_add, size: 36, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  const Text('Criar conta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (v) => v == null || v.isEmpty ? 'Nome obrigatório' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v == null || v.isEmpty ? 'Email obrigatório' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) => v == null || v.isEmpty ? 'Password obrigatória' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Role>(
                  value: _role,
                  decoration: const InputDecoration(labelText: 'Perfil'),
                  items: Role.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
                  onChanged: (v) => setState(() { if (v != null) _role = v; }),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _loading ? null : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _loading = true);
                        try {
                          await app.register(_name.text.trim(), _email.text.trim(), _pass.text, _role);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registo efetuado e sessão iniciada')));
                        } catch (ex) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                        } finally {
                          setState(() => _loading = false);
                        }
                      },
                      child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Registar e Entrar'),
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// Padre panel + display detalhe helpers
class PadrePanelPage extends StatefulWidget {
  const PadrePanelPage({super.key});
  @override
  State<PadrePanelPage> createState() => _PadrePanelPageState();
}
class _PadrePanelPageState extends State<PadrePanelPage> {
  CelebrationType _type = CelebrationType.Batismo;
  DateTime _date = DateTime.now();
  String? _selectedFielId;
  bool _loading = false;
  List<Celebration> _list = [];
  List<User> _fieis = [];

  // Batismo controllers
  final _nomeBatizado = TextEditingController();
  final _pai = TextEditingController();
  final _mae = TextEditingController();
  final _padrinho1 = TextEditingController();
  final _padrinho2 = TextEditingController();
  DateTime? _dataNascimento;

  // Casamento controllers
  String? _conjugeId;
  final _testemunha1 = TextEditingController();
  final _testemunha2 = TextEditingController();

  // Óbito controllers
  final _nomeFalecido = TextEditingController();
  final _localSepultura = TextEditingController();
  DateTime? _dataNascimentoFalecido;
  DateTime? _dataObito;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _loadFieis();
  }

  @override
  void dispose() {
    _nomeBatizado.dispose();
    _pai.dispose();
    _mae.dispose();
    _padrinho1.dispose();
    _padrinho2.dispose();
    _testemunha1.dispose();
    _testemunha2.dispose();
    _nomeFalecido.dispose();
    _localSepultura.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final s = Provider.of<AppState>(context, listen: false);
    final list = await s.getAllCelebrations();
    setState(() => _list = list);
  }

  Future<void> _loadFieis() async {
    final s = Provider.of<AppState>(context, listen: false);
    final all = await s.getAllUsers();
    setState(() {
      _fieis = all.where((u) => u.role == Role.Fiel).toList();
      if (_fieis.isNotEmpty && _selectedFielId == null) _selectedFielId = _fieis.first.id;
    });
  }

  Map<String, dynamic> _collectExtraFields() {
    if (_type == CelebrationType.Batismo) {
      return {
        'nomeBatizado': _nomeBatizado.text.trim().isEmpty ? null : _nomeBatizado.text.trim(),
        'pai': _pai.text.trim().isEmpty ? null : _pai.text.trim(),
        'mae': _mae.text.trim().isEmpty ? null : _mae.text.trim(),
        'padrinho1': _padrinho1.text.trim().isEmpty ? null : _padrinho1.text.trim(),
        'padrinho2': _padrinho2.text.trim().isEmpty ? null : _padrinho2.text.trim(),
        'dataNascimento': _dataNascimento,
      };
    } else if (_type == CelebrationType.Casamento) {
      return {
        'conjugeUserId': _conjugeId,
        'testemunha1': _testemunha1.text.trim().isEmpty ? null : _testemunha1.text.trim(),
        'testemunha2': _testemunha2.text.trim().isEmpty ? null : _testemunha2.text.trim(),
      };
    } else {
      return {
        'nomeFalecido': _nomeFalecido.text.trim().isEmpty ? null : _nomeFalecido.text.trim(),
        'localSepultura': _localSepultura.text.trim().isEmpty ? null : _localSepultura.text.trim(),
        'dataNascimentoFalecido': _dataNascimentoFalecido,
        'dataObito': _dataObito,
      };
    }
  }

  Future<void> _submitCelebration() async {
    if (_selectedFielId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um fiel para associar à celebração')));
      return;
    }

    final app = Provider.of<AppState>(context, listen: false);

    // validate type-specific required fields
    if (_type == CelebrationType.Batismo) {
      if (_nomeBatizado.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome do batizado obrigatório')));
        return;
      }
      if (_dataNascimento == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data de nascimento do batizado obrigatória')));
        return;
      }
    }
    if (_type == CelebrationType.Casamento) {
      if (_conjugeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seleccione o cônjuge (outro fiel)')));
        return;
      }
    }
    if (_type == CelebrationType.Obito) {
      if (_nomeFalecido.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome do falecido obrigatório')));
        return;
      }
      if (_dataObito == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data do óbito obrigatória')));
        return;
      }
      if (_dataNascimentoFalecido == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data de nascimento do falecido obrigatória')));
        return;
      }
      if (!_dataNascimentoFalecido!.isBefore(_dataObito!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data de nascimento do falecido deve ser anterior à data do óbito')));
        return;
      }
    }

    setState(() => _loading = true);
    try {
      final extra = _collectExtraFields();
      await app.createCelebration(_type, _date, 'Detalhes gerados automaticamente', _selectedFielId!, extra);
      await _loadAll();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Celebração criada com sucesso')));
      // clear some fields after creation
      _nomeBatizado.clear();
      _pai.clear();
      _mae.clear();
      _padrinho1.clear();
      _padrinho2.clear();
      _testemunha1.clear();
      _testemunha2.clear();
      _nomeFalecido.clear();
      _localSepultura.clear();
      _dataNascimento = null;
      _dataNascimentoFalecido = null;
      _dataObito = null;
      _conjugeId = null;
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildCelebrationDetails(Celebration c) {
    final app = Provider.of<AppState>(context, listen: false);
    List<Widget> details = [];
    if (c.type == CelebrationType.Batismo) {
      details.add(Text('Batizado: ${c.nomeBatizado ?? "-"}'));
      details.add(Text('Pais: ${c.pai ?? "-"} e ${c.mae ?? "-"}'));
      details.add(Text('Padrinhos: ${c.padrinho1 ?? "-"} e ${c.padrinho2 ?? "-"}'));
      details.add(Text('Nascimento: ${fmtDate(c.dataNascimento)}'));
    } else if (c.type == CelebrationType.Casamento) {
      final titular = _fieis.firstWhere((u) => u.id == c.ownerUserId, orElse: () => User(id: c.ownerUserId, name: c.ownerUserId, email: '', password: '', role: Role.Fiel));
      final conjuge = _fieis.firstWhere((u) => u.id == c.conjugeUserId, orElse: () => User(id: c.conjugeUserId ?? 'n/a', name: c.conjugeUserId ?? '-', email: '', password: '', role: Role.Fiel));
      details.add(Text('Titular: ${titular.name}'));
      details.add(Text('Cônjuge: ${conjuge.name}'));
      details.add(Text('Testemunhas: ${c.testemunha1 ?? "-"} e ${c.testemunha2 ?? "-"}'));
    } else {
      details.add(Text('Falecido: ${c.nomeFalecido ?? "-"}'));
      details.add(Text('Nascimento: ${fmtDate(c.dataNascimentoFalecido)}'));
      details.add(Text('Óbito: ${fmtDate(c.dataObito)}'));
      details.add(Text('Sepultura: ${c.localSepultura ?? "-"}'));
    }

    details.add(Text('Fiel titular: ${_fieis.firstWhere((u) => u.id == c.ownerUserId, orElse: () => User(id: c.ownerUserId, name: c.ownerUserId, email: '', password: '', role: Role.Fiel)).name}'));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: details.map((w) => Padding(padding: const EdgeInsets.only(top: 4), child: w)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    if (!app.loggedIn || app.currentUser!.role != Role.Padre) {
      return Center(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Área restrita a utilizadores com o perfil Padre.', style: TextStyle(color: Colors.grey.shade700)))));
    }

    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.add_card, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Criar celebração', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),

            // form area
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFielId,
                  decoration: const InputDecoration(labelText: 'Fiel associado (obrigatório)'),
                  items: _fieis.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
                  onChanged: (v) => setState(() => _selectedFielId = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<CelebrationType>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: CelebrationType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                  onChanged: (v) => setState(() { if (v != null) _type = v; }),
                ),
              ),
            ]),

            const SizedBox(height: 12),

            if (_type == CelebrationType.Batismo) ...[
              TextFormField(controller: _nomeBatizado, decoration: const InputDecoration(labelText: 'Nome do Batizado')),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: TextFormField(controller: _pai, decoration: const InputDecoration(labelText: 'Pai'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _mae, decoration: const InputDecoration(labelText: 'Mãe'))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: TextFormField(controller: _padrinho1, decoration: const InputDecoration(labelText: 'Padrinho 1'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _padrinho2, decoration: const InputDecoration(labelText: 'Padrinho 2'))),
              ]),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (p != null) setState(() => _dataNascimento = p);
                },
                child: Text('Data de Nascimento: ${fmtDate(_dataNascimento)}'),
              ),
            ],

            if (_type == CelebrationType.Casamento) ...[
              DropdownButtonFormField<String>(
                value: _conjugeId,
                decoration: const InputDecoration(labelText: 'Cônjuge (outro fiel)'),
                items: _fieis.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
                onChanged: (v) => setState(() => _conjugeId = v),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: TextFormField(controller: _testemunha1, decoration: const InputDecoration(labelText: 'Padrinho 1'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _testemunha2, decoration: const InputDecoration(labelText: 'Padrinho 2'))),
              ]),
            ],

            if (_type == CelebrationType.Obito) ...[
              TextFormField(controller: _nomeFalecido, decoration: const InputDecoration(labelText: 'Nome do Falecido')),
              const SizedBox(height: 8),
              TextFormField(controller: _localSepultura, decoration: const InputDecoration(labelText: 'Local da Sepultura')),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final p = await showDatePicker(context: context, initialDate: DateTime(1950), firstDate: DateTime(1800), lastDate: DateTime.now());
                  if (p != null) setState(() => _dataNascimentoFalecido = p);
                },
                child: Text('Data de Nascimento do Falecido: ${fmtDate(_dataNascimentoFalecido)}'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final p = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (p != null) setState(() => _dataObito = p);
                },
                child: Text('Data do Óbito: ${fmtDate(_dataObito)}'),
              ),
            ],

            const SizedBox(height: 12),
            Row(children: [
              FilledButton(
                onPressed: _loading ? null : _submitCelebration,
                child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Criar'),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(onPressed: _loadAll, child: const Text('Atualizar lista')),
            ]),
          ]),
        ),
      ),

      const SizedBox(height: 14),

      // Celebrations list
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _list.isEmpty
                ? Center(child: Text('Sem celebrações', style: TextStyle(color: Colors.grey.shade700)))
                : ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (c, i) {
                      final e = _list[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          title: Text('${e.type.name} — ${fmtDate(e.date)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const SizedBox(height: 6),
                            _buildCelebrationDetails(e),
                            const SizedBox(height: 6),
                            Text(e.isSigned ? 'Assinado por ${e.signedByUserId} em ${fmtDate(e.signedAt)}' : 'Não assinado',
                              style: TextStyle(color: e.isSigned ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.w600)),
                          ]),
                          isThreeLine: true,
                          trailing: e.isSigned ? null : FilledButton.tonal(
                            onPressed: () async {
                              try {
                                await Provider.of<AppState>(context, listen: false).signCelebration(e.id);
                                await _loadAll();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assinatura registada e documento gerado')));
                              } catch (ex) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${ex.toString()}')));
                              }
                            },
                            child: const Text('Assinar'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    ]);
  }
}

// Pesquisa, Documentos, Pagamentos + dialog
//  (Padre/Admin)
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

  List<Widget> _buildCelebrationDetails(Celebration c) {
    final repo = Provider.of<AppState>(context).repository;
    List<Widget> widgets = [];
    if (c.type == CelebrationType.Batismo) {
      widgets.add(Text('Batizado: ${c.nomeBatizado ?? "-"}'));
      widgets.add(Text('Pais: ${c.pai ?? "-"} e ${c.mae ?? "-"}'));
      widgets.add(Text('Padrinhos: ${c.padrinho1 ?? "-"} e ${c.padrinho2 ?? "-"}'));
      widgets.add(Text('Nascimento: ${fmtDate(c.dataNascimento)}'));
    } else if (c.type == CelebrationType.Casamento) {
      widgets.add(Text('Titular: ${c.ownerUserId}'));
      widgets.add(Text('Cônjuge: ${c.conjugeUserId ?? "-"}'));
      widgets.add(Text('Testemunhas: ${c.testemunha1 ?? "-"} e ${c.testemunha2 ?? "-"}'));
    } else {
      widgets.add(Text('Falecido: ${c.nomeFalecido ?? "-"}'));
      widgets.add(Text('Nascimento: ${fmtDate(c.dataNascimentoFalecido)}'));
      widgets.add(Text('Óbito: ${fmtDate(c.dataObito)}'));
      widgets.add(Text('Sepultura: ${c.localSepultura ?? "-"}'));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    if (!app.loggedIn || !(app.currentUser!.role == Role.Padre || app.currentUser!.role == Role.Administracao)) {
      return Center(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Pesquisa reservada a Padre e Administração.', style: TextStyle(color: Colors.grey.shade700)))));
    }

    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            TextButton(onPressed: () async {
              final p = await showDatePicker(context: context, initialDate: _from, firstDate: DateTime(1900), lastDate: DateTime(2100));
              if (p != null) setState(() => _from = p);
            }, child: Text('From: ${fmtDate(_from)}')),
            const SizedBox(width: 12),
            TextButton(onPressed: () async {
              final p = await showDatePicker(context: context, initialDate: _to, firstDate: DateTime(1900), lastDate: DateTime(2100));
              if (p != null) setState(() => _to = p);
            }, child: Text('To: ${fmtDate(_to)}')),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: _loading ? null : () async {
                if (_from.isAfter(_to)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Intervalo inválido: a data inicial não pode ser posterior à final')));
                  return;
                }
                setState(() => _loading = true);
                _result = await app.searchCelebrations(_from, _to);
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Pesquisar'),
            )
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _loading ? const Center(child: CircularProgressIndicator()) : _result.isEmpty ? Center(child: Text('Nenhuma celebração encontrada', style: TextStyle(color: Colors.grey.shade700))) :
            ListView.separated(
              itemCount: _result.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (c, i) {
                final e = _result[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('${e.type.name} — ${fmtDate(e.date)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 6),
                      ..._buildCelebrationDetails(e),
                      const SizedBox(height: 6),
                      Text(e.isSigned ? 'Assinado' : 'Não assinado', style: TextStyle(color: e.isSigned ? Colors.green : Colors.red, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

// Documentos (Fiel vê apenas pagos
//             Padre/Admin vê todos)

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
    final app = Provider.of<AppState>(context, listen: false);
    if (!app.loggedIn) {
      _docs = [];
    } else {
      _docs = await app.getDocumentsForUser(app.currentUser!.id);
      if (app.currentUser!.role == Role.Fiel) {
        _docs = _docs.where((d) => d.feeStatus == FeeStatus.Pago).toList();
      }
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Widget _buildDocDetails(Document d) {
    final c = d.originalCelebration;
    if (c == null) return Text('Documento sem celebração associada');
    List<Widget> rows = [];
    rows.add(Text('Tipo: ${d.type}'));
    rows.add(Text('Montante: €${d.feeAmount.toStringAsFixed(2)}'));
    rows.add(const SizedBox(height: 6));
    // celebration-specific details
    if (c.type == CelebrationType.Batismo) {
      rows.add(Text('Batizado: ${c.nomeBatizado ?? "-"}'));
      rows.add(Text('Pais: ${c.pai ?? "-"} e ${c.mae ?? "-"}'));
    } else if (c.type == CelebrationType.Casamento) {
      rows.add(Text('Titular: ${c.ownerUserId}'));
      rows.add(Text('Cônjuge: ${c.conjugeUserId ?? "-"}'));
    } else {
      rows.add(Text('Falecido: ${c.nomeFalecido ?? "-"}'));
      rows.add(Text('Local: ${c.localSepultura ?? "-"}'));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    if (!app.loggedIn || !(app.currentUser!.role == Role.Fiel || app.currentUser!.role == Role.Padre || app.currentUser!.role == Role.Administracao)) {
      return Center(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Acesso a documentos restrito — faça login como Fiel, Padre ou Administração.'))));
    }

    return Column(children: [
      Row(children: [
        Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [const Icon(Icons.folder), const SizedBox(width: 8), const Text('Meus Documentos / Certidões', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const Spacer(), FilledButton.tonal(onPressed: _load, child: const Text('Atualizar'))])))),
      ]),
      const SizedBox(height: 12),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _loading ? const Center(child: CircularProgressIndicator()) : _docs.isEmpty ? Center(child: Text('Nenhum documento disponível (os documentos aparecem aqui apenas após pagamento).', style: TextStyle(color: Colors.grey.shade700))) :
            ListView.separated(
              itemCount: _docs.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (c, i) {
                final d = _docs[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  title: Text(d.type, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: _buildDocDetails(d),
                  trailing: FilledButton.tonal(
                    onPressed: d.available ? () {
                      showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text(d.type),
                        content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Documento para: ${d.ownerUserId}'),
                          const SizedBox(height: 8),
                          Text(d.fileContent ?? 'Sem conteúdo'),
                        ])),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
                      ));
                    } : null,
                    child: const Text('Abrir'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

// Pagamentos (Pendentes + formulário de pagamento)

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
    final app = Provider.of<AppState>(context, listen: false);
    if (!app.loggedIn) {
      _pending = [];
    } else {
      _pending = await app.getPendingDocumentsForUser(app.currentUser!.id);
    }
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _startPayment(Document doc) async {
    await showDialog(context: context, builder: (_) => PaymentDialog(document: doc, onSuccess: () async {
      await Provider.of<AppState>(context, listen: false).payFee(doc.id, doc.paymentMethod ?? 'MBWay');
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento confirmado — documento desbloqueado')));
    }));
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    if (!app.loggedIn || app.currentUser!.role != Role.Fiel) {
      return Center(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('A área de pagamentos é apenas para utilizadores com perfil Fiel.'))));
    }

    return Column(children: [
      Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [const Icon(Icons.payment), const SizedBox(width: 10), const Text('Documentos pendentes (taxas em falta)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const Spacer(), FilledButton.tonal(onPressed: _load, child: const Text('Atualizar'))]))),
      const SizedBox(height: 12),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _loading ? const Center(child: CircularProgressIndicator()) : _pending.isEmpty ? Center(child: Text('Sem pagamentos pendentes', style: TextStyle(color: Colors.grey.shade700))) :
            ListView.separated(
              itemCount: _pending.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (c, i) {
                final d = _pending[i];
                return ListTile(
                  title: Text(d.type, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Montante: €${d.feeAmount.toStringAsFixed(2)}'), Text('Celebration ID: ${d.celebrationId}', style: const TextStyle(fontSize: 12))]),
                  trailing: FilledButton(onPressed: () => _startPayment(d), child: const Text('Pagar')),
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

// MBWay / Card / Transfer fields + validation
class PaymentDialog extends StatefulWidget {
  final Document document;
  final VoidCallback onSuccess;
  const PaymentDialog({super.key, required this.document, required this.onSuccess});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}
class _PaymentDialogState extends State<PaymentDialog> {
  String _method = 'MBWay';
  final _mbwayController = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCvv = TextEditingController();
  final _iban = TextEditingController();
  final _proof = TextEditingController();
  bool _processing = false;

  @override
  void dispose() {
    _mbwayController.dispose();
    _cardNumber.dispose();
    _cardExpiry.dispose();
    _cardCvv.dispose();
    _iban.dispose();
    _proof.dispose();
    super.dispose();
  }

  Widget _methodFields() {
    switch (_method) {
      case 'MBWay':
        return Column(children: [
          TextFormField(controller: _mbwayController, decoration: const InputDecoration(labelText: 'Número MBWay (9 dígitos)'), keyboardType: TextInputType.phone),
        ]);
      case 'Cartão':
        return Column(children: [
          TextFormField(controller: _cardNumber, decoration: const InputDecoration(labelText: 'Número do Cartão'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextFormField(controller: _cardExpiry, decoration: const InputDecoration(labelText: 'MM/AA'))),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(controller: _cardCvv, decoration: const InputDecoration(labelText: 'CVV'), obscureText: true)),
          ])
        ]);
      case 'Transferência':
        return Column(children: [
          TextFormField(controller: _iban, decoration: const InputDecoration(labelText: 'IBAN (ex: PT... )')),
          const SizedBox(height: 8),
          TextFormField(controller: _proof, decoration: const InputDecoration(labelText: 'Comprovativo (texto)'), maxLines: 2),
        ]);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _pay() async {
    // validate fields
    if (_method == 'MBWay') {
      final n = _mbwayController.text.trim();
      if (n.length < 9) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Número MBWay inválido')));
        return;
      }
    } else if (_method == 'Cartão') {
      if (_cardNumber.text.trim().length < 12) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Número de cartão inválido')));
        return;
      }
    } else if (_method == 'Transferência') {
      if (_iban.text.trim().length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('IBAN inválido')));
        return;
      }
    }

    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate
    try {
      final app = Provider.of<AppState>(context, listen: false);
      await app.payFee(widget.document.id, _method);
      widget.document.paymentMethod = _method;
      widget.document.paymentDate = DateTime.now();
      widget.document.feeStatus = FeeStatus.Pago;
      widget.document.fileContent ??= 'Documento ${widget.document.type} - emitido em ${DateTime.now()}';
      widget.onSuccess();
      Navigator.pop(context);
    } catch (ex) {
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro pagamento: ${ex.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [const Icon(Icons.lock_open), const SizedBox(width: 8), const Text('Pagar taxa')]),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Documento: ${widget.document.type}'),
          const SizedBox(height: 8),
          Text('Montante: €${widget.document.feeAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _method,
            items: const [
              DropdownMenuItem(value: 'MBWay', child: Text('MBWay')),
              DropdownMenuItem(value: 'Cartão', child: Text('Cartão')),
              DropdownMenuItem(value: 'Transferência', child: Text('Transferência')),
            ],
            onChanged: (v) => setState(() => _method = v ?? 'MBWay'),
            decoration: const InputDecoration(labelText: 'Método de pagamento'),
          ),
          const SizedBox(height: 12),
          _methodFields(),
        ]),
      ),
      actions: [
        TextButton(onPressed: _processing ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _processing ? null : _pay, child: _processing ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Confirmar Pagamento')),
      ],
    );
  }
}