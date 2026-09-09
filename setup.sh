#!/bin/bash

# ============================================================
# JaanTech — Linux Users & Permissions Lab Setup
# YouTube: Linux Users & Permissions — Permission Denied
# ============================================================
# Run this script to reproduce the complete lab from the video
# Requires sudo access
# ============================================================

echo "=============================================="
echo " Linux Users & Permissions Lab"
echo "=============================================="
echo ""

echo "[1/8] Checking current user..."
id
echo ""

echo "[2/8] Creating users ali and ahmad..."
sudo useradd -m ali
sudo useradd -m ahmad
echo "      Set password for ali:"
sudo passwd ali
echo "      Set password for ahmad:"
sudo passwd ahmad
echo ""

echo "[3/8] Verifying users..."
id ali
id ahmad
echo ""

echo "[4/8] Creating high_tech group..."
sudo groupadd high_tech
getent group high_tech
echo ""

echo "[5/8] Adding ali and ahmad to high_tech..."
sudo usermod -aG high_tech ali
sudo usermod -aG high_tech ahmad
echo ""

echo "[6/8] Creating /shared directory..."
sudo mkdir /shared
ls -ld /shared
echo ""

echo "[7/8] Setting ownership and permissions..."
sudo chown root:high_tech /shared
ls -ld /shared
sudo chmod 2770 /shared
ls -ld /shared
echo ""

echo "[8/8] Creating david with no group membership..."
sudo useradd -m david
sudo passwd david
echo ""

echo "=============================================="
echo " Setup complete."
echo ""
echo " Now test manually:"
echo " su - ali       -> cd /shared -> echo 'hello' > ali.txt"
echo " su - ahmad     -> cd /shared -> cat ali.txt"
echo " su - david     -> cd /shared -> Permission Denied"
echo ""
echo " Final check:"
echo " id ali && id ahmad && id david"
echo "=============================================="
