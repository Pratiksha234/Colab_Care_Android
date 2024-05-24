import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final EncryptionService shared = EncryptionService._();

  // Explicitly use a static key for simplicity. In real applications, consider securely storing and accessing keys.
  static final _key = Key.fromUtf8('89515161427019334556716426970412');
  static final _iv = IV.fromUtf8('initializationvector');
  final Encrypter _encrypter;

  EncryptionService._()
      : _encrypter = Encrypter(AES(_key, mode: AESMode.ecb, padding: 'PKCS7'));

  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    print("Encrypted data: ${encrypted.base64}");
    return encrypted.base64;
  }

  String decrypt(String encryptedBase64) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedBase64);
      var decrypted = _encrypter.decrypt(encrypted, iv: _iv);

      return decrypted;
    } catch (e) {
      print("Decryption error: $e");
      return "Decryption failed";
    }
  }
}
