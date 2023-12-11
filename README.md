# kbot
devops application from scratch

My first bot on golang for learning purpoise.

<https://t.me/mardukay_bot>

commands:

/start hello

/start goodbye

Installation:

Set env variable TELE_TOKEN with value that is your telegram bot token 

export TELE_TOKEN="your_teletoken" 

./kbot start

Helm installation
helm install --set secret.tokenKey="telegrambot_token" "app_name" https://github.com/Mardukay/kbot/releases/download/v1.0.5/kbot-0.1.1.tgz

TODO:
Update readme
  - add instruction for helm
  - add github action workflow diagram

