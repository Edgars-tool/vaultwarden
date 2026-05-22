> 繁體中文版。原始文件：healthcheck.sh（英文）

# healthcheck.sh 技術解說

## 這個檔案做什麼
這個 shell script（Shell 腳本）提供 Vaultwarden container 的 health check（健康檢查）。它會根據環境變數與 `config.json` 推導實際的檢查網址，最後以 `curl` 呼叫 `/alive` 端點確認服務是否健康。

## 主要區塊說明
1. **預設環境變數**
   - `DATA_FOLDER` 預設為 `/data`
   - `ROCKET_PORT` 預設為 `80`
   - `ENV_FILE` 預設為 `/.env`
2. **載入 `.env`**
   - 若 `ENV_FILE` 存在且可讀，就先把檔案內容匯入環境變數。
3. **`get_config_val()`**
   - 從 `config.json` 中抓取指定 key（鍵）的值。
   - 使用 `grep` 與 `sed` 做簡單字串解析。
4. **`get_base_path()`**
   - 從 `DOMAIN` URL 萃取 base path（基底路徑）。
   - 例如 `https://bw.example.com/path` 會得到 `/path`。
5. **domain 優先順序**
   - 若 `config.json` 有 `domain`，就覆蓋 `DOMAIN` 環境變數。
6. **位址與協定推導**
   - 若 `ROCKET_ADDRESS` 為空或是 `0.0.0.0` / `::`，就改用 `localhost`。
   - 若存在 `ROCKET_TLS`，就把協定改成 `https`。
7. **健康檢查請求**
   - 以 `curl --insecure --fail --silent --show-error` 呼叫 `/alive`。
   - 失敗時 `exit 1`，讓容器平台判定不健康。

## 常用指令
```bash
sh docker/healthcheck.sh
DATA_FOLDER=/data ROCKET_PORT=8080 sh docker/healthcheck.sh
curl http://localhost:80/alive
```

## 注意事項
- 這個腳本不是完整 JSON parser（JSON 解析器），而是用 `grep`/`sed` 做簡化解析；若 `config.json` 格式大幅改變，可能失效。
- `--insecure` 代表略過 TLS 憑證驗證，適合容器內部健康檢查，但不適合當一般安全檢查工具。
- 若 `DOMAIN` 含有子路徑，`get_base_path()` 會把路徑補到 `/alive` 前面。
