> 繁體中文版。原始文件：Cargo.toml（英文）

# Cargo.toml 技術解說

## 這個檔案做什麼
`Cargo.toml` 是 Rust 專案的 package manifest（套件資訊清單）。在 Vaultwarden 中，它不只描述單一 crate（套件），還同時負責 workspace（工作區）設定、feature flags（功能旗標）、依賴管理、build profile（建置設定檔）與 lint（靜態檢查）規則。

## 主要區塊說明
1. **`[workspace.package]` 與 `[workspace]`**
   - 定義共用的 edition（語言版本）、`rust-version`、license（授權）與 repository。
   - `members = ["macros"]` 表示這個 repo 不是單一 crate，而是包含 `macros` 子 crate 的 workspace。
2. **`[package]`**
   - 定義主套件 `vaultwarden` 的名稱、版本、作者、`readme`、`build.rs` 與 `resolver = "2"`。
   - 其中 `repository.workspace = true` 等欄位代表沿用 workspace 的共用設定。
3. **`[features]`：可選功能**
   - 預設 feature（功能）清單為空，代表資料庫類型需自行選擇。
   - 可用 `mysql`、`postgresql`、`sqlite` 切換資料庫驅動。
   - 另有 `vendored_openssl`、`enable_mimalloc`、`s3`、OIDC 相關功能與 `unstable`。
4. **`[target."cfg(unix)".dependencies]`**
   - 只在 Unix 平台加入 `syslog`，用於 system log（系統日誌）。
5. **`[dependencies]`：主依賴群組**
   - Web framework（網頁框架）：`rocket`、`rocket_ws`
   - Database stack（資料庫堆疊）：`diesel`、`diesel_migrations`
   - Async runtime（非同步執行環境）：`tokio`、`futures`
   - Serialization（序列化）：`serde`、`serde_json`
   - Crypto / auth（加密與驗證）：`ring`、`jsonwebtoken`、`argon2`、`webauthn-rs`、`yubico`
   - HTTP / mail / template（HTTP、郵件、模板）：`reqwest`、`lettre`、`handlebars`
   - Storage（儲存）：`opendal` 與可選的 AWS 相關套件
6. **版本註解與相容性**
   - 例如 `diesel` 區塊特別註明目前版本選擇與 MySQL/MariaDB 相容性有關。
   - 這類註解對升級套件時很重要，不能只看版本號。
7. **`[profile.*]`：建置 profile**
   - `release` 著重最佳化與瘦身。
   - `release-micro` 優先縮小體積。
   - `release-low` 針對低資源環境降低編譯成本。
   - `dbg` 保留完整除錯資訊。
   - `ci` 用於 CI（持續整合）加速建置。
8. **`[workspace.lints.*]` 與 `[lints]`**
   - 對 Rust 與 Clippy 設定大量 `deny` 規則。
   - 明確禁止 `unsafe_code`、`non_ascii_idents` 等。
   - 這些 lint policy（檢查政策）表示專案非常重視程式碼一致性與安全性。

## 常用指令
```bash
cargo build --features sqlite
cargo build --no-default-features --features mysql
cargo test
cargo clippy --workspace --all-targets --all-features
cargo build --profile release-low
```

## 注意事項
- 預設沒有啟用任何資料庫 feature，建置前要確認實際使用 `sqlite`、`mysql` 或 `postgresql`。
- 某些 feature 會額外引入系統層依賴，例如 OpenSSL（加密函式庫）或資料庫原生函式庫。
- `profile` 很多，部署與 CI 不一定應使用同一組設定。
- 若升級 Rust 版本，`workspace.lints` 內對 edition 2024 的 allow（放寬）規則可能需要重新評估。
