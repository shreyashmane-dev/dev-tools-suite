# DEV Tools Suite

```
  +==============================================================================+
  |    ____  _______     __   ______            __        _____       _ __       |
  |   / __ \/ ____/ |   / /  /_  __/___  ____  / /____   / ___/__  __(_) /____   |
  |  / / / / __/  | |  / /    / / / __ \/ __ \/ / ___/   \__ \/ / / / / __/ _ \  |
  | / /_/ / /___  | | / /    / / / /_/ / /_/ / (__  )   ___/ / /_/ / / /_/  __/  |
  |/_____/_____/  |___/     /_/  \____/\____/_/____/   /____/\__,_/_/\__/\___/   |
  +==============================================================================+
  :: DEV TOOLS SUITE            [ Provider: AnoS :: Version: v1.0.0 :: Windows x64 ]
  --------------------------------------------------------------------------------
```

[![Windows 10 / 11](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-blue?logo=windows)](https://github.com/shreyashmane-dev/dev-tools-suite)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Release: v1.0.0](https://img.shields.io/badge/Release-v1.0.0-cyan.svg)](release/hashes.txt)
[![Tools Active](https://img.shields.io/badge/Tools-10%20Active-brightgreen.svg)](#the-10-tools)
[![Provider: AnoS](https://img.shields.io/badge/Provider-AnoS-06b6d4.svg)](https://github.com/shreyashmane-dev/dev-tools-suite)

A collection of practical, production-grade Windows developer tools built for automated environment setup, diagnostics, project scaffolding, Git workflows, workspace organization, build artifact cleanup, local HTTP serving, and cryptographic key generation.

Every tool in the suite is a **self-contained, standalone `.BAT` script** that requires zero external runtime dependencies and provides a clean, unified terminal visual identity.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Two Ways to Use DEV](#two-ways-to-use-dev)
  - [Method 1: Run via One-Line PowerShell Command](#method-1-run-via-one-line-powershell-command)
  - [Method 2: Standalone .BAT Download](#method-2-standalone-bat-download)
- [The 10 Tools](#the-10-tools)
  - [1. DEV Setup Center](#1-dev-setup-center)
  - [2. DEV Project Forge](#2-dev-project-forge)
  - [3. DEV Doctor](#3-dev-doctor)
  - [4. DEV GitHub Toolkit](#4-dev-github-toolkit)
  - [5. DEV Package Hub](#5-dev-package-hub)
  - [6. DEV System Toolkit](#6-dev-system-toolkit)
  - [7. DEV File Organizer](#7-dev-file-organizer)
  - [8. DEV Clean Master](#8-dev-clean-master)
  - [9. DEV Quick Server](#9-dev-quick-server)
  - [10. DEV Key Forge](#10-dev-key-forge)
- [Adding More Tools (Automated Workflow)](#adding-more-tools-automated-workflow)
- [Frontend UI/UX & SEO Architecture](#frontend-uiux--seo-architecture)
- [PowerShell Web Launcher](#powershell-web-launcher)
- [Downloads & Cryptographic Hashes](#downloads--cryptographic-hashes)
- [System Requirements](#system-requirements)
- [Project Structure](#project-structure)
- [Security Model](#security-model)
- [Testing & Validation](#testing--validation)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Modern Windows developers spend valuable hours configuring toolchains, debugging broken PATH entries, creating boilerplate code, and setting up Git identities. **DEV Tools Suite** provides a single, polished product family of ten focused terminal tools that solve these friction points.

### Shared Terminal Design Language

All ten tools share one visual identity:
- **Clean ASCII Typography**: No decorative Unicode box-drawing characters that get corrupted across different CMD codepages.
- **Controlled ANSI Colors**: Cyan and blue for primary brand elements, bright white for titles, green for success, yellow for warnings, and red for errors.
- **Two-Column Dashboard**: Displays `INSTALLED` and `MISSING` software side by side with equal spacing and exact totals.
- **Explicit Menu Routing**: Numbered navigation with safe string comparisons, avoiding errorlevel cascading bugs.
- **Resilient Execution**: Tools never close unexpectedly on errors, remaining visible so you can inspect output.

---

## Key Features

- **Zero Runtime Dependencies**: Written in pure Windows Batch and PowerShell — works out of the box on clean Windows installations.
- **10 Production-Ready Utilities**: Covers setup, packages, scaffolding, diagnostics, Git workflows, workspace organization, cache cleaning, local serving, and key generation.
- **Two Ways to Use**: Launch instantly from PowerShell with local caching and SHA-256 verification, or download standalone `.BAT` files for 100% offline usage.
- **Automated Catalog Engine**: Drop a new tool into `tools/` and run `.\scripts\update-tools-catalog.ps1` to automatically update hashes, `tools.json`, and the website.
- **Modern Responsive Frontend**: Top-tier dark visual aesthetics with a 3-way theme switcher (`Cyber Dark`, `Midnight Eclipse`, `Studio Light`), real-time search, category filtering, interactive terminal hero, and modal dialogs.
- **Top-Tier SEO & Discovery**: Structured Schema.org JSON-LD, OpenGraph tags, Twitter Cards, `sitemap.xml`, and `robots.txt`.
- **Zero Credential Harvesting**: Uses official GitHub CLI browser sessions; never prompts for plain-text tokens or passwords.

---

## Two Ways to Use DEV

DEV Tools Suite is designed for maximum developer flexibility. You can use any tool through two primary workflows:

### Method 1: Run via One-Line PowerShell or CMD Command

No installation or pre-cloning required. Simply copy the verified launch command from the website or documentation, paste it into your terminal, and press <kbd>Enter</kbd>.

#### In PowerShell (Windows Terminal / PowerShell 5.1 & 7+):
```powershell
# Launch specific tool (e.g. DEV Setup Center):
$f = "$env:TEMP\DevLauncher.ps1"; irm https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/launcher/DevLauncher.ps1 -OutFile $f; & $f -Tool setup; rm $f

# Or launch the interactive suite menu:
$f = "$env:TEMP\DevLauncher.ps1"; irm https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/launcher/DevLauncher.ps1 -OutFile $f; & $f; rm $f
```

#### In Command Prompt (CMD):
```cmd
:: Launch specific tool (e.g. DEV Setup Center):
powershell -ExecutionPolicy Bypass -Command "$f = Join-Path $env:TEMP 'DevLauncher.ps1'; irm 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/launcher/DevLauncher.ps1' -OutFile $f; & $f -Tool setup; rm $f"

:: Or launch the interactive suite menu:
powershell -ExecutionPolicy Bypass -Command "$f = Join-Path $env:TEMP 'DevLauncher.ps1'; irm 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/launcher/DevLauncher.ps1' -OutFile $f; & $f; rm $f"
```

#### Step-by-Step Guide:
1. Open **Windows Terminal** or **PowerShell** (Press <kbd>Win + X</kbd> and select **Terminal**).
2. Choose your desired tool flag:
   - `-Tool setup` &rarr; DEV Setup Center
   - `-Tool forge` &rarr; DEV Project Forge
   - `-Tool doctor` &rarr; DEV Doctor
   - `-Tool github` &rarr; DEV GitHub Toolkit
   - `-Tool package` &rarr; DEV Package Hub
   - `-Tool system` &rarr; DEV System Toolkit
   - `-Tool organize` &rarr; DEV File Organizer
   - `-Tool clean` &rarr; DEV Clean Master
   - `-Tool server` &rarr; DEV Quick Server
   - `-Tool keygen` &rarr; DEV Key Forge
3. Paste the command into PowerShell and press <kbd>Enter</kbd>.
4. The launcher downloads the tool to `%LOCALAPPDATA%\DevToolsSuite`, verifies the file size, and executes the batch file locally.

### Method 2: Standalone .BAT Download

Download self-contained batch scripts to your computer and run them 100% offline at any time.

#### Step-by-Step Guide:
1. Visit the [Downloads section](#downloads--cryptographic-hashes) or click the **.BAT** button on any tool card on the website.
2. Save the `.bat` file to your preferred folder (e.g. `C:\Tools`, `Desktop`, or your project directory).
3. Double-click the file to launch it in Command Prompt, or run it directly from any command line:
   ```cmd
   DevSetupCenter.bat
   ```
4. Standalone files require zero internet connection and never expire.

---

## The 10 Tools

### 1. DEV Setup Center
**File:** [`tools/dev-setup-center/DevSetupCenter.bat`](tools/dev-setup-center/DevSetupCenter.bat)  
**Short ID:** `setup` | **Category:** Setup & Packages  
**Purpose:** Developer environment installer and package manager assistant.

- Performs pre-execution scans for WinGet, administrator privileges, and installed tools.
- Displays software inventory using the signature two-column `INSTALLED` vs `MISSING` dashboard.
- Includes a **Standard Developer Pack** for fresh Windows machines.
- Features **9 specialized Developer Packs**: Web, Python, C++, Java, Cloud/DevOps, Database, Creative, Power User, and Full Suite.
- Manages 46 curated developer applications.
- Automatically skips software that is already installed.
- Generates a local `Dev-Environment-Report.txt`.
- Provides verified navigation to official Google Antigravity resources.

```
INSTALLED                             MISSING
--------------------------------------------------------------
Git                                   Docker Desktop
Visual Studio Code                    PostgreSQL
Python 3.14                           OpenJDK 21
Node.js LTS + npm                     C/C++ Build Tools
--------------------------------------------------------------
Installed: 4                          Missing: 4
```

---

### 2. DEV Project Forge
**File:** [`tools/dev-project-forge/DevProjectForge.bat`](tools/dev-project-forge/DevProjectForge.bat)  
**Short ID:** `forge` | **Category:** Scaffolding  
**Purpose:** Instant project scaffolding and workspace initialization.

- Supports **14 production project templates**:
  - Python (Standard Console)
  - Python FastAPI (Async REST API with uvicorn)
  - Python Flask (Web application)
  - Node.js (Standard ESM)
  - Node.js Express (REST API with CORS)
  - React (React 18 + Vite JSX)
  - Vite (Vanilla frontend tooling)
  - C++ (Native MSVC/GCC application)
  - CMake C++ (Cross-platform 3.20+)
  - Java (Console application)
  - Java Maven (Standard enterprise `pom.xml`)
  - Java Gradle (Modern build system)
  - Static HTML5/CSS3/JavaScript
  - Generic Git repository
- Strict validation of invalid Windows path characters (`< > : " / \ | ? *`).
- Collision protection (prompts before overwriting existing folders).
- Tailored `.gitignore` and `README.md` generation per language.
- Creates Python virtual environments (`.venv`) with a single click.
- Initializes Git repositories with standard `main` branches.
- Opens projects in Visual Studio Code, Explorer, or Windows Terminal.

---

### 3. DEV Doctor
**File:** [`tools/dev-doctor/DevDoctor.bat`](tools/dev-doctor/DevDoctor.bat)  
**Short ID:** `doctor` | **Category:** Diagnostics  
**Purpose:** Developer environment health and toolchain diagnostics.

- **Non-alarmist status classification**: `[OK]`, `[WARN]`, `[FAIL]`, and `[INFO]` (missing optional tools are not marked as broken).
- Full Diagnosis mode running automated checks across all ecosystems.
- Git identity and credential check (`user.name`, `user.email`).
- Python, pip, and virtual environment status.
- Node.js, npm, and global package prefix verification.
- Java JDK, `JAVA_HOME`, Maven, and Gradle checks.
- C/C++ compiler detection (MSVC `cl.exe`, GCC, Clang, CMake, Visual Studio).
- Docker daemon connectivity and container status.
- Deep PATH inspection detecting broken and duplicate directories.
- Exports comprehensive diagnostic reports to `Dev-Doctor-Report.txt`.

---

### 4. DEV GitHub Toolkit
**File:** [`tools/dev-github-toolkit/DevGitHubToolkit.bat`](tools/dev-github-toolkit/DevGitHubToolkit.bat)  
**Short ID:** `github` | **Category:** Git Workflow  
**Purpose:** Git and GitHub workflow helper.

- **Strict Credential Safety**: Zero plain-text token or password entry.
- Seamless GitHub CLI (`gh`) integration with secure browser login (`gh auth login -w`).
- Configures global Git identity cleanly.
- Initializes repositories with standardized `main` default branch.
- Manages remotes (add, edit URL, remove).
- Staging and commit assistant with change preview.
- Safe branch manager (create, switch, delete).
- One-click browser opening of the repository on github.com.

---

### 5. DEV Package Hub
**File:** [`tools/dev-package-hub/DevPackageHub.bat`](tools/dev-package-hub/DevPackageHub.bat)  
**Short ID:** `package` | **Category:** Setup & Packages  
**Purpose:** Windows Package Manager (WinGet) terminal interface.

- Interactive search across official WinGet package repositories.
- Transparent installation: always previews package ID and source before running.
- Mandatory confirmation prompts for destructive operations (e.g. uninstallation).
- Checks and executes single-package or bulk upgrades (`winget upgrade`).
- Installed software inventory with filter queries.
- Curated Developer Quick-Picks (Compilers, IDEs, Databases, Cloud, Utilities).
- Audit logging: records operations to `%LOCALAPPDATA%\DevToolsSuite\package-hub.log`.

---

### 6. DEV System Toolkit
**File:** [`tools/dev-system-toolkit/DevSystemToolkit.bat`](tools/dev-system-toolkit/DevSystemToolkit.bat)  
**Short ID:** `system` | **Category:** Diagnostics  
**Purpose:** Developer-focused Windows system and runtime utility.

- **Developer Port Scanner**: Scans common server ports (`3000`, `5000`, `8000`, `8080`, `5432`, `27017`, `3306`, `6379`) and identifies listening PIDs and processes.
- **Process Monitor**: Filters running tasks specifically for development binaries (`node`, `python`, `java`, `code`, `git`, `docker`, `mongod`, `postgres`).
- Processor details: Cores, logical threads, clock speed, and hardware virtualization status.
- Physical RAM and virtual memory / pagefile utilization.
- Storage drive free space breakdowns and file system indicators.
- Network adapter configuration and internet ping reachability.
- Numbered PATH inspector validating directory existence.
- System report generation saved to `Dev-System-Report.txt`.

---

### 7. DEV File Organizer
**File:** [`tools/dev-file-organizer/DevFileOrganizer.bat`](tools/dev-file-organizer/DevFileOrganizer.bat)  
**Short ID:** `organize` | **Category:** Utilities  
**Purpose:** Workspace and folder classifier for developer assets and code.

- **Developer File Classification**: Automatically categorizes files into code, web, configs, documents, media, and archives across 30+ extensions (`.py`, `.ts`, `.rs`, `.go`, `.json`, `.yaml`, `.env`, `.sql`, `.svg`, `.obj`).
- **Simulation / Dry-Run Mode**: Inspect exactly what will be moved before any disk modifications occur.
- **Dotfile Protection**: Never moves hidden development files or Git internal structures (`.git`, `.gitignore`, `.env.local`).
- **Targeted Categorization**: Clean up messy Downloads, desktop drops, or project assets into clean structured directories.
- **Folder Summary**: Instant file counts, directory tree preview, and size breakdown.

---

### 8. DEV Clean Master
**File:** [`tools/dev-clean-master/DevCleanMaster.bat`](tools/dev-clean-master/DevCleanMaster.bat)  
**Short ID:** `clean` | **Category:** Utilities  
**Purpose:** Deep workspace cleaner and disk space reclaimer.

- **Build Artifact Scanner**: Recursively calculates disk space consumed by `node_modules`, `target`, `.venv`, `bin/obj`, `.vs`, and `dist`.
- **Package Manager Caches**: Clean npm cache (`npm cache clean --force`), pip cache, and Python `__pycache__` folders.
- **IDE Temporary Files**: Purge Visual Studio temporary files, Rider caches, and VS Code temporary workspace storage.
- **Docker Cleanup Integration**: Safe trigger for `docker system prune` with confirmation prompts.
- **Explicit Confirmation Safety**: Destructive cleanup actions always show estimated savings and require explicit confirmation (`Y/N`).

---

### 9. DEV Quick Server
**File:** [`tools/dev-quick-server/DevQuickServer.bat`](tools/dev-quick-server/DevQuickServer.bat)  
**Short ID:** `server` | **Category:** Utilities  
**Purpose:** Instant local HTTP development server.

- **Dual Engine Architecture**: Automatically uses Python `http.server` if available, or seamlessly falls back to a pure, built-in PowerShell `.NET HttpListener`. Requires zero external dependencies.
- **Configurable Port & Path**: Serve any directory on custom ports (`8000`, `3000`, `8080`, `5000`) with collision detection.
- **Local Network Sharing**: Automatically detects and displays your LAN IP address (`http://192.168.x.x:8080`) for testing on mobile devices or VMs.
- **Port Conflict Resolution**: Detects if a port is in use and provides one-click PID termination to free the port.
- **One-Click Browser Launch**: Automatically opens the default browser to the running server.

---

### 10. DEV Key Forge
**File:** [`tools/dev-key-forge/DevKeyForge.bat`](tools/dev-key-forge/DevKeyForge.bat)  
**Short ID:** `keygen` | **Category:** Utilities  
**Purpose:** Cryptographic key, SSL certificate, and secret generator.

- **SSH Keypair Generation**: Generates modern Ed25519 (recommended) and RSA 4096-bit keypairs with custom comments and auto-saves to `~/.ssh/`.
- **Localhost SSL Development Certificates**: Creates self-signed X.509 SSL certificates and private keys (`localhost.crt`, `localhost.key`) for HTTPS local development.
- **JWT & Encryption Secrets**: Generates cryptographically secure 256-bit and 512-bit Base64 and Hex random secret strings.
- **High-Entropy Passwords & API Tokens**: Generates secure 32-character and 64-character API keys with customizable character sets.
- **Cryptographic File Hash Calculator**: Computes instantaneous SHA-256, SHA-512, and MD5 hashes for any local file.

---

## Adding More Tools (Automated Workflow)

When you create or upload a new tool to the suite, DEV Tools Suite provides an automated synchronization script that updates the entire project catalog:

```
tools/
└── dev-my-utility/
    ├── DevMyUtility.bat       <-- Your standalone tool
    └── launch.ps1             <-- (Optional) Companion launcher
```

### How to Add a Tool:
1. Create a new folder under `tools/` (e.g. `tools/dev-api-tester/`).
2. Add your batch file (e.g. `DevApiTester.bat`). Follow the DEV brand guidelines (AnoS provider, ASCII banner, numeric menu).
3. Run the automated catalog updater:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\update-tools-catalog.ps1
   ```
4. **What happens automatically:**
   - Scans all folders inside `tools/` for `.bat` files.
   - Extracts metadata, taglines, and version numbers.
   - Calculates cryptographic SHA-256 hashes.
   - Updates `site/data/tools.json` with the new entry.
   - Regenerates `release/hashes.txt`.
   - The website, theme engine, search bar, and PowerShell launcher automatically reflect the new tool without manual HTML edits!

---

## Frontend UI/UX & SEO Architecture

The companion static website (located in `site/` and mirrored at the repository root for GitHub Pages) is engineered to deliver a modern visual experience:

### Design Aesthetics & Features
- **3-Way Visual Theme Switcher**:
  - `Cyber Dark`: Deep blue/cyan high-contrast terminal styling.
  - `Midnight Eclipse`: Ultra-dark OLED black palette with purple and emerald accents.
  - `Studio Light`: Crisp, high-readability developer workspace theme.
  - *No login required* &bull; Theme preference is persisted instantly in `localStorage`.
- **Live Search & Category Filtering**:
  - Global `/` keyboard shortcut instantly focuses the search bar.
  - Filter pills for `All`, `Setup & Packages`, `Scaffolding`, `Diagnostics`, `Git Workflow`, and `Utilities`.
- **Interactive Terminal Hero**:
  - Interactive tabs showing real-time ASCII terminal previews for all 10 tools.
- **Inspectable Detail Modal**:
  - Click **View Tool** on any card to view detailed capabilities, system requirements, SHA-256 checksums, and one-click copy launch commands.
- **Dual Direct Downloads**:
  - Direct `.BAT` download buttons on every tool card and in the modal dialog.

### SEO & Web Discovery
- **Schema.org JSON-LD**: Embedded structured data (`SoftwareApplication`) for rich search engine indexing.
- **OpenGraph & Twitter Cards**: Social media cards for rich link previews on Discord, Twitter/X, and LinkedIn.
- **XML Sitemap**: Canonical URLs maintained in `site/sitemap.xml` and `sitemap.xml`.
- **Search Engine Crawler Control**: Configured `robots.txt` allowing full indexing.

---

## PowerShell Web Launcher

The unified launcher (`launcher/DevLauncher.ps1`) allows executing any tool directly from the web or from a local clone:

```powershell
# Interactive menu:
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1

# Direct tool execution:
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1 -Tool setup
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1 -Tool organize
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1 -Tool clean
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1 -Tool server
powershell -ExecutionPolicy Bypass -File .\launcher\DevLauncher.ps1 -Tool keygen
```

### Launcher Parameters
- `-Tool <name>`: Launches a specific tool by short ID or name.
- `-VerifyHash`: Validates the SHA-256 checksum against `release/hashes.txt` before running.
- `-Clean`: Purges cached batch files in `%LOCALAPPDATA%\DevToolsSuite`.
- `-NoCache`: Forces a fresh download on each execution.

---

## Downloads & Cryptographic Hashes

All release artifacts are cryptographically hashed using SHA-256. Hashes are permanently recorded in [`release/hashes.txt`](release/hashes.txt).

| Tool Name | File Name | Size | SHA-256 Checksum | Standalone Download |
|:---|:---|:---:|:---:|:---:|
| **DEV Clean Master** | `DevCleanMaster.bat` | 11 KB | `6ACED10F0C11...` | [Download](tools/dev-clean-master/DevCleanMaster.bat) |
| **DEV Doctor** | `DevDoctor.bat` | 17 KB | `325B798A3C4D...` | [Download](tools/dev-doctor/DevDoctor.bat) |
| **DEV File Organizer** | `DevFileOrganizer.bat` | 11 KB | `F48D6C3BCECC...` | [Download](tools/dev-file-organizer/DevFileOrganizer.bat) |
| **DEV GitHub Toolkit** | `DevGitHubToolkit.bat` | 15 KB | `05A8578A4BDE...` | [Download](tools/dev-github-toolkit/DevGitHubToolkit.bat) |
| **DEV Key Forge** | `DevKeyForge.bat` | 14 KB | `037380962AC8...` | [Download](tools/dev-key-forge/DevKeyForge.bat) |
| **DEV Package Hub** | `DevPackageHub.bat` | 14 KB | `694D538D4A88...` | [Download](tools/dev-package-hub/DevPackageHub.bat) |
| **DEV Project Forge** | `DevProjectForge.bat` | 23 KB | `AF4D20DC9D87...` | [Download](tools/dev-project-forge/DevProjectForge.bat) |
| **DEV Quick Server** | `DevQuickServer.bat` | 12 KB | `0BF778CF4FA7...` | [Download](tools/dev-quick-server/DevQuickServer.bat) |
| **DEV Setup Center** | `DevSetupCenter.bat` | 27 KB | `5E9CFA98516B...` | [Download](tools/dev-setup-center/DevSetupCenter.bat) |
| **DEV System Toolkit** | `DevSystemToolkit.bat` | 15 KB | `C2878727CD62...` | [Download](tools/dev-system-toolkit/DevSystemToolkit.bat) |

---

## System Requirements

- **Operating System**: Windows 11 or Windows 10 (Build 19041 and later)
- **Architecture**: x64 (AMD64) or ARM64
- **Terminal**: Windows Terminal (recommended) or Command Prompt (`cmd.exe`)
- **Package Manager**: Windows Package Manager (`winget`) recommended for Setup Center and Package Hub
- **Privileges**: Standard user privileges for most utilities; Administrator privileges recommended for system-wide software installation

---

## Project Structure

```
DevToolsSuite/
├── references/                      # Original reference batch files
│   ├── Dev_Setup_Center.bat
│   └── FileOrganizer.bat
├── tools/
│   ├── dev-setup-center/            # Tool 1: Environment installer
│   │   ├── DevSetupCenter.bat
│   │   └── launch.ps1
│   ├── dev-project-forge/           # Tool 2: Project scaffolding
│   │   ├── DevProjectForge.bat
│   │   └── launch.ps1
│   ├── dev-doctor/                  # Tool 3: Toolchain diagnostics
│   │   ├── DevDoctor.bat
│   │   └── launch.ps1
│   ├── dev-github-toolkit/          # Tool 4: Git/GitHub workflow
│   │   ├── DevGitHubToolkit.bat
│   │   └── launch.ps1
│   ├── dev-package-hub/             # Tool 5: WinGet interface
│   │   ├── DevPackageHub.bat
│   │   └── launch.ps1
│   ├── dev-system-toolkit/          # Tool 6: System telemetry & ports
│   │   ├── DevSystemToolkit.bat
│   │   └── launch.ps1
│   ├── dev-file-organizer/          # Tool 7: Developer file classifier
│   │   ├── DevFileOrganizer.bat
│   │   └── launch.ps1
│   ├── dev-clean-master/            # Tool 8: Cache & artifact cleaner
│   │   ├── DevCleanMaster.bat
│   │   └── launch.ps1
│   ├── dev-quick-server/            # Tool 9: Local HTTP server
│   │   ├── DevQuickServer.bat
│   │   └── launch.ps1
│   └── dev-key-forge/               # Tool 10: SSH & cryptographic keygen
│       ├── DevKeyForge.bat
│       └── launch.ps1
├── launcher/
│   └── DevLauncher.ps1              # Unified PowerShell web launcher
├── site/                            # Static web frontend
│   ├── data/
│   │   └── tools.json               # Data-driven metadata source
│   ├── css/
│   │   └── style.css                # Multi-theme CSS styling
│   ├── js/
│   │   └── app.js                   # Client UI & theme engine
│   ├── robots.txt                   # Search crawler directives
│   ├── sitemap.xml                  # SEO sitemap
│   └── index.html                   # Site documentation portal
├── release/
│   └── hashes.txt                   # Cryptographic SHA-256 checksums
├── scripts/
│   ├── update-tools-catalog.ps1     # Automated tool discovery & hash generator
│   ├── validate-tools.ps1           # 69-point static test suite
│   ├── test-bat-syntax.ps1          # 497-point batch jump target validator
│   └── generate-hashes.ps1          # Checksum recalculator
├── index.html                       # Root GitHub Pages landing page
├── robots.txt                       # Root web crawler directives
├── sitemap.xml                      # Root SEO sitemap
├── README.md                        # Documentation
└── LICENSE                          # MIT License (AnoS)
```

---

## Security Model

1. **Open Source & Inspectable**: Every line of batch and PowerShell script is readable in this repository.
2. **Zero Remote Execution Traps**: No arbitrary `iex` piping of untrusted web scripts.
3. **No Credential Exposure**: Passwords and access tokens are never requested or written to disk.
4. **Audit Logging**: Package operations are recorded to `%LOCALAPPDATA%\DevToolsSuite\package-hub.log`.
5. **No Malicious Persistence**: No registry run keys, scheduled tasks, or Defender tampering.

---

## Testing & Validation

The suite includes comprehensive automated verification suites:

### 1. Catalog Update & Hash Verification
Scans all tools and recalculates hashes:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update-tools-catalog.ps1
```

### 2. Static Integrity Test Suite
Runs a 69-point test verifying file existence, size constraints, brand adherence, and zero forbidden identifiers:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-tools.ps1
```

### 3. Batch Syntax & Label Jump Validator
Analyzes every `goto` and `call :label` across all 10 batch files to ensure 100% resolution with zero missing jump targets:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test-bat-syntax.ps1
```

---

## Contributing

Contributions to the DEV Tools Suite are welcome:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-tool`).
3. Add your tool under `tools/dev-your-tool/`.
4. Run `.\scripts\update-tools-catalog.ps1` to update metadata and checksums.
5. Ensure all tests pass (`.\scripts\validate-tools.ps1` and `.\scripts\test-bat-syntax.ps1`).
6. Open a Pull Request.

---

## License

Released under the **MIT License**. Copyright &copy; 2026 **AnoS**. See [LICENSE](LICENSE) for details.
