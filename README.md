# Tempo Validator (screen-based)

Simple installer for **Tempo validator node** on Ubuntu.  
No systemd. Uses **screen**. Beginner-friendly.

Простой установщик **валидатора Tempo** для Ubuntu.  
Без systemd. Работает через **screen**. Подходит новичкам.

---

## Features / Возможности

- One install script / Один файл установки
- Interactive ETH address input / Ввод ETH-адреса во время установки
- Runs in screen / Работает в screen
- No autostart after reboot / Нет автозапуска после перезагрузки

---

## Requirements / Требования

- Ubuntu 20.04 / 22.04
- SSH access (root or sudo)

---

## Installation / Установка

### 1. Connect to server / Подключиться к серверу
```bash
ssh root@SERVER_IP
2. Create script file / Создать файл
bash
Копировать код
nano install_tempo_validator.sh
Paste script content from this repository.
Вставьте содержимое скрипта из репозитория.

Save:

mathematica
Копировать код
Ctrl + O → Enter → Ctrl + X
3. Make executable / Дать права
bash
Копировать код
chmod +x install_tempo_validator.sh
4. Run installer / Запустить
bash
Копировать код
./install_tempo_validator.sh
During installation you will be asked for ETH fee recipient address.
Во время установки будет запрошен ETH-адрес для комиссий.

Screen commands / Команды screen
bash
Копировать код
screen -ls                 # list sessions
screen -r tempo-validator  # attach
Ctrl + A + D               # detach
screen -X -S tempo-validator quit  # stop
Open ports / Открытые порты
Port	Protocol	Purpose
22	TCP	SSH
30303	TCP	P2P
30303	UDP	Discovery

RPC ports are NOT opened.
RPC порты НЕ открываются.

Important / Важно
Save validator PUBLIC KEY shown during install

Required for on-chain validator registration

Until whitelisted, node will sync but not produce blocks

Reboot note / Перезагрузка
After server reboot:

screen session is gone

run installer again:

bash
Копировать код
./install_tempo_validator.sh
Keys and data are preserved.
Ключи и данные сохраняются.

License
MIT
