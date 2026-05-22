> 繁體中文版。原始文件：README.md（英文）

# Vaultwarden（Bitwarden Client API 替代伺服器實作）

Vaultwarden 是 Bitwarden Client API（Bitwarden 用戶端 API）的替代 server implementation（伺服器實作），以 Rust 撰寫，並與 [官方 Bitwarden clients](https://bitwarden.com/download/) 相容。它特別適合 self-hosted deployment（自架部署），尤其是在官方服務較為耗資源的情況下。

> **重要：** 若使用 Vaultwarden 時遇到問題，應向 Vaultwarden 社群回報，不要使用官方 Bitwarden 支援管道。

## Features（功能）

Vaultwarden 幾乎完整實作 Bitwarden Client API，包含：

- Personal Vault（個人保險庫）
- Send（安全傳送）
- Attachments（附件）
- Website icons（網站圖示）
- Personal API Key（個人 API 金鑰）
- Organizations（組織）
  - Collections（集合）
  - Password Sharing（密碼分享）
  - Member Roles（成員角色）
  - Groups（群組）
  - Event Logs（事件紀錄）
  - Admin Password Reset（管理員密碼重設）
  - Directory Connector（目錄同步）
  - Policies（政策）
- Multi/Two Factor Authentication（雙因素驗證）
  - Authenticator
  - Email
  - FIDO2 WebAuthn
  - YubiKey
  - Duo
- Emergency Access（緊急存取）
- Vaultwarden Admin Backend（管理後台）
- 修改版 Web Vault client（內建於官方容器映像）

## Usage（使用方式）

> **重要：** Web Vault（網頁保險庫）需要 secure context（安全上下文）才能使用 Web Crypto API。這代表它只能在 `http://localhost:8000` 這類本機位址運作，或必須額外啟用 HTTPS。

官方建議的安裝方式是直接使用已發布的 container image（容器映像），可從：

- `ghcr.io`
- `docker.io`
- `quay.io`

也可以選用 community packages（社群封裝），但版本可能落後，或採用不同的 configuration（設定）方式。若需要完全掌控，也可以自行 build（建置）Vaultwarden。

雖然 Vaultwarden 建基於 Rocket web framework（網頁框架），並具備內建 TLS 支援，但官方仍建議搭配 reverse proxy（反向代理）使用。

### Docker/Podman CLI

先拉取 container image，再掛載 host volume（主機磁碟卷）以保存資料。若偏好 Podman，也可把 `docker` 改成 `podman`。

```shell
docker pull vaultwarden/server:latest
docker run --detach --name vaultwarden \
  --env DOMAIN="https://vw.domain.tld" \
  --volume /vw-data/:/data/ \
  --restart unless-stopped \
  --publish 127.0.0.1:8000:80 \
  vaultwarden/server:latest
```

以上設定會把持久化資料保存在 `/vw-data/`。

### Docker Compose

若使用 Docker Compose，需要建立 `compose.yaml`，並把 Vaultwarden 服務配置寫進去。

```yaml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      DOMAIN: "https://vw.domain.tld"
    volumes:
      - ./vw-data/:/data/
    ports:
      - 127.0.0.1:8000:80
```

## Get in touch（聯絡與求助）

若有問題、建議或需要協助，可透過以下社群管道聯絡：

- [Matrix](https://matrix.to/#/#vaultwarden:matrix.org)
- [GitHub Discussions](https://github.com/dani-garcia/vaultwarden/discussions)
- [Discourse Forums](https://vaultwarden.discourse.group/)

若遇到 bug（錯誤）或 crash（當機），建議先搜尋 issue tracker（問題追蹤）與討論區，確認是否已被回報；若沒有，再建立新討論或 issue。

## Contributors（貢獻者）

專案歡迎社群貢獻。README 也提供了貢獻者統計與頭像展示連結，方便查看社群參與情況。

## Disclaimer（免責聲明）

這個專案**不是** Bitwarden 官方產品，也不隸屬於 Bitwarden, Inc.

雖然 Vaultwarden 有活躍維護者同時在 Bitwarden 任職，但其對專案的貢獻是以個人時間進行，並由其他維護者共同審查。專案方向主要服務 self-hosting community（自架社群），包含個人、家庭與小型組織。

Vaultwarden 維護者不對任何資料遺失負責，包括密碼、附件與其他應用資料。官方強烈建議定期備份檔案與資料庫。

## Bitwarden_RS（舊名稱）

這個專案過去名為 `Bitwarden_RS`，後來改名為 `Vaultwarden`，目的是與官方 Bitwarden server 明確區隔，避免品牌與商標上的混淆。
