# 🛠️ Claude MCP Manager

A lightweight, interactive toolkit to manage your **Model Context Protocol (MCP)** servers for Claude Code. This manager allows you to easily install, update, and "nuclear-reset" your MCP configurations across Fedora, macOS, and Windows.

---

## ✨ Features
* **Interactive Interface:** Simple `y/n` prompts with tool descriptions.
* **Deep Clean:** Automatically clears Claude's internal backup cache to prevent "ghost" servers from appearing in `/mcp`.
* **Status Detection:** Real-time checking to see if a tool is already installed.
* **Cross-Platform:** Includes both Bash (`.sh`) for Linux/macOS and PowerShell (`.ps1`) for Windows.
* **JSON Surgery:** Uses native Python (Linux/Mac) or PowerShell logic to ensure your `~/.claude.json` never gets corrupted.

---

## 📦 Included MCP Servers
* **Shadcn UI:** Tailwind components directly into your project.
* **21st UI:** Search and import high-end components from 21st.dev.
* **Figma:** Design-to-code via Figma API.
* **GitHub:** Manage PRs, commits, and issues.
* **Reasoning:** Sequential thinking for complex tasks.
* **Fetch:** Web scraping to Markdown.
* **Browser/Playwright:** Browser control and visual testing.
* **Memory:** Persistent AI context.
* **Color Tools:** Accessible palette generation.

---

## 🚀 Getting Started

### For Linux (Fedora/Ubuntu) & macOS
1.  **Download the script** (`mcp.sh`).
2.  **Run it:**
    ```bash
    ./mcp-manager.sh
    ```

### For Windows (PowerShell)
1.  **Download the script** (`mcp.ps1`).
2.  **Run it:**
    ```powershell
    .\mcp-manager.ps1
    ```

---

## ⚙️ Requirements
* **Claude Code CLI:** Must be installed (`npm install -g @anthropic-ai/claude-code`).
* **Bun:** Recommended for high-speed MCP execution (`curl -fsSL https://bun.sh/install | bash`).
* **Node.js:** v18 or higher.

## 🗑️ Troubleshooting
If you see servers in Claude that you thought you deleted, run the script and choose **Action 3 (Force Reset)**. This will wipe your configuration and clear the backup cache, giving you a completely fresh start.
