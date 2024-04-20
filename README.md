# 小児科予約状況を確認する

## 環境準備

### Ruby インストール

```bash
rbenv install $(cat .ruby-version)
```

### Gem インストール

```bash
bundle
```
```bash
cp .envrc{.sample,}
```

### 環境変数

※ 各変数設定お願いします

```bash
cp .envrc.sample .envrc
touch ./log/development.log
```

## 実行

```bash
$ docker compose build

$ docker compose run batch
```

## crontabを設定
```bash
# /usr/sbin/cronをフルディスクアクセス許可しておく
$ crontab -e

# docker コマンドへのfull pathか、環境変数をreloadして付与するかをして、パスを通して起動する.
# Apple Silicone Mac
*/5 8-18 * * * cd ~/ghq/github.com/${user}/alert_clinic_schedule_km && /opt/homebrew/bin/direnv exec . /usr/local/bin/docker compose run batch

# intel Mac
*/5 8-18 * * * cd ~/ghq/github.com/${user}/alert_clinic_schedule_km && /usr/local/bin/direnv exec . /usr/local/bin/docker compose run batch
```

## ローカル：動いているか確認
```bash
tail -F log/development.log
```
