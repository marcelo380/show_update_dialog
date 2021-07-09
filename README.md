# show_update_dialog

Este pacote tem como objetivo ajudar a manter aplicativos Android e IOS atualizados, permitindo fazer a configuração para avisar automaticamente seus usuários sobre as atualizações.
Basta inserir o bundleID da appleStore e  androidId que o package faz comunicação direta comparando a versão da loja com a local. 

[<img src="https://github.com/marcelo380/show_update_dialog/blob/main/readme_resources/sc01.png?raw=true" width="300"/>](https://github.com/marcelo380/show_update_dialog/blob/main/readme_resources/sc01.png?raw=true)
## Referências 

Existe varias propriedades para customizar, aqui está uma ficha rápida:
Propriedade  | O que faz?
--------  | ---------------
iOSId      | BundleID da appstore, responsável por buscar versão e notas da loja.
androidId   | AndroidID playstore, responsável por buscar a versão e notas na playStore.
iOSAppStoreCountry     | Atenção você precisa definir esse parametro se seu app estiver publicado fora dos EUA. Basta informar a sigla do pais ex: 'BR', consulte em:  [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
title     | É usado para mudar o titulo padrão do aviso da atualização.
buttonColor     | Pode passar uma cor para o botão de atulização ex: `Colors.blue`
buttonText     | É utilizado para alterar o  texto do botão de atualização.
forceUpdate    | Marcar `true` para esconder botão e impedir usuário de fechar a janela de atualização, forçando assim o usuário a atualizar o aplicativo. 
bodyoverride     | Sobrescreve todo o body do showCustomDialogUpdate, você pode passar um widget completo. 
overridebottomNavigationBar    | Sobrescreve a bottomNavigationBar que contem o botão de atualizar. 


## Variavel do status da versão

Você pode utilizar informações da versão do seu app e loja de outras formas.

Variavel |  O que faz?
-------- | ---------------
localVersion    | Retorna versão local do seu aplicativo.
appStoreLink    | Retorna o link da loja baseado no sistema.
storeVersion    | Ultima versão da loja de aplicativos.
releaseNotes    | Retorna as notas de atualizações da loja de aplicativo.

Exemplo de implementação:

```dart
    final versionCheck = ShowUpdateDialog(
        iOSId: 'com.dts.freefireth',
        androidId: 'com.dts.freefireth',
        iOSAppStoreCountry: 'BR');

    final VersionModel vs = await versionCheck.fetchVersionInfo();

    print(vs.localVersion);
    print(vs.appStoreLink);
    print(vs.storeVersion);
    print(vs.releaseNotes);
```






### Como começar


Está é a forma de implementação mais simples, basta colocar no seu initState. O basico para iniciar é saber se você quer obrigar o usuário a atualizar, se sim, você precisar marcar true em `forceUpdate`. É importante saber se seu app está publicado apenas fora dos EUA, se sim você precisa definir a propriedade `iOSAppStoreCountry`.




### Implementação simples

Está é a forma de implementação mais simples, basta colocar no seu initState.
```dart
  @override
  void initState() {
    final versionCheck = ShowUpdateDialog(
        iOSId: 'com.dts.freefireth',
        androidId: 'com.dts.freefireth',
        iOSAppStoreCountry: 'BR');

    versionCheck.showSimplesDialog(context);
  }
```


### Implementação com custumização da tela

Está é uma das formas de alterar a tela de atualização. 
```dart
verifyVersion() async {
    final versionCheck = ShowUpdateDialog(
        iOSId: 'com.dts.freefireth',
        androidId: 'com.dts.freefireth',
        iOSAppStoreCountry: 'BR');

    final VersionModel vs = await versionCheck.fetchVersionInfo();
    versionCheck.showCustomDialogUpdate(
      context: context,
      versionStatus: vs,
      buttonColor: Colors.black,
      buttonText: "Update :D",
      title: "Estamos mais novos do que nunca!",
      forceUpdate: true,
    );
  }
```

### Implementação com widget customizado
[<img src="https://github.com/marcelo380/show_update_dialog/blob/main/readme_resources/sc02.png?raw=true" width="300"/>](https://github.com/marcelo380/show_update_dialog/blob/main/readme_resources/sc02.png?raw=true)


Implementando destá forma você pode refazer a tela da forma que preferir basta passar um Widget.
```dart
  verifyVersion() async {
    final versionCheck = ShowUpdateDialog(
        iOSId: 'com.dts.freefireth',
        androidId: 'com.dts.freefireth',
        iOSAppStoreCountry: 'BR');

    final VersionModel vs = await versionCheck.fetchVersionInfo();

    versionCheck.showCustomDialogUpdate(
      context: context,
      versionStatus: vs,
      buttonText: "Update",
      buttonColor: Colors.green,
      bodyoverride: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.update,
                size: 150,
                color: Colors.green,
              ),
            ],
          ),
          Text(
            "Please update your app",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          Text(
            "Local version: ${vs.localVersion}",
            style: TextStyle(fontSize: 17),
          ),
          Text(
            "Store version: ${vs.storeVersion}",
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 30),
          Text(
            "${vs.releaseNotes}",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
  }
```
