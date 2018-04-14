# vagrant-vuls

# ディレクトリの移動
```
cd /root/vuls
```

# 脆弱性情報の取得

- すべての期間の脆弱性情報を取得(1時間以上かかる)
    ```
    $ go-cve-dictionary fetchjvn -entire
    ```

- 直近1ヶ月間に更新された脆弱性情報を取得(1分未満)
    ```
    $ go-cve-dictionary fetchjvn -month
    ```

- 直近1週間に更新された脆弱性情報を取得(1分未満)
    ```
    $ go-cve-dictionary fetchjvn -week
    ```

# セットアップ
```
vuls prepare
```

# スキャンの実行
```
vuls scan -cve-dictionary-dbpath=/root/vuls/cve.sqlite3
```

# 結果の表示
```
vuls tui
```
