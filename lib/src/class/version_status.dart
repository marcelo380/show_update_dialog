class VersionStatus {
  /// Retorna versão atual do aplicativo
  final String localVersion;

  /// retorna versão mais recente do seu aplicativo na loja
  final String storeVersion;

  /// Um link para a página da loja de aplicativos
  final String appStoreLink;

  /// informações das notas de atualizações da loja
  final String? releaseNotes;

  /// retorna [true] se existir atualização
  bool get updateExist {
    // ajusta string xx.yy.zz
    try {
      final localFields = localVersion.split('.');
      final storeFields = storeVersion.split('.');
      String localPad = '';
      String storePad = '';
      for (int i = 0; i < storeFields.length; i++) {
        localPad = localPad + localFields[i].padLeft(3, '0');
        storePad = storePad + storeFields[i].padLeft(3, '0');
      }

      if (localPad.compareTo(storePad) < 0)
        return true;
      else
        return false;
    } catch (e) {
      return localVersion.compareTo(storeVersion).isNegative;
    }
  }

  VersionStatus({
    required this.localVersion,
    required this.storeVersion,
    required this.appStoreLink,
    this.releaseNotes,
  });
}
