#!/usr/bin/env bash
# switch-profile.sh — Cambia el perfil de modelos para sub-agentes de testing
# Uso: ./switch-profile.sh <nombre-del-perfil>
# Ejemplo: ./switch-profile.sh full-power
#          ./switch-profile.sh eco
#
# El script modifica solo los agentes definidos en el perfil.
# Los agentes que no están en el perfil no se tocan.

set -euo pipefail

PROFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$PROFILES_DIR")"
OPENCODE_CONFIG="$PROJECT_DIR/opencode.json"
BACKUP_DIR="$PROFILES_DIR/backups"

if [ $# -ne 1 ]; then
  echo "Uso: $0 <nombre-del-perfil>"
  echo ""
  echo "Perfiles disponibles:"
  for f in "$PROFILES_DIR"/*.json; do
    name=$(basename "$f" .json)
    [ "$name" = "backups" ] && continue
    desc=$(python3 -c "import json; d=json.load(open('$f')); print(d.get('description',''))" 2>/dev/null || echo "")
    echo "  - $name: $desc"
  done
  exit 1
fi

PROFILE_NAME="$1"
PROFILE_FILE="$PROFILES_DIR/$PROFILE_NAME.json"

if [ ! -f "$PROFILE_FILE" ]; then
  echo "ERROR: No existe el perfil '$PROFILE_NAME'"
  echo "Buscá en: $PROFILES_DIR"
  echo ""
  echo "Perfiles disponibles:"
  for f in "$PROFILES_DIR"/*.json; do
    name=$(basename "$f" .json)
    [ "$name" = "backups" ] && continue
    echo "  - $name"
  done
  exit 1
fi

if [ ! -f "$OPENCODE_CONFIG" ]; then
  echo "ERROR: No se encuentra opencode.json en $OPENCODE_CONFIG"
  exit 1
fi

# Backup
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/opencode-$(date +%Y%m%d-%H%M%S).json"
cp "$OPENCODE_CONFIG" "$BACKUP_FILE"
echo "✅ Backup creado: $BACKUP_FILE"

# Apply profile using Python
python3 << PYEOF
import json, sys

# Read config
with open("$OPENCODE_CONFIG", "r") as f:
    config = json.load(f)

# Read profile
with open("$PROFILE_FILE", "r") as f:
    profile = json.load(f)

profile_name = profile.get("name", "$PROFILE_NAME")
agents_profile = profile.get("agents", {})

# Track changes
added = []
removed = []
skipped = []

for agent_name, agent_config in agents_profile.items():
    model = agent_config.get("model", "")
    if agent_name in config.get("agent", {}):
        old_model = config["agent"][agent_name].get("model", "")
        if model:
            config["agent"][agent_name]["model"] = model
            if old_model:
                added.append(f"{agent_name}: {old_model} → {model}")
            else:
                added.append(f"{agent_name}: ← {model}")
        else:
            if "model" in config["agent"][agent_name]:
                del config["agent"][agent_name]["model"]
                removed.append(f"{agent_name} (era {old_model})")
    else:
        skipped.append(agent_name)

# Write config
with open("$OPENCODE_CONFIG", "w") as f:
    json.dump(config, f, indent=2)
    f.write("\n")

print(f"\n📋 Perfil aplicado: {profile_name}")
print(f"   {profile.get('description', '')}")
print()
if added:
    print("✅ Modelos asignados:")
    for a in added:
        print(f"   • {a}")
if removed:
    print("🗑️  Modelos removidos:")
    for r in removed:
        print(f"   • {r}")
if skipped:
    print("⚠️  Agentes en el perfil no encontrados en opencode.json:")
    for s in skipped:
        print(f"   • {s}")
print()
print("🔄 Reiniciá OpenCode para que los cambios tomen efecto.")
PYEOF
