#!/bin/bash

set -e

echo "======================================"
echo " Tempo Validator install (SCREEN mode)"
echo "======================================"

# ====== ВВОД АДРЕСА ======
read -p "Enter FEE RECIPIENT (ETH address): " FEE_RECIPIENT

if [[ -z "$FEE_RECIPIENT" ]]; then
  echo "❌ Address cannot be empty"
  exit 1
fi

if [[ ! "$FEE_RECIPIENT" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
  echo "❌ Invalid ETH address format"
  exit 1
fi

echo "✅ Fee recipient set to: $FEE_RECIPIENT"
sleep 1

# ====== НАСТРОЙКИ ======
USER_NAME=$(whoami)
HOME_DIR="$HOME"
TEMPO_DATA="$HOME_DIR/tempo_data"
TEMPO_KEY_DIR="$HOME_DIR/.tempo"
SCREEN_NAME="tempo-validator"

# ====== ОБНОВЛЕНИЕ ======
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# ====== ПАКЕТЫ ======
echo "📦 Installing required packages..."
sudo apt install -y \
  curl wget git screen ufw build-essential ca-certificates

# ====== UFW ======
echo "🔥 Configuring firewall (ufw)..."
sudo ufw allow ssh
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp
sudo ufw --force enable

sudo ufw status verbose

# ====== TEMPO ======
echo "⬇️ Installing Tempo..."
curl -L https://tempo.xyz/install | bash

echo "Tempo version:"
tempo --version

# ====== ДИРЕКТОРИИ ======
echo "📂 Creating directories..."
mkdir -p "$TEMPO_DATA"
mkdir -p "$TEMPO_KEY_DIR"

# ====== КЛЮЧ ======
if [ ! -f "$TEMPO_KEY_DIR/validator.key" ]; then
  echo "🔐 Generating validator key..."
  tempo consensus generate-private-key --output "$TEMPO_KEY_DIR/validator.key"
else
  echo "🔑 Validator key already exists"
fi

echo "📢 SAVE THIS PUBLIC KEY:"
tempo consensus calculate-public-key \
  --private-key "$TEMPO_KEY_DIR/validator.key"

# ====== SNAPSHOT ======
echo "📦 Downloading snapshot (if available)..."
tempo download || true

# ====== SCREEN ======
echo "🖥️ Starting validator in screen..."

screen -dmS "$SCREEN_NAME" bash -c "
tempo node \
  --datadir $TEMPO_DATA \
  --port 30303 \
  --discovery.addr 0.0.0.0 \
  --discovery.port 30303 \
  --consensus.signing-key $TEMPO_KEY_DIR/validator.key \
  --consensus.fee-recipient $FEE_RECIPIENT
"

echo "======================================"
echo "✅ VALIDATOR RUNNING"
echo "--------------------------------------"
echo "screen -r $SCREEN_NAME   -> attach"
echo "Ctrl+A + D               -> detach"
echo "screen -ls               -> list"
echo "======================================"
