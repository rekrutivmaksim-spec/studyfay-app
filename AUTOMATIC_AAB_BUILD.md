# Автоматическая сборка подписанного AAB (без Android Studio)

Цель: получить готовый **подписанный** `*.aab` через GitHub Actions.

## 1) Сделай keystore + Base64 (Windows)
Открой PowerShell в корне проекта:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows\make_keystore_for_github.ps1
```

Скрипт создаст:
- `keystore\studyfay-release.jks`
- `keystore\studyfay-release.base64.txt`

## 2) Залей проект на GitHub
Создай репозиторий и загрузи файлы проекта (через **Upload files**).

## 3) Добавь Secrets
Repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Добавь 4 секрета:
- `KEYSTORE_BASE64` — вставь содержимое `keystore\studyfay-release.base64.txt`
- `KEYSTORE_PASSWORD` — пароль keystore
- `KEY_ALIAS` — alias (например `studyfay`)
- `KEY_PASSWORD` — пароль ключа

## 4) Получи AAB
Repo → **Actions** → workflow **RuStore Signed AAB (Studyfay)** → **Run workflow**

Скачай artifact `studyfay-release-aab`.
