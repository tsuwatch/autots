# autots
あやねるううううううううう

## autots？

*automatic timeshift reservation system*の略です  
ニコニコ生放送の公式生放送のなかから見たい放送を自動でタイムシフト予約することができます  

## できること

- 自動でタイムシフト予約したい公式生放送をタグで指定して登録
- 日付変更時，その日に放送される公式生放送から登録したタグが含まれる放送を自動でタイムシフト予約
- 予約内容をTwitterで自分宛にリプライ

## 使い方

### 必要なもの

- ruby
- redis

### gem

```
$ bundle install
```

### 各種アカウント

- niconico
- Twitter

を用意．Twitterは必須ではないので，必要なければうまく削除して下さい（config.ruで使用しています）  


### サーバの起動

```
$ thin start -d
```
