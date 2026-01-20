# SORM Server Test

Локальный серверный стенд для DLP/DPI‑тестов. Все сервисы поднимаются в Docker и доступны по стандартным портам.

## Быстрый старт

```bash
docker compose up -d
```

Проверить статус:

```bash
docker compose ps
```

## Сервисы и порты

- Web (nginx): `80/tcp`, `443/tcp`
- Mail (GreenMail): `25/tcp` (SMTP), `110/tcp` (POP3), `143/tcp` (IMAP)
- FTP (vsftpd): `20/tcp`, `21/tcp`, `21000-21010/tcp`
- IRC (InspIRCd): `6667/tcp`
- XMPP (Prosody): `5222/tcp`, `5269/tcp`
- RADIUS (FreeRADIUS): `1812/udp`, `1813/udp`
- Asterisk (VoIP):
  - SIP `5060/udp`, `5060/tcp`
  - H.323 `1720/tcp`
  - IAX2 `4569/udp`
  - MGCP `2427/udp`
  - Skinny `2000/tcp`
  - RTP `10000-10050/udp`
- Telnet (busybox‑telnetd): `23/tcp`

## Конфигурация

- `docker-compose.yml` — описание всех сервисов.
- `config/` — конфиги сервисов:
  - `config/nginx/` — веб‑сервер и сертификаты.
  - `config/asterisk/` — SIP/H.323/IAX2/MGCP/Skinny.
  - `config/freeradius/` — клиенты и пользователи RADIUS.
  - `config/prosody/` — XMPP.
- `www/` — сайт и `rss.xml`.
- `data/ftp/` — файловая область FTP.
- `docker/` — Dockerfile'ы для telnetd и asterisk.

## Конфигурация для работы с внешним IP-адресом

Если клиент и сервер будут находиться на разных машинах с "белыми" IP, выполните следующие настройки:

**1. Настройте FTP:**
В файле `.env` укажите публичный IP вашего сервера. Это необходимо для корректной работы пассивного режима FTP.

```.env
FTP_PASV_ADDRESS=YOUR_PUBLIC_IP
```

**2. Настройте Asterisk (VoIP):**
Asterisk должен знать свой внешний IP для правильной работы SIP и RTP.

- Откройте файл `config/asterisk/pjsip.conf`.
- Найдите секции `[transport-udp]` и `[transport-tcp]`.
- Добавьте в **каждую** из этих секций следующие две строки, заменив `YOUR_PUBLIC_IP` на ваш реальный адрес:

```ini
external_media_address = YOUR_PUBLIC_IP
external_signaling_address = YOUR_PUBLIC_IP
```

**Пример для `[transport-udp]`:**
```ini
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060
external_media_address = 8.8.8.8
external_signaling_address = 8.8.8.8
```

**3. Перезапустите сервер:**
После внесения изменений полностью перезапустите Docker-контейнеры:
```bash
docker compose down && docker compose up -d
```

**4. Настройте файрвол:**
Убедитесь, что все порты, перечисленные в `docker-compose.yml`, открыты на файрволе вашего сервера.

## Учетные данные по умолчанию


- Mail (GreenMail): `dlp / dlp`, домен `dlp.local`
- FTP: `dlp / dlp`
- RADIUS: `dlpuser / dlppass`, secret клиента `testing123`
- SIP (Asterisk PJSIP): `1001 / pass1001`, `1002 / pass1002`
- H.323 (ooh323): `h323user1 / h323pass1`, `h323user2 / h323pass2`
- IAX2: `iaxuser1 / iaxpass1`, `iaxuser2 / iaxpass2`
- MGCP endpoint: `gw1`

## Особенности

- FTP использует пассивный режим. Для доступа извне укажите корректный `FTP_PASV_ADDRESS` в `.env` и перезапустите `docker compose`.
- HTTPS работает на самоподписанном сертификате.

## Клиентский генератор трафика

Скрипт генерации трафика находится в соседнем проекте `sorm-test-client`.
