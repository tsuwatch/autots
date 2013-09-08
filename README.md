# autots
あやねるううううううううう

## autots？

*automatic timeshift reservation system*の略です

ニコニコ生放送の公式番組のなかで見たい番組を自動で録画することができます

## できること

- 自動でタイムシフト予約したい番組をタグで指定して登録
- 日付変更時，その日に放送される番組を自動でタイムシフト予約

## 使い方

### 必要なもの

- ruby
- redis

### gem

```
$ bundle install
```

### サーバの起動

```
$ thin start -d
```
