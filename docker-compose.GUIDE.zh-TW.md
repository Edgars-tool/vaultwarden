> 繁體中文版。原始文件：docker-compose.yml（英文）

# docker-compose.yml 技術解說

## 這個檔案做什麼
這份 Compose file（Compose 設定檔）位於 `playwright` 目錄，主要用來建立 Vaultwarden 與 Playwright（端對端測試框架）相關的整合測試環境。它同時管理預建映像、主服務、測試容器、資料庫、Maildev 與 Keycloak。

## 主要區塊說明
1. **`VaultwardenPrebuild`**
   - 使用 repo 根目錄當 build context（建置來源），先建立預建映像。
   - 透過 profile（設定檔）控制是否啟動。
2. **`Vaultwarden`**
   - 真正的測試用 Vaultwarden 容器。
   - `network_mode: "host"` 代表直接使用主機網路。
   - 讀取 `DC_ENV_FILE` 指定的 `.env`，並暴露多個與 SSO（單一登入）與 mail 相關的環境變數。
3. **`Playwright`**
   - 建立 Playwright 測試容器。
   - 掛載 `/var/run/docker.sock` 與整個 repo，方便測試腳本直接操作 Docker 與專案檔案。
4. **資料庫服務：`Mariadb` / `Mysql` / `Postgres`**
   - 各自有獨立 image（映像）、`env_file` 與 healthcheck（健康檢查）。
   - port（埠號）由環境變數控制。
5. **`Maildev`**
   - 提供 SMTP（郵件測試）與 Web UI，用於測試寄信流程。
6. **`Keycloak` 與 `KeycloakSetup`**
   - 用來建立 OIDC / SSO 測試環境。
   - `KeycloakSetup` 依賴 `Keycloak`，負責初始化設定。

## 常用指令
```bash
docker compose -f playwright/docker-compose.yml config
docker compose -f playwright/docker-compose.yml --profile playwright up --build
docker compose -f playwright/docker-compose.yml --profile keycloak up
docker compose -f playwright/docker-compose.yml down
```

## 注意事項
- 這份檔案以測試與開發情境為主，不是生產環境部署範本。
- 多個服務使用 `network_mode: "host"`，在 Linux 與 macOS / Windows 的實際行為可能不同。
- `profiles` 是啟動關鍵；若沒有帶對 profile，很多服務不會被建立。
- ⚠️ 此處需人工確認：若在非 Linux Docker 環境使用 `host` network，需先確認平台是否完整支援。
