> 繁體中文版。原始文件：package.json（英文）

# package.json 技術解說

## 這個檔案做什麼
這份 `package.json` 是 `playwright` 子專案的 Node.js package manifest（套件資訊檔）。它主要用來管理測試相關的 JavaScript / TypeScript 生態系依賴，而不是 Vaultwarden 主服務本體。

## 主要區塊說明
1. **基本資訊**
   - 套件名稱為 `scenarios`，版本為 `1.0.0`。
   - `scripts` 目前是空物件，表示執行方式可能依賴外部腳本或直接呼叫 Playwright CLI。
2. **`devDependencies`：開發依賴**
   - `@playwright/test`：Playwright 測試框架本體。
   - `dotenv`、`dotenv-expand`：讀取與展開環境變數。
   - `maildev`：郵件測試工具，這裡透過 npm alias（別名）指向 `@timshel_npm/maildev`。
3. **`dependencies`：執行期依賴**
   - `mysql2`：MySQL / MariaDB 連線。
   - `otpauth`：OTP / TOTP 驗證流程。
   - `pg`：PostgreSQL 連線。

## 常用指令
```bash
npm install
npx playwright test
npm ls
```

## 注意事項
- `scripts` 為空，代表常見命令可能需要直接寫完整 CLI，例如 `npx playwright test`。
- 這份檔案主要服務測試情境，和 Rust 主程式的依賴是分開管理的。
- `maildev` 使用 alias（別名）安裝，排查版本問題時要注意實際套件名稱。
