#!/usr/bin/env bash

set -euo pipefail

# =========================================================
# PicoClaw Installer
# Compatível com Raspberry Pi 4 e Raspberry Pi 5 (aarch64)
# =========================================================

if [[ "$(uname -m)" != "aarch64" ]]; then
    echo "Este instalador requer Raspberry Pi OS 64-bit (aarch64)."
    exit 1
fi

DEB_URL="https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw_aarch64.deb"
DEB_FILE="picoclaw_aarch64.deb"

CURRENT_USER="${SUDO_USER:-$USER}"
USER_HOME="$(eval echo "~${CURRENT_USER}")"

echo "==============================================="
echo " PicoClaw Installer"
echo " Raspberry Pi 4 / Raspberry Pi 5"
echo " Usuário detectado: ${CURRENT_USER}"
echo " HOME detectado: ${USER_HOME}"
echo "==============================================="

# ---------------------------------------------------------
# Download do pacote
# ---------------------------------------------------------

echo "[1/5] Baixando pacote PicoClaw..."

wget -c "${DEB_URL}" -O "${DEB_FILE}"

# ---------------------------------------------------------
# Instalação do pacote
# ---------------------------------------------------------

echo "[2/5] Instalando pacote..."

sudo dpkg -i "${DEB_FILE}"

# Corrige dependências automaticamente se necessário
sudo apt-get install -f -y

rm -f "${DEB_FILE}"

# ---------------------------------------------------------
# Serviço: PicoClaw Gateway
# ---------------------------------------------------------

echo "[3/5] Criando serviço picoclaw-gateway.service..."

sudo tee /etc/systemd/system/picoclaw-gateway.service > /dev/null <<EOF
[Unit]
Description=PicoClaw Gateway AI Agent
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/picoclaw gateway
Restart=always
RestartSec=5
User=${CURRENT_USER}
WorkingDirectory=${USER_HOME}
Environment=HOME=${USER_HOME}

[Install]
WantedBy=multi-user.target
EOF

# ---------------------------------------------------------
# Serviço: PicoClaw Launcher
# ---------------------------------------------------------

echo "[4/5] Criando serviço picoclaw-launcher.service..."

sudo tee /etc/systemd/system/picoclaw-launcher.service > /dev/null <<EOF
[Unit]
Description=PicoClaw Launcher Service
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/picoclaw-launcher -public
Restart=always
RestartSec=5
User=${CURRENT_USER}
WorkingDirectory=${USER_HOME}
Environment=HOME=${USER_HOME}

[Install]
WantedBy=multi-user.target
EOF

# ---------------------------------------------------------
# Ativação dos serviços
# ---------------------------------------------------------

echo "[5/5] Ativando serviços..."

sudo systemctl daemon-reload

sudo systemctl enable picoclaw-gateway.service
sudo systemctl enable picoclaw-launcher.service

sudo systemctl restart picoclaw-gateway.service
sudo systemctl restart picoclaw-launcher.service

echo
echo "==============================================="
echo " Instalação concluída com sucesso!"
echo "==============================================="
echo
echo "Status dos serviços:"
echo

systemctl status picoclaw-gateway.service --no-pager || true
echo
systemctl status picoclaw-launcher.service --no-pager || true
