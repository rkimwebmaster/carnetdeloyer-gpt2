// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_locale.dart';

// ignore_for_file: type=lint
class $CacheReponsesTable extends CacheReponses
    with TableInfo<$CacheReponsesTable, ReponseEnCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheReponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  @override
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
    'cle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utilisateurIdMeta = const VerificationMeta(
    'utilisateurId',
  );
  @override
  late final GeneratedColumn<int> utilisateurId = GeneratedColumn<int>(
    'utilisateur_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _majLeMeta = const VerificationMeta('majLe');
  @override
  late final GeneratedColumn<DateTime> majLe = GeneratedColumn<DateTime>(
    'maj_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cle, utilisateurId, json, majLe];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_reponses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReponseEnCache> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cle')) {
      context.handle(
        _cleMeta,
        cle.isAcceptableOrUnknown(data['cle']!, _cleMeta),
      );
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('utilisateur_id')) {
      context.handle(
        _utilisateurIdMeta,
        utilisateurId.isAcceptableOrUnknown(
          data['utilisateur_id']!,
          _utilisateurIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utilisateurIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('maj_le')) {
      context.handle(
        _majLeMeta,
        majLe.isAcceptableOrUnknown(data['maj_le']!, _majLeMeta),
      );
    } else if (isInserting) {
      context.missing(_majLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cle, utilisateurId};
  @override
  ReponseEnCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReponseEnCache(
      cle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cle'],
      )!,
      utilisateurId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utilisateur_id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      majLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}maj_le'],
      )!,
    );
  }

  @override
  $CacheReponsesTable createAlias(String alias) {
    return $CacheReponsesTable(attachedDatabase, alias);
  }
}

