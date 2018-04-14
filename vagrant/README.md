# vagrant-vuls

# ディレクトリの移動
```
cd /root/vuls
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

- 参考
  - https://vuls.io/docs/ja/install-manually-centos.html
