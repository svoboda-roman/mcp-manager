#!/bin/bash

# --- Colors & Paths ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'
CONFIG_PATH="$HOME/.claude.json"

# --- Data: Display Name | ID | Description | Command ---
tools=(
    "Shadcn UI | shadcn | Beautiful Tailwind components directly into your project | claude mcp add shadcn --scope user -- bunx --bun shadcn@latest mcp"
    "Figma | figma | Design-to-code: Let Claude read your Figma design files | claude mcp add figma --scope user --transport http https://mcp.figma.com/mcp"
    "Ref-Tools | ref-tools | High-speed documentation search for popular frameworks | claude mcp add ref-tools --scope user -- bunx -y ref-tools-mcp@latest"
    "Reasoning | sequential-thinking | Advanced problem-solving logic for complex coding tasks | claude mcp add sequential-thinking --scope user -- bunx -y @modelcontextprotocol/server-sequential-thinking"
    "GitHub | github | Manage PRs, search code, and commit directly from chat | claude mcp add github --scope user --transport http https://mcp.github.com/mcp"
    "Fetch | fetch | Scrapes any URL and converts it to clean Markdown for Claude | claude mcp add fetch --scope user --transport http https://remote.mcpservers.org/fetch/mcp"
    "Browser | browser | Real-time browser control (requires BrowserMCP extension) | claude mcp add browser --scope user --transport http https://mcp.browsermcp.com/mcp"
    "Playwright | playwright | Automate browser testing and UI bug finding with Playwright | claude mcp add playwright --scope user -- bunx -y @modelcontextprotocol/server-playwright"
	"Memory | memory | Persistent memory for Claude to remember your preferences | claude mcp add memory --scope user -- bunx -y @modelcontextprotocol/server-memory"
	"21st UI | 21st | Search and import high-end UI components from 21st.dev | claude mcp add 21st --scope user -- bunx -y 21st-mcp@latest"
	"Color Tools | colors | Generate accessible color palettes and Tailwind themes | claude mcp add colors --scope user -- bunx -y @mcp-servers/color-tools"
)

clear
echo -e "${BLUE}${BOLD}--- 🛠️  CLAUDE MCP MANAGER ---${NC}"
echo -e "1) ${GREEN}Install/Update Tools${NC}"
echo -e "2) ${RED}Remove Tools${NC}"
echo -e "3) ${YELLOW}Force Reset (Nuclear Wipe)${NC}"
echo "------------------------------"
read -p "Action: " action

if [ "$action" == "3" ]; then
    echo '{"mcpServers":{}}' > "$CONFIG_PATH"
    rm -rf ~/.claude/backups/* > /dev/null 2>&1
    echo -e "${RED}💥 Config and backups wiped clean.${NC}"
    exit 0
fi

for t in "${tools[@]}"; do
    name=$(echo "$t" | cut -d'|' -f1 | xargs)
    id=$(echo "$t" | cut -d'|' -f2 | xargs)
    desc=$(echo "$t" | cut -d'|' -f3 | xargs)
    cmd=$(echo "$t" | cut -d'|' -f4 | xargs)

    # Check if currently installed
    STATUS="${RED}Not Installed${NC}"
    if grep -q "\"$id\":" "$CONFIG_PATH" 2>/dev/null; then
        STATUS="${GREEN}Installed${NC}"
    fi

    echo -e "\n${BOLD}$name${NC} ($STATUS)"
    echo -e "${DIM}$desc${NC}"

    if [ "$action" == "1" ]; then
        read -p "🚀 Install this tool? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            # Clean backup/memory to prevent ghost entries
            claude mcp remove "$id" > /dev/null 2>&1
            eval "$cmd" > /dev/null 2>&1
            echo -e "   ${GREEN}Successfully added ${id}${NC}"
        fi
    else
        read -p "🗑️  Remove this tool? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            claude mcp remove "$id" > /dev/null 2>&1
            # Force cleanup of JSON and Backups
            python3 -c "import json, os;
p = os.path.expanduser('$CONFIG_PATH');
if os.path.exists(p):
    with open(p, 'r') as f: data = json.load(f)
    if 'mcpServers' in data and '$id' in data['mcpServers']:
        del data['mcpServers']['$id']
        with open(p, 'w') as f: json.dump(data, f, indent=2)
"
            rm -rf ~/.claude/backups/* > /dev/null 2>&1
            echo -e "   ${RED}Removed ${id} and cleared cache${NC}"
        fi
    fi
done

echo -e "\n------------------------------"
echo -e "${GREEN}${BOLD}✨ Done!${NC} Please RESTART your Claude terminal session."