class ReponseEnCache extends DataClass implements Insertable<ReponseEnCache> {
  final String cle;
  final int utilisateurId;
  final String json;
  final DateTime majLe;
  const ReponseEnCache({
    required this.cle,
    required this.utilisateurId,
    required this.json,
    required this.majLe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cle'] = Variable<String>(cle);
    map['utilisateur_id'] = Variable<int>(utilisateurId);
    map['json'] = Variable<String>(json);
    map['maj_le'] = Variable<DateTime>(majLe);
    return map;
  }

  CacheReponsesCompanion toCompanion(bool nullToAbsent) {
    return CacheReponsesCompanion(
      cle: Value(cle),
      utilisateurId: Value(utilisateurId),
      json: Value(json),
      majLe: Value(majLe),
    );
  }

  factory ReponseEnCache.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReponseEnCache(
      cle: serializer.fromJson<String>(json['cle']),
      utilisateurId: serializer.fromJson<int>(json['utilisateurId']),
      json: serializer.fromJson<String>(json['json']),
      majLe: serializer.fromJson<DateTime>(json['majLe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cle': serializer.toJson<String>(cle),
      'utilisateurId': serializer.toJson<int>(utilisateurId),
      'json': serializer.toJson<String>(json),
      'majLe': serializer.toJson<DateTime>(majLe),
    };
  }

  ReponseEnCache copyWith({
    String? cle,
    int? utilisateurId,
    String? json,
    DateTime? majLe,
  }) => ReponseEnCache(
    cle: cle ?? this.cle,
    utilisateurId: utilisateurId ?? this.utilisateurId,
    json: json ?? this.json,
    majLe: majLe ?? this.majLe,
  );
  ReponseEnCache copyWithCompanion(CacheReponsesCompanion data) {
    return ReponseEnCache(
      cle: data.cle.present ? data.cle.value : this.cle,
      utilisateurId: data.utilisateurId.present
          ? data.utilisateurId.value
          : this.utilisateurId,
      json: data.json.present ? data.json.value : this.json,
      majLe: data.majLe.present ? data.majLe.value : this.majLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReponseEnCache(')
          ..write('cle: $cle, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('json: $json, ')
          ..write('majLe: $majLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cle, utilisateurId, json, majLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReponseEnCache &&
          other.cle == this.cle &&
          other.utilisateurId == this.utilisateurId &&
          other.json == this.json &&
          other.majLe == this.majLe);
}

class CacheReponsesCompanion extends UpdateCompanion<ReponseEnCache> {
  final Value<String> cle;
  final Value<int> utilisateurId;
  final Value<String> json;
  final Value<DateTime> majLe;
  final Value<int> rowid;
  const CacheReponsesCompanion({
    this.cle = const Value.absent(),
    this.utilisateurId = const Value.absent(),
    this.json = const Value.absent(),
    this.majLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheReponsesCompanion.insert({
    required String cle,
    required int utilisateurId,
    required String json,
    required DateTime majLe,
    this.rowid = const Value.absent(),
  }) : cle = Value(cle),
       utilisateurId = Value(utilisateurId),
       json = Value(json),
       majLe = Value(majLe);
  static Insertable<ReponseEnCache> custom({
    Expression<String>? cle,
    Expression<int>? utilisateurId,
    Expression<String>? json,
    Expression<DateTime>? majLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cle != null) 'cle': cle,
      if (utilisateurId != null) 'utilisateur_id': utilisateurId,
      if (json != null) 'json': json,
      if (majLe != null) 'maj_le': majLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheReponsesCompanion copyWith({
    Value<String>? cle,
    Value<int>? utilisateurId,
    Value<String>? json,
    Value<DateTime>? majLe,
    Value<int>? rowid,
  }) {
    return CacheReponsesCompanion(
      cle: cle ?? this.cle,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      json: json ?? this.json,
      majLe: majLe ?? this.majLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (utilisateurId.present) {
      map['utilisateur_id'] = Variable<int>(utilisateurId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (majLe.present) {
      map['maj_le'] = Variable<DateTime>(majLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheReponsesCompanion(')
          ..write('cle: $cle, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('json: $json, ')
          ..write('majLe: $majLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaiementsEnAttenteTable extends PaiementsEnAttente
    with TableInfo<$PaiementsEnAttenteTable, PaiementEnAttente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaiementsEnAttenteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utilisateurIdMeta = const VerificationMeta(
    'utilisateurId',
  );
  @override
  late final GeneratedColumn<int> utilisateurId = GeneratedColumn<int>(
    'utilisateur_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contratIdMeta = const VerificationMeta(
    'contratId',
  );
  @override
  late final GeneratedColumn<int> contratId = GeneratedColumn<int>(
    'contrat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montantMeta = const VerificationMeta(
    'montant',
  );
  @override
  late final GeneratedColumn<int> montant = GeneratedColumn<int>(
    'montant',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviseMeta = const VerificationMeta('devise');
  @override
  late final GeneratedColumn<String> devise = GeneratedColumn<String>(
    'devise',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePaiementMeta = const VerificationMeta(
    'datePaiement',
  );
  @override
  late final GeneratedColumn<String> datePaiement = GeneratedColumn<String>(
    'date_paiement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moyenMeta = const VerificationMeta('moyen');
  @override
  late final GeneratedColumn<String> moyen = GeneratedColumn<String>(
    'moyen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _libelleMeta = const VerificationMeta(
    'libelle',
  );
  @override
  late final GeneratedColumn<String> libelle = GeneratedColumn<String>(
    'libelle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etatMeta = const VerificationMeta('etat');
  @override
  late final GeneratedColumn<String> etat = GeneratedColumn<String>(
    'etat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en_attente'),
  );
  static const VerificationMeta _codeRejetMeta = const VerificationMeta(
    'codeRejet',
  );
  @override
  late final GeneratedColumn<String> codeRejet = GeneratedColumn<String>(
    'code_rejet',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motifRejetMeta = const VerificationMeta(
    'motifRejet',
  );
  @override
  late final GeneratedColumn<String> motifRejet = GeneratedColumn<String>(
    'motif_rejet',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recuNumeroMeta = const VerificationMeta(
    'recuNumero',
  );
  @override
  late final GeneratedColumn<String> recuNumero = GeneratedColumn<String>(
    'recu_numero',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    utilisateurId,
    contratId,
    montant,
    devise,
    datePaiement,
    moyen,
    reference,
    libelle,
    etat,
    codeRejet,
    motifRejet,
    recuNumero,
    creeLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paiements_en_attente';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaiementEnAttente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('utilisateur_id')) {
      context.handle(
        _utilisateurIdMeta,
        utilisateurId.isAcceptableOrUnknown(
          data['utilisateur_id']!,
          _utilisateurIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utilisateurIdMeta);
    }
    if (data.containsKey('contrat_id')) {
      context.handle(
        _contratIdMeta,
        contratId.isAcceptableOrUnknown(data['contrat_id']!, _contratIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contratIdMeta);
    }
    if (data.containsKey('montant')) {
      context.handle(
        _montantMeta,
        montant.isAcceptableOrUnknown(data['montant']!, _montantMeta),
      );
    } else if (isInserting) {
      context.missing(_montantMeta);
    }
    if (data.containsKey('devise')) {
      context.handle(
        _deviseMeta,
        devise.isAcceptableOrUnknown(data['devise']!, _deviseMeta),
      );
    } else if (isInserting) {
      context.missing(_deviseMeta);
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
        _datePaiementMeta,
        datePaiement.isAcceptableOrUnknown(
          data['date_paiement']!,
          _datePaiementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datePaiementMeta);
    }
    if (data.containsKey('moyen')) {
      context.handle(
        _moyenMeta,
        moyen.isAcceptableOrUnknown(data['moyen']!, _moyenMeta),
      );
    } else if (isInserting) {
      context.missing(_moyenMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('libelle')) {
      context.handle(
        _libelleMeta,
        libelle.isAcceptableOrUnknown(data['libelle']!, _libelleMeta),
      );
    } else if (isInserting) {
      context.missing(_libelleMeta);
    }
    if (data.containsKey('etat')) {
      context.handle(
        _etatMeta,
        etat.isAcceptableOrUnknown(data['etat']!, _etatMeta),
      );
    }
    if (data.containsKey('code_rejet')) {
      context.handle(
        _codeRejetMeta,
        codeRejet.isAcceptableOrUnknown(data['code_rejet']!, _codeRejetMeta),
      );
    }
    if (data.containsKey('motif_rejet')) {
      context.handle(
        _motifRejetMeta,
        motifRejet.isAcceptableOrUnknown(data['motif_rejet']!, _motifRejetMeta),
      );
    }
    if (data.containsKey('recu_numero')) {
      context.handle(
        _recuNumeroMeta,
        recuNumero.isAcceptableOrUnknown(data['recu_numero']!, _recuNumeroMeta),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaiementEnAttente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaiementEnAttente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      utilisateurId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utilisateur_id'],
      )!,
      contratId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contrat_id'],
      )!,
      montant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}montant'],
      )!,
      devise: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}devise'],
      )!,
      datePaiement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_paiement'],
      )!,
      moyen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moyen'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      libelle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}libelle'],
      )!,
      etat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etat'],
      )!,
      codeRejet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_rejet'],
      ),
      motifRejet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motif_rejet'],
      ),
      recuNumero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recu_numero'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
    );
  }

  @override
  $PaiementsEnAttenteTable createAlias(String alias) {
    return $PaiementsEnAttenteTable(attachedDatabase, alias);
  }
}

class PaiementEnAttente extends DataClass
    implements Insertable<PaiementEnAttente> {
  /// UUID généré sur le téléphone, envoyé comme clé d'idempotence (R-137).
  final String id;

  /// R-139 : la file est liée à l'utilisateur.
  final int utilisateurId;
  final int contratId;
  final int montant;
  final String devise;
  final String datePaiement;
  final String moyen;
  final String? reference;
  final String libelle;
  final String etat;
  final String? codeRejet;
  final String? motifRejet;
  final String? recuNumero;
  final DateTime creeLe;
  const PaiementEnAttente({
    required this.id,
    required this.utilisateurId,
    required this.contratId,
    required this.montant,
    required this.devise,
    required this.datePaiement,
    required this.moyen,
    this.reference,
    required this.libelle,
    required this.etat,
    this.codeRejet,
    this.motifRejet,
    this.recuNumero,
    required this.creeLe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['utilisateur_id'] = Variable<int>(utilisateurId);
    map['contrat_id'] = Variable<int>(contratId);
    map['montant'] = Variable<int>(montant);
    map['devise'] = Variable<String>(devise);
    map['date_paiement'] = Variable<String>(datePaiement);
    map['moyen'] = Variable<String>(moyen);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['libelle'] = Variable<String>(libelle);
    map['etat'] = Variable<String>(etat);
    if (!nullToAbsent || codeRejet != null) {
      map['code_rejet'] = Variable<String>(codeRejet);
    }
    if (!nullToAbsent || motifRejet != null) {
      map['motif_rejet'] = Variable<String>(motifRejet);
    }
    if (!nullToAbsent || recuNumero != null) {
      map['recu_numero'] = Variable<String>(recuNumero);
    }
    map['cree_le'] = Variable<DateTime>(creeLe);
    return map;
  }

  PaiementsEnAttenteCompanion toCompanion(bool nullToAbsent) {
    return PaiementsEnAttenteCompanion(
      id: Value(id),
      utilisateurId: Value(utilisateurId),
      contratId: Value(contratId),
      montant: Value(montant),
      devise: Value(devise),
      datePaiement: Value(datePaiement),
      moyen: Value(moyen),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      libelle: Value(libelle),
      etat: Value(etat),
      codeRejet: codeRejet == null && nullToAbsent
          ? const Value.absent()
          : Value(codeRejet),
      motifRejet: motifRejet == null && nullToAbsent
          ? const Value.absent()
          : Value(motifRejet),
      recuNumero: recuNumero == null && nullToAbsent
          ? const Value.absent()
          : Value(recuNumero),
      creeLe: Value(creeLe),
    );
  }

  factory PaiementEnAttente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaiementEnAttente(
      id: serializer.fromJson<String>(json['id']),
      utilisateurId: serializer.fromJson<int>(json['utilisateurId']),
      contratId: serializer.fromJson<int>(json['contratId']),
      montant: serializer.fromJson<int>(json['montant']),
      devise: serializer.fromJson<String>(json['devise']),
      datePaiement: serializer.fromJson<String>(json['datePaiement']),
      moyen: serializer.fromJson<String>(json['moyen']),
      reference: serializer.fromJson<String?>(json['reference']),
      libelle: serializer.fromJson<String>(json['libelle']),
      etat: serializer.fromJson<String>(json['etat']),
      codeRejet: serializer.fromJson<String?>(json['codeRejet']),
      motifRejet: serializer.fromJson<String?>(json['motifRejet']),
      recuNumero: serializer.fromJson<String?>(json['recuNumero']),
      creeLe: serializer.fromJson<DateTime>(json['creeLe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'utilisateurId': serializer.toJson<int>(utilisateurId),
      'contratId': serializer.toJson<int>(contratId),
      'montant': serializer.toJson<int>(montant),
      'devise': serializer.toJson<String>(devise),
      'datePaiement': serializer.toJson<String>(datePaiement),
      'moyen': serializer.toJson<String>(moyen),
      'reference': serializer.toJson<String?>(reference),
      'libelle': serializer.toJson<String>(libelle),
      'etat': serializer.toJson<String>(etat),
      'codeRejet': serializer.toJson<String?>(codeRejet),
      'motifRejet': serializer.toJson<String?>(motifRejet),
      'recuNumero': serializer.toJson<String?>(recuNumero),
      'creeLe': serializer.toJson<DateTime>(creeLe),
    };
  }

  PaiementEnAttente copyWith({
    String? id,
    int? utilisateurId,
    int? contratId,
    int? montant,
    String? devise,
    String? datePaiement,
    String? moyen,
    Value<String?> reference = const Value.absent(),
    String? libelle,
    String? etat,
    Value<String?> codeRejet = const Value.absent(),
    Value<String?> motifRejet = const Value.absent(),
    Value<String?> recuNumero = const Value.absent(),
    DateTime? creeLe,
  }) => PaiementEnAttente(
    id: id ?? this.id,
    utilisateurId: utilisateurId ?? this.utilisateurId,
    contratId: contratId ?? this.contratId,
    montant: montant ?? this.montant,
    devise: devise ?? this.devise,
    datePaiement: datePaiement ?? this.datePaiement,
    moyen: moyen ?? this.moyen,
    reference: reference.present ? reference.value : this.reference,
    libelle: libelle ?? this.libelle,
    etat: etat ?? this.etat,
    codeRejet: codeRejet.present ? codeRejet.value : this.codeRejet,
    motifRejet: motifRejet.present ? motifRejet.value : this.motifRejet,
    recuNumero: recuNumero.present ? recuNumero.value : this.recuNumero,
    creeLe: creeLe ?? this.creeLe,
  );
  PaiementEnAttente copyWithCompanion(PaiementsEnAttenteCompanion data) {
    return PaiementEnAttente(
      id: data.id.present ? data.id.value : this.id,
      utilisateurId: data.utilisateurId.present
          ? data.utilisateurId.value
          : this.utilisateurId,
      contratId: data.contratId.present ? data.contratId.value : this.contratId,
      montant: data.montant.present ? data.montant.value : this.montant,
      devise: data.devise.present ? data.devise.value : this.devise,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      moyen: data.moyen.present ? data.moyen.value : this.moyen,
      reference: data.reference.present ? data.reference.value : this.reference,
      libelle: data.libelle.present ? data.libelle.value : this.libelle,
      etat: data.etat.present ? data.etat.value : this.etat,
      codeRejet: data.codeRejet.present ? data.codeRejet.value : this.codeRejet,
      motifRejet: data.motifRejet.present
          ? data.motifRejet.value
          : this.motifRejet,
      recuNumero: data.recuNumero.present
          ? data.recuNumero.value
          : this.recuNumero,
      creeLe: data.creeLe.present ? data.creeLe.value : this.creeLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaiementEnAttente(')
          ..write('id: $id, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('contratId: $contratId, ')
          ..write('montant: $montant, ')
          ..write('devise: $devise, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('moyen: $moyen, ')
          ..write('reference: $reference, ')
          ..write('libelle: $libelle, ')
          ..write('etat: $etat, ')
          ..write('codeRejet: $codeRejet, ')
          ..write('motifRejet: $motifRejet, ')
          ..write('recuNumero: $recuNumero, ')
          ..write('creeLe: $creeLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    utilisateurId,
    contratId,
    montant,
    devise,
    datePaiement,
    moyen,
    reference,
    libelle,
    etat,
    codeRejet,
    motifRejet,
    recuNumero,
    creeLe,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaiementEnAttente &&
          other.id == this.id &&
          other.utilisateurId == this.utilisateurId &&
          other.contratId == this.contratId &&
          other.montant == this.montant &&
          other.devise == this.devise &&
          other.datePaiement == this.datePaiement &&
          other.moyen == this.moyen &&
          other.reference == this.reference &&
          other.libelle == this.libelle &&
          other.etat == this.etat &&
          other.codeRejet == this.codeRejet &&
          other.motifRejet == this.motifRejet &&
          other.recuNumero == this.recuNumero &&
          other.creeLe == this.creeLe);
}

class PaiementsEnAttenteCompanion extends UpdateCompanion<PaiementEnAttente> {
  final Value<String> id;
  final Value<int> utilisateurId;
  final Value<int> contratId;
  final Value<int> montant;
  final Value<String> devise;
  final Value<String> datePaiement;
  final Value<String> moyen;
  final Value<String?> reference;
  final Value<String> libelle;
  final Value<String> etat;
  final Value<String?> codeRejet;
  final Value<String?> motifRejet;
  final Value<String?> recuNumero;
  final Value<DateTime> creeLe;
  final Value<int> rowid;
  const PaiementsEnAttenteCompanion({
    this.id = const Value.absent(),
    this.utilisateurId = const Value.absent(),
    this.contratId = const Value.absent(),
    this.montant = const Value.absent(),
    this.devise = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.moyen = const Value.absent(),
    this.reference = const Value.absent(),
    this.libelle = const Value.absent(),
    this.etat = const Value.absent(),
    this.codeRejet = const Value.absent(),
    this.motifRejet = const Value.absent(),
    this.recuNumero = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaiementsEnAttenteCompanion.insert({
    required String id,
    required int utilisateurId,
    required int contratId,
    required int montant,
    required String devise,
    required String datePaiement,
    required String moyen,
    this.reference = const Value.absent(),
    required String libelle,
    this.etat = const Value.absent(),
    this.codeRejet = const Value.absent(),
    this.motifRejet = const Value.absent(),
    this.recuNumero = const Value.absent(),
    required DateTime creeLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       utilisateurId = Value(utilisateurId),
       contratId = Value(contratId),
       montant = Value(montant),
       devise = Value(devise),
       datePaiement = Value(datePaiement),
       moyen = Value(moyen),
       libelle = Value(libelle),
       creeLe = Value(creeLe);
  static Insertable<PaiementEnAttente> custom({
    Expression<String>? id,
    Expression<int>? utilisateurId,
    Expression<int>? contratId,
    Expression<int>? montant,
    Expression<String>? devise,
    Expression<String>? datePaiement,
    Expression<String>? moyen,
    Expression<String>? reference,
    Expression<String>? libelle,
    Expression<String>? etat,
    Expression<String>? codeRejet,
    Expression<String>? motifRejet,
    Expression<String>? recuNumero,
    Expression<DateTime>? creeLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (utilisateurId != null) 'utilisateur_id': utilisateurId,
      if (contratId != null) 'contrat_id': contratId,
      if (montant != null) 'montant': montant,
      if (devise != null) 'devise': devise,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (moyen != null) 'moyen': moyen,
      if (reference != null) 'reference': reference,
      if (libelle != null) 'libelle': libelle,
      if (etat != null) 'etat': etat,
      if (codeRejet != null) 'code_rejet': codeRejet,
      if (motifRejet != null) 'motif_rejet': motifRejet,
      if (recuNumero != null) 'recu_numero': recuNumero,
      if (creeLe != null) 'cree_le': creeLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaiementsEnAttenteCompanion copyWith({
    Value<String>? id,
    Value<int>? utilisateurId,
    Value<int>? contratId,
    Value<int>? montant,
    Value<String>? devise,
    Value<String>? datePaiement,
    Value<String>? moyen,
    Value<String?>? reference,
    Value<String>? libelle,
    Value<String>? etat,
    Value<String?>? codeRejet,
    Value<String?>? motifRejet,
    Value<String?>? recuNumero,
    Value<DateTime>? creeLe,
    Value<int>? rowid,
  }) {
    return PaiementsEnAttenteCompanion(
      id: id ?? this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      contratId: contratId ?? this.contratId,
      montant: montant ?? this.montant,
      devise: devise ?? this.devise,
      datePaiement: datePaiement ?? this.datePaiement,
      moyen: moyen ?? this.moyen,
      reference: reference ?? this.reference,
      libelle: libelle ?? this.libelle,
      etat: etat ?? this.etat,
      codeRejet: codeRejet ?? this.codeRejet,
      motifRejet: motifRejet ?? this.motifRejet,
      recuNumero: recuNumero ?? this.recuNumero,
      creeLe: creeLe ?? this.creeLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (utilisateurId.present) {
      map['utilisateur_id'] = Variable<int>(utilisateurId.value);
    }
    if (contratId.present) {
      map['contrat_id'] = Variable<int>(contratId.value);
    }
    if (montant.present) {
      map['montant'] = Variable<int>(montant.value);
    }
    if (devise.present) {
      map['devise'] = Variable<String>(devise.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<String>(datePaiement.value);
    }
    if (moyen.present) {
      map['moyen'] = Variable<String>(moyen.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (libelle.present) {
      map['libelle'] = Variable<String>(libelle.value);
    }
    if (etat.present) {
      map['etat'] = Variable<String>(etat.value);
    }
    if (codeRejet.present) {
      map['code_rejet'] = Variable<String>(codeRejet.value);
    }
    if (motifRejet.present) {
      map['motif_rejet'] = Variable<String>(motifRejet.value);
    }
    if (recuNumero.present) {
      map['recu_numero'] = Variable<String>(recuNumero.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaiementsEnAttenteCompanion(')
          ..write('id: $id, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('contratId: $contratId, ')
          ..write('montant: $montant, ')
          ..write('devise: $devise, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('moyen: $moyen, ')
          ..write('reference: $reference, ')
          ..write('libelle: $libelle, ')
          ..write('etat: $etat, ')
          ..write('codeRejet: $codeRejet, ')
          ..write('motifRejet: $motifRejet, ')
          ..write('recuNumero: $recuNumero, ')
          ..write('creeLe: $creeLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseLocale extends GeneratedDatabase {
  _$BaseLocale(QueryExecutor e) : super(e);
  $BaseLocaleManager get managers => $BaseLocaleManager(this);
  late final $CacheReponsesTable cacheReponses = $CacheReponsesTable(this);
  late final $PaiementsEnAttenteTable paiementsEnAttente =
      $PaiementsEnAttenteTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cacheReponses,
    paiementsEnAttente,
  ];
}

typedef $$CacheReponsesTableCreateCompanionBuilder =
    CacheReponsesCompanion Function({
      required String cle,
      required int utilisateurId,
      required String json,
      required DateTime majLe,
      Value<int> rowid,
    });
typedef $$CacheReponsesTableUpdateCompanionBuilder =
    CacheReponsesCompanion Function({
      Value<String> cle,
      Value<int> utilisateurId,
      Value<String> json,
      Value<DateTime> majLe,
      Value<int> rowid,
    });

class $$CacheReponsesTableFilterComposer
    extends Composer<_$BaseLocale, $CacheReponsesTable> {
  $$CacheReponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get majLe => $composableBuilder(
    column: $table.majLe,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheReponsesTableOrderingComposer
    extends Composer<_$BaseLocale, $CacheReponsesTable> {
  $$CacheReponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get majLe => $composableBuilder(
    column: $table.majLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheReponsesTableAnnotationComposer
    extends Composer<_$BaseLocale, $CacheReponsesTable> {
  $$CacheReponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get majLe =>
      $composableBuilder(column: $table.majLe, builder: (column) => column);
}

class $$CacheReponsesTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $CacheReponsesTable,
          ReponseEnCache,
          $$CacheReponsesTableFilterComposer,
          $$CacheReponsesTableOrderingComposer,
          $$CacheReponsesTableAnnotationComposer,
          $$CacheReponsesTableCreateCompanionBuilder,
          $$CacheReponsesTableUpdateCompanionBuilder,
          (
            ReponseEnCache,
            BaseReferences<_$BaseLocale, $CacheReponsesTable, ReponseEnCache>,
          ),
          ReponseEnCache,
          PrefetchHooks Function()
        > {
  $$CacheReponsesTableTableManager(_$BaseLocale db, $CacheReponsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheReponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheReponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheReponsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cle = const Value.absent(),
                Value<int> utilisateurId = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> majLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheReponsesCompanion(
                cle: cle,
                utilisateurId: utilisateurId,
                json: json,
                majLe: majLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cle,
                required int utilisateurId,
                required String json,
                required DateTime majLe,
                Value<int> rowid = const Value.absent(),
              }) => CacheReponsesCompanion.insert(
                cle: cle,
                utilisateurId: utilisateurId,
                json: json,
                majLe: majLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CacheReponsesTable, ReponseEnCache>(table),
                  BaseReferences<
                    _$BaseLocale,
                    $CacheReponsesTable,
                    ReponseEnCache
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheReponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $CacheReponsesTable,
      ReponseEnCache,
      $$CacheReponsesTableFilterComposer,
      $$CacheReponsesTableOrderingComposer,
      $$CacheReponsesTableAnnotationComposer,
      $$CacheReponsesTableCreateCompanionBuilder,
      $$CacheReponsesTableUpdateCompanionBuilder,
      (
        ReponseEnCache,
        BaseReferences<_$BaseLocale, $CacheReponsesTable, ReponseEnCache>,
      ),
      ReponseEnCache,
      PrefetchHooks Function()
    >;
typedef $$PaiementsEnAttenteTableCreateCompanionBuilder =
    PaiementsEnAttenteCompanion Function({
      required String id,
      required int utilisateurId,
      required int contratId,
      required int montant,
      required String devise,
      required String datePaiement,
      required String moyen,
      Value<String?> reference,
      required String libelle,
      Value<String> etat,
      Value<String?> codeRejet,
      Value<String?> motifRejet,
      Value<String?> recuNumero,
      required DateTime creeLe,
      Value<int> rowid,
    });
typedef $$PaiementsEnAttenteTableUpdateCompanionBuilder =
    PaiementsEnAttenteCompanion Function({
      Value<String> id,
      Value<int> utilisateurId,
      Value<int> contratId,
      Value<int> montant,
      Value<String> devise,
      Value<String> datePaiement,
      Value<String> moyen,
      Value<String?> reference,
      Value<String> libelle,
      Value<String> etat,
      Value<String?> codeRejet,
      Value<String?> motifRejet,
      Value<String?> recuNumero,
      Value<DateTime> creeLe,
      Value<int> rowid,
    });

class $$PaiementsEnAttenteTableFilterComposer
    extends Composer<_$BaseLocale, $PaiementsEnAttenteTable> {
  $$PaiementsEnAttenteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contratId => $composableBuilder(
    column: $table.contratId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montant => $composableBuilder(
    column: $table.montant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get devise => $composableBuilder(
    column: $table.devise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moyen => $composableBuilder(
    column: $table.moyen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libelle => $composableBuilder(
    column: $table.libelle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etat => $composableBuilder(
    column: $table.etat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeRejet => $composableBuilder(
    column: $table.codeRejet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motifRejet => $composableBuilder(
    column: $table.motifRejet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recuNumero => $composableBuilder(
    column: $table.recuNumero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaiementsEnAttenteTableOrderingComposer
    extends Composer<_$BaseLocale, $PaiementsEnAttenteTable> {
  $$PaiementsEnAttenteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contratId => $composableBuilder(
    column: $table.contratId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montant => $composableBuilder(
    column: $table.montant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get devise => $composableBuilder(
    column: $table.devise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moyen => $composableBuilder(
    column: $table.moyen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libelle => $composableBuilder(
    column: $table.libelle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etat => $composableBuilder(
    column: $table.etat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeRejet => $composableBuilder(
    column: $table.codeRejet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motifRejet => $composableBuilder(
    column: $table.motifRejet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recuNumero => $composableBuilder(
    column: $table.recuNumero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaiementsEnAttenteTableAnnotationComposer
    extends Composer<_$BaseLocale, $PaiementsEnAttenteTable> {
  $$PaiementsEnAttenteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get utilisateurId => $composableBuilder(
    column: $table.utilisateurId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contratId =>
      $composableBuilder(column: $table.contratId, builder: (column) => column);

  GeneratedColumn<int> get montant =>
      $composableBuilder(column: $table.montant, builder: (column) => column);

  GeneratedColumn<String> get devise =>
      $composableBuilder(column: $table.devise, builder: (column) => column);

  GeneratedColumn<String> get datePaiement => $composableBuilder(
    column: $table.datePaiement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moyen =>
      $composableBuilder(column: $table.moyen, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get libelle =>
      $composableBuilder(column: $table.libelle, builder: (column) => column);

  GeneratedColumn<String> get etat =>
      $composableBuilder(column: $table.etat, builder: (column) => column);

  GeneratedColumn<String> get codeRejet =>
      $composableBuilder(column: $table.codeRejet, builder: (column) => column);

  GeneratedColumn<String> get motifRejet => $composableBuilder(
    column: $table.motifRejet,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recuNumero => $composableBuilder(
    column: $table.recuNumero,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);
}

class $$PaiementsEnAttenteTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $PaiementsEnAttenteTable,
          PaiementEnAttente,
          $$PaiementsEnAttenteTableFilterComposer,
          $$PaiementsEnAttenteTableOrderingComposer,
          $$PaiementsEnAttenteTableAnnotationComposer,
          $$PaiementsEnAttenteTableCreateCompanionBuilder,
          $$PaiementsEnAttenteTableUpdateCompanionBuilder,
          (
            PaiementEnAttente,
            BaseReferences<
              _$BaseLocale,
              $PaiementsEnAttenteTable,
              PaiementEnAttente
            >,
          ),
          PaiementEnAttente,
          PrefetchHooks Function()
        > {
  $$PaiementsEnAttenteTableTableManager(
    _$BaseLocale db,
    $PaiementsEnAttenteTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaiementsEnAttenteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaiementsEnAttenteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaiementsEnAttenteTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> utilisateurId = const Value.absent(),
                Value<int> contratId = const Value.absent(),
                Value<int> montant = const Value.absent(),
                Value<String> devise = const Value.absent(),
                Value<String> datePaiement = const Value.absent(),
                Value<String> moyen = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String> libelle = const Value.absent(),
                Value<String> etat = const Value.absent(),
                Value<String?> codeRejet = const Value.absent(),
                Value<String?> motifRejet = const Value.absent(),
                Value<String?> recuNumero = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaiementsEnAttenteCompanion(
                id: id,
                utilisateurId: utilisateurId,
                contratId: contratId,
                montant: montant,
                devise: devise,
                datePaiement: datePaiement,
                moyen: moyen,
                reference: reference,
                libelle: libelle,
                etat: etat,
                codeRejet: codeRejet,
                motifRejet: motifRejet,
                recuNumero: recuNumero,
                creeLe: creeLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int utilisateurId,
                required int contratId,
                required int montant,
                required String devise,
                required String datePaiement,
                required String moyen,
                Value<String?> reference = const Value.absent(),
                required String libelle,
                Value<String> etat = const Value.absent(),
                Value<String?> codeRejet = const Value.absent(),
                Value<String?> motifRejet = const Value.absent(),
                Value<String?> recuNumero = const Value.absent(),
                required DateTime creeLe,
                Value<int> rowid = const Value.absent(),
              }) => PaiementsEnAttenteCompanion.insert(
                id: id,
                utilisateurId: utilisateurId,
                contratId: contratId,
                montant: montant,
                devise: devise,
                datePaiement: datePaiement,
                moyen: moyen,
                reference: reference,
                libelle: libelle,
                etat: etat,
                codeRejet: codeRejet,
                motifRejet: motifRejet,
                recuNumero: recuNumero,
                creeLe: creeLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaiementsEnAttenteTable, PaiementEnAttente>(
                    table,
                  ),
                  BaseReferences<
                    _$BaseLocale,
                    $PaiementsEnAttenteTable,
                    PaiementEnAttente
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaiementsEnAttenteTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $PaiementsEnAttenteTable,
      PaiementEnAttente,
      $$PaiementsEnAttenteTableFilterComposer,
      $$PaiementsEnAttenteTableOrderingComposer,
      $$PaiementsEnAttenteTableAnnotationComposer,
      $$PaiementsEnAttenteTableCreateCompanionBuilder,
      $$PaiementsEnAttenteTableUpdateCompanionBuilder,
      (
        PaiementEnAttente,
        BaseReferences<
          _$BaseLocale,
          $PaiementsEnAttenteTable,
          PaiementEnAttente
        >,
      ),
      PaiementEnAttente,
      PrefetchHooks Function()
    >;

class $BaseLocaleManager {
  final _$BaseLocale _db;
  $BaseLocaleManager(this._db);
  $$CacheReponsesTableTableManager get cacheReponses =>
      $$CacheReponsesTableTableManager(_db, _db.cacheReponses);
  $$PaiementsEnAttenteTableTableManager get paiementsEnAttente =>
      $$PaiementsEnAttenteTableTableManager(_db, _db.paiementsEnAttente);
}
