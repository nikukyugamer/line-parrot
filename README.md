# LINE Parrot

## What's this?
- LINE bot
- When you post an image, `LINE Parrot` returns below responses
    - The description of image
    - The similar images
    - Is its image for adult?
    - Is its image violent?
    - The landmark name of its image
    - The result of OCR
- When you post a text, `LINE Parrot` returns the text you registered
    - You can register the text by web interface

## Require
- [Vision API](https://cloud.google.com/vision/?hl=ja)'s Token
- Registration for [LINE Developers](https://developers.line.me/console/profile/)
- MySQL

## Booting

```bash
$ cp .env.sample .env
$ vim .env
$ bundle install --path vendor/bundle
$ bundle exec rails db:migrate
$ bundle exec rails server
```

## Sample Images
![LINE Parrot Sample 01](/line_parrot_01.png "LINE Parrot Sample 01")

![LINE Parrot Sample 02](/line_parrot_02.png "LINE Parrot Sample 02")

![LINE Parrot Sample 03](/line_parrot_03.png "LINE Parrot Sample 03")

# LICENSE
[MIT LICENSE](/LICENSE)
