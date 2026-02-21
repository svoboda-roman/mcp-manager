# --- Colors & Paths ---
$BLUE = "`e[1;34m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[1;33m"
$RED = "`e[0;31m"
$DIM = "`e[2m"
$BOLD = "`e[1m"
$NC = "`e[0m"

$CONFIG_PATH = "$HOME\.claude.json"
$BACKUP_PATH = "$HOME\.claude\backups"

# --- Data: Object Array ---
$tools = @(
    @{ Name = "Shadcn UI"; ID = "shadcn"; Desc = "Beautiful Tailwind components directly into your project"; Cmd = "claude mcp add shadcn --scope user -- bunx --bun shadcn@latest mcp" },
    @{ Name = "Figma"; ID = "figma"; Desc = "Design-to-code: Let Claude read your Figma design files"; Cmd = "claude mcp add figma --scope user --transport http https://mcp.figma.com/mcp" },
    @{ Name = "Ref-Tools"; ID = "ref-tools"; Desc = "High-speed documentation search for popular frameworks"; Cmd = "claude mcp add ref-tools --scope user -- bunx -y ref-tools-mcp@latest" },
    @{ Name = "Reasoning"; ID = "sequential-thinking"; Desc = "Advanced problem-solving logic for complex coding tasks"; Cmd = "claude mcp add sequential-thinking --scope user -- bunx -y @modelcontextprotocol/server-sequential-thinking" },
    @{ Name = "GitHub"; ID = "github"; Desc = "Manage PRs, search code, and commit directly from chat"; Cmd = "claude mcp add github --scope user --transport http https://mcp.github.com/mcp" },
    @{ Name = "Fetch"; ID = "fetch"; Desc = "Scrapes any URL and converts it to clean Markdown for Claude"; Cmd = "claude mcp add fetch --scope user --transport http https://remote.mcpservers.org/fetch/mcp" },
    @{ Name = "Browser"; ID = "browser"; Desc = "Real-time browser control (requires BrowserMCP extension)"; Cmd = "claude mcp add browser --scope user --transport http https://mcp.browsermcp.com/mcp" },
    @{ Name = "Playwright"; ID = "playwright"; Desc = "Automate browser testing and UI bug finding with Playwright"; Cmd = "claude mcp add playwright --scope user -- bunx -y @modelcontextprotocol/server-playwright" },
    @{ Name = "Memory"; ID = "memory"; Desc = "Persistent memory for Claude to remember your preferences"; Cmd = "claude mcp add memory --scope user -- bunx -y @modelcontextprotocol/server-memory" },
    @{ Name = "21st UI"; ID = "21st"; Desc = "Search and import high-end UI components from 21st.dev"; Cmd = "claude mcp add 21st --scope user -- bunx -y 21st-mcp@latest" },
    @{ Name = "Color Tools"; ID = "colors"; Desc = "Generate accessible color palettes and Tailwind themes"; Cmd = "claude mcp add colors --scope user -- bunx -y @mcp-servers/color-tools" }
)

Clear-Host
Write-Host "${BLUE}${BOLD}--- 🛠️  CLAUDE MCP MANAGER (Windows) ---${NC}" -NoNewline
Write-Host ""
Write-Host "1) ${GREEN}Install/Update Tools${NC}"
Write-Host "2) ${RED}Remove Tools${NC}"
Write-Host "3) ${YELLOW}Force Reset (Nuclear Wipe)${NC}"
Write-Host "------------------------------"
$action = Read-Host "Action"

if ($action -eq "3") {
    '{"mcpServers":{}}' | Out-File -FilePath $CONFIG_PATH -Encoding utf8
    if (Test-Path $BACKUP_PATH) { Remove-Item -Path "$BACKUP_PATH\*" -Recurse -Force -ErrorAction SilentlyContinue }
    Write-Host "${RED}💥 Config and backups wiped clean.${NC}"
    exit
}

foreach ($t in $tools) {
    # Check if currently installed
    $status = "${RED}Not Installed${NC}"
    if (Test-Path $CONFIG_PATH) {
        $json = Get-Content $CONFIG_PATH | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($json.mcpServers.PSObject.Properties[$t.ID]) {
            $status = "${GREEN}Installed${NC}"
        }
    }

    Write-Host "`n${BOLD}$($t.Name)${NC} ($status)"
    Write-Host "${DIM}$($t.Desc)${NC}"

    if ($action -eq "1") {
        $choice = Read-Host "🚀 Install this tool? (y/n)"
        if ($choice -eq "y") {
            # Standard removal first to be clean
            Invoke-Expression "claude mcp remove $($t.ID)" | Out-Null
            Invoke-Expression $t.Cmd | Out-Null
            Write-Host "   ${GREEN}Successfully added $($t.ID)${NC}"
        }
    }
    elseif ($action -eq "2") {
        $choice = Read-Host "🗑️  Remove this tool? (y/n)"
        if ($choice -eq "y") {
            # 1. Standard removal
            Invoke-Expression "claude mcp remove $($t.ID)" | Out-Null
            
            # 2. PowerShell JSON Surgery
            if (Test-Path $CONFIG_PATH) {
                $data = Get-Content $CONFIG_PATH | ConvertFrom-Json
                if ($data.mcpServers.PSObject.Properties[$t.ID]) {
                    $data.mcpServers.PSObject.Properties.Remove($t.ID)
                    $data | ConvertTo-Json -Depth 10 | Out-File $CONFIG_PATH -Encoding utf8
                }
            }
            # 3. Clear Backups
            if (Test-Path $BACKUP_PATH) { Remove-Item -Path "$BACKUP_PATH\*" -Recurse -Force -ErrorAction SilentlyContinue }
            Write-Host "   ${RED}Removed $($t.ID) and cleared cache${NC}"
        }
    }
}

Write-Host "`n------------------------------"
Write-Host "${GREEN}${BOLD}✨ Done!${NC} Please RESTART your Claude terminal session."
