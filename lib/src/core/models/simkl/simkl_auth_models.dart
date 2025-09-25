// Simkl Authentication Models
// Based on Simkl API Blueprint v1A

/// Simkl Authentication Response
class SimklAuthResponse {
  final String accessToken;
  final String tokenType;
  final String scope;

  const SimklAuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
  });

  factory SimklAuthResponse.fromJson(Map<String, dynamic> json) {
    return SimklAuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'scope': scope,
    };
  }

  @override
  String toString() =>
      'SimklAuthResponse(accessToken: $accessToken, tokenType: $tokenType, scope: $scope)';
}

/// Simkl PIN Request
class SimklPinRequest {
  final String clientId;
  final String? redirect;

  const SimklPinRequest({required this.clientId, this.redirect});

  Map<String, dynamic> toJson() {
    return {'client_id': clientId, if (redirect != null) 'redirect': redirect};
  }

  @override
  String toString() =>
      'SimklPinRequest(clientId: $clientId, redirect: $redirect)';
}

/// Simkl PIN Response
class SimklPinResponse {
  final String result;
  final String deviceCode;
  final String userCode;
  final String verificationUrl;
  final int expiresIn;
  final int interval;

  const SimklPinResponse({
    required this.result,
    required this.deviceCode,
    required this.userCode,
    required this.verificationUrl,
    required this.expiresIn,
    required this.interval,
  });

  factory SimklPinResponse.fromJson(Map<String, dynamic> json) {
    return SimklPinResponse(
      result: json['result'] as String,
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUrl: json['verification_url'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'device_code': deviceCode,
      'user_code': userCode,
      'verification_url': verificationUrl,
      'expires_in': expiresIn,
      'interval': interval,
    };
  }

  @override
  String toString() =>
      'SimklPinResponse(userCode: $userCode, verificationUrl: $verificationUrl)';
}

/// Simkl PIN Status Response
class SimklPinStatusResponse {
  final String result;
  final String? message;
  final String? accessToken;
  final String? tokenType;
  final String? scope;

  const SimklPinStatusResponse({
    required this.result,
    this.message,
    this.accessToken,
    this.tokenType,
    this.scope,
  });

  factory SimklPinStatusResponse.fromJson(Map<String, dynamic> json) {
    return SimklPinStatusResponse(
      result: json['result'] as String,
      message: json['message'] as String?,
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      scope: json['scope'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      if (message != null) 'message': message,
      if (accessToken != null) 'access_token': accessToken,
      if (tokenType != null) 'token_type': tokenType,
      if (scope != null) 'scope': scope,
    };
  }

  bool get isAuthorized => result == 'OK' && accessToken != null;

  @override
  String toString() =>
      'SimklPinStatusResponse(result: $result, authorized: $isAuthorized)';
}

/// Simkl Token Request
class SimklTokenRequest {
  final String code;
  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final String grantType;

  const SimklTokenRequest({
    required this.code,
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.grantType,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
      'grant_type': grantType,
    };
  }

  @override
  String toString() => 'SimklTokenRequest(code: $code, grantType: $grantType)';
}

/// Simkl User Settings
class SimklUserSettings {
  final SimklUser user;
  final SimklAccount account;
  final SimklConnections connections;

  const SimklUserSettings({
    required this.user,
    required this.account,
    required this.connections,
  });

  factory SimklUserSettings.fromJson(Map<String, dynamic> json) {
    return SimklUserSettings(
      user: SimklUser.fromJson(json['user'] as Map<String, dynamic>),
      account: SimklAccount.fromJson(json['account'] as Map<String, dynamic>),
      connections: SimklConnections.fromJson(
        json['connections'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'account': account.toJson(),
      'connections': connections.toJson(),
    };
  }

  @override
  String toString() =>
      'SimklUserSettings(user: ${user.name}, account: ${account.id})';
}

/// Simkl User
class SimklUser {
  final String name;
  final String joinedAt;
  final String? gender;
  final String? avatar;
  final String? bio;
  final String? location;
  final String? age;

  const SimklUser({
    required this.name,
    required this.joinedAt,
    this.gender,
    this.avatar,
    this.bio,
    this.location,
    this.age,
  });

  factory SimklUser.fromJson(Map<String, dynamic> json) {
    return SimklUser(
      name: json['name'] as String,
      joinedAt: json['joined_at'] as String,
      gender: json['gender'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      location: json['loc'] as String?,
      age: json['age'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'joined_at': joinedAt,
      if (gender != null) 'gender': gender,
      if (avatar != null) 'avatar': avatar,
      if (bio != null) 'bio': bio,
      if (location != null) 'loc': location,
      if (age != null) 'age': age,
    };
  }

  @override
  String toString() => 'SimklUser(name: $name, joinedAt: $joinedAt)';
}

/// Simkl Account
class SimklAccount {
  final int id;
  final String timezone;
  final String type;

  const SimklAccount({
    required this.id,
    required this.timezone,
    required this.type,
  });

  factory SimklAccount.fromJson(Map<String, dynamic> json) {
    return SimklAccount(
      id: json['id'] as int,
      timezone: json['timezone'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'timezone': timezone, 'type': type};
  }

  @override
  String toString() => 'SimklAccount(id: $id, type: $type)';
}

/// Simkl Connections
class SimklConnections {
  final bool facebook;
  final bool? twitter;
  final bool? google;
  final bool? discord;

  const SimklConnections({
    required this.facebook,
    this.twitter,
    this.google,
    this.discord,
  });

  factory SimklConnections.fromJson(Map<String, dynamic> json) {
    return SimklConnections(
      facebook: json['facebook'] as bool,
      twitter: json['twitter'] as bool?,
      google: json['google'] as bool?,
      discord: json['discord'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      if (twitter != null) 'twitter': twitter,
      if (google != null) 'google': google,
      if (discord != null) 'discord': discord,
    };
  }

  @override
  String toString() => 'SimklConnections(facebook: $facebook)';
}

/// Authentication State Enum
enum SimklAuthState {
  initial,
  loading,
  authenticated,
  error,
  pinRequired,
  pinPending,
  pinExpired,
}

/// Authentication Error
class SimklAuthError {
  final String message;
  final String? code;
  final int? statusCode;

  const SimklAuthError({required this.message, this.code, this.statusCode});

  @override
  String toString() => 'SimklAuthError(message: $message, code: $code)';
}
