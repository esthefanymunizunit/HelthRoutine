# Setup mobile — Android e iOS

Este projeto está configurado pra rodar em **Web**, **Android** e **iOS** no Firebase
(`healthroutine-unit-2026`). O setup inicial via `flutterfire configure` já está commitado:

- `lib/firebase_options.dart` — configs das 3 plataformas
- `android/app/google-services.json` — config Android
- `android/settings.gradle.kts` e `android/app/build.gradle.kts` — plugin Google Services aplicado
- `ios/Runner/Info.plist` — URL scheme `REVERSED_CLIENT_ID` pro Google Sign-In

Web já roda direto (`flutter run -d chrome`). Android e iOS exigem etapas
locais que **só funcionam na máquina de quem vai testar**. Veja abaixo.

---

## Android

### Pré-requisitos
1. **Android Studio** instalado (https://developer.android.com/studio)
2. **Android SDK** configurado (Android Studio instala automaticamente na 1ª vez)
3. **Emulador Android** rodando ou **celular Android** com USB Debugging ligado

### Verificar
```powershell
flutter doctor
```
Linha `Android toolchain` deve estar com ✅. Se ❌, abrir Android Studio uma vez
e seguir os prompts do Setup Wizard.

### Cadastrar SHA-1 no Firebase (obrigatório pra Google Sign-In)

Sem o SHA-1, login com email/senha funciona mas **login Google não funciona**
no Android.

**1. Gerar o SHA-1 do keystore de debug:**
```powershell
# Windows
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```
```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Vai listar várias linhas — copia o valor da linha **"SHA1"** (formato `XX:XX:XX:...`).

**2. Adicionar no Firebase Console:**
- Acesse https://console.firebase.google.com/project/healthroutine-unit-2026/settings/general
- Role até **"Apps"** → app **Android** (`com.example.healthroutine`)
- **"Add fingerprint"** → cole o SHA-1 → **Save**
- **Baixe o novo `google-services.json`** (botão no canto direito do app Android) e substitua o `android/app/google-services.json` no projeto

**3. Cada dev do time precisa repetir essas etapas com o SHA-1 da própria máquina**
(o SHA-1 é único por keystore, que é único por máquina).

### Rodar
```powershell
flutter run -d <id-do-device-android>
# ou: flutter run (escolhe automaticamente)
```

---

## iOS

### ⚠️ iOS só pode ser desenvolvido em macOS com Xcode

- Não dá pra buildar/rodar iOS no Windows
- Precisa de **Mac com Xcode 15+** instalado
- Precisa de **conta Apple Developer** (gratuita serve pra simulador, paga pra device físico)

### Pré-requisitos no Mac
1. **Xcode** instalado via App Store
2. **Cocoapods**:
   ```bash
   sudo gem install cocoapods
   ```
3. **Simulador iOS** ou device físico

### Etapa 1 — Baixar o `GoogleService-Info.plist`

O `flutterfire configure` rodado no Windows **não criou** esse arquivo (limitação
da plataforma). É necessário fazer manualmente:

- Acesse https://console.firebase.google.com/project/healthroutine-unit-2026/settings/general
- Role até **"Apps"** → app **iOS** (`com.example.healthroutine`)
- **Download GoogleService-Info.plist**
- Salve em `ios/Runner/GoogleService-Info.plist` no projeto

### Etapa 2 — Adicionar ao Xcode

Abra `ios/Runner.xcworkspace` no Xcode → arrasta o `GoogleService-Info.plist`
pra dentro da pasta **Runner** no navigator esquerdo. Marca a opção
**"Copy items if needed"** e **target Runner**.

### Etapa 3 — Instalar pods
```bash
cd ios
pod install
cd ..
```

### Etapa 4 — Rodar
```bash
flutter run -d <id-do-simulador-ou-device>
```

---

## Validação pós-setup

Após cada plataforma estar rodando, valida estes fluxos:

| Fluxo | Esperado |
|---|---|
| Login email/senha com conta `@souunit.com.br` | Entra no app |
| Login com email/senha **fora do domínio** | Bloqueado com SnackBar de erro |
| Login Google escolhendo conta `@souunit.com.br` | Entra no app |
| Login Google escolhendo conta `@gmail.com` | Bloqueado |
| Criar tarefa via FAB | Aparece na home em tempo real |
| Long-press na tarefa | Dialog de confirmação → delete |
| Logout (Profile → Sair) | Volta pra LoginScreen |

---

## Troubleshooting comum

### Android: `Default FirebaseApp is not initialized`
- `google-services.json` está em `android/app/` ?
- Plugin `com.google.gms.google-services` aplicado no `app/build.gradle.kts` ?

### Android: Google Sign-In retorna `ApiException: 10`
- SHA-1 da máquina **não foi cadastrado** no Firebase Console
- Depois de cadastrar, **baixar o novo `google-services.json`** e substituir

### iOS: build falha com erro de pod
- Rodou `pod install` em `ios/` ?
- Versão mínima do iOS no Podfile é 13.0+? Editar `ios/Podfile`:
  ```
  platform :ios, '13.0'
  ```

### iOS: Google Sign-In abre e fecha sem fazer nada
- `CFBundleURLTypes` no `Info.plist` está com o `REVERSED_CLIENT_ID` correto?
- O `GoogleService-Info.plist` foi adicionado ao **target Runner** no Xcode?
