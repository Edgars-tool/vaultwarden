> 繁體中文版。原始文件：start.sh（英文）

# start.sh 技術解說

## 這個檔案做什麼
這個 shell script（Shell 腳本）是 Vaultwarden container（容器）的啟動包裝器。它會先處理 `umask`、載入系統層設定檔，再執行真正的 `/vaultwarden` 二進位檔。

## 主要區塊說明
1. **`UMASK` 設定**
   - 若環境變數 `UMASK` 有值，就先執行 `umask "${UMASK}"`，控制新檔案的預設權限。
2. **載入全域設定檔**
   - 優先讀取 `/etc/vaultwarden.sh`。
   - 若找不到，則退回舊檔名 `/etc/bitwarden_rs.sh`，並印出遷移提醒。
3. **載入目錄式設定檔**
   - 優先掃描 `/etc/vaultwarden.d/*.sh`。
   - 若沒有新目錄，就改掃描舊的 `/etc/bitwarden_rs.d/*.sh`。
4. **啟動主程式**
   - 最後透過 `exec /vaultwarden "${@}"` 取代目前 shell，直接執行主程式並傳遞所有參數。

## 常用指令
```bash
sh docker/start.sh
UMASK=027 sh docker/start.sh
/vaultwarden --help
```

## 注意事項
- 這支腳本主要給 container entrypoint（容器進入點）使用，平常較少手動直接執行。
- 新舊設定檔路徑都支援，代表專案保留了 Bitwarden_RS 時期的相容性。
- 若 `/etc/vaultwarden.d` 中有多個腳本，會依 shell glob（萬用字元展開）順序載入。
