# Extension Creation Script Usage Guide

## Overview

The `create-extension.sh` script automates the entire process of creating a new Paranext extension from the template. It handles all the tedious file renaming, content updating, and initial setup steps.

**Key Features:**
- ✅ **Version Targeting:** Automatically sets up Platform.Bible core v0.4.0 (stable release)
- ✅ **Complete Automation:** Handles prerequisite checking, paranext-core setup, and extension creation
- ✅ **Smart Dependencies:** Installs and builds paranext-core if needed
- ✅ **Version Safety:** Ensures you're developing against stable APIs, not unstable `main` branch

## Quick Start

### 1. Make the script executable (one time only)
```bash
chmod +x create-extension.sh
```

### 2. Run the script
```bash
# Interactive mode (recommended for beginners)
./create-extension.sh

# Or from any directory (using absolute path)
bash /home/ben/Documents/dev/ptx/create-extension.sh
```

**What happens automatically:**
1. ✅ Checks prerequisites (Node.js, Git, .NET SDK)
2. ✅ Sets up paranext-core repository with v0.4.0
3. ✅ Installs dependencies and builds paranext-core
4. ✅ Creates your extension from template
5. ✅ Updates all files with your extension details
6. ✅ Tests the build to ensure everything works

## Usage Modes

### Interactive Mode (Recommended)
```bash
./create-extension.sh
```
The script will prompt you for all required information:
- Extension name
- Author name  
- Publisher name
- Description
- Workspace directory

### Command Line Mode
```bash
./create-extension.sh \
  --name "Scripture Memory Helper" \
  --author "John Doe" \
  --publisher "myPublisher" \
  --description "Helps users memorize Bible verses" \
  --workspace ~/Documents/dev/ptx
```

### Semi-Automated Mode
```bash
# Provide some info, script will ask for the rest
./create-extension.sh --name "My Extension" --author "Your Name"
```

## Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `-h, --help` | Show help message | `--help` |
| `-n, --name` | Extension name | `--name "Bible Helper"` |
| `-a, --author` | Author name | `--author "John Doe"` |
| `-p, --publisher` | Publisher name | `--publisher "myCompany"` |
| `-d, --description` | Extension description | `--description "Helps with Bible study"` |
| `-w, --workspace` | Workspace directory | `--workspace ~/dev/extensions` |
| `--skip-deps` | Skip npm install | `--skip-deps` |
| `--skip-git` | Skip git initialization | `--skip-git` |
| `--skip-test` | Skip build test | `--skip-test` |

## What the Script Does

### 1. **Prerequisites Check**
- ✅ Verifies git, npm, and node are installed
- ✅ Checks Node.js version (warns if < 18)
- ✅ Looks for paranext-core in current directory
- ✅ Checks if paranext-core is on correct version (v0.4.0)

### 2. **Platform.Bible Core Setup**
- 📥 Clones paranext-core repository if not present
- 🔄 Switches to v0.4.0 stable release (not unstable `main`)
- 📦 Installs dependencies automatically
- 🔨 Builds paranext-core if needed
- ✅ Ensures stable development environment

### 3. **Name Generation**
- 📝 Converts your extension name to all required formats:
  - **Kebab-case**: `scripture-memory-helper` (files/folders)
  - **CamelCase**: `scriptureMemoryHelper` (JS/TS identifiers)  
  - **PascalCase**: `ScriptureMemoryHelper` (components/classes)

### 4. **Template Setup**
- 📂 Clones the official extension template
- 🗂️ Creates a new directory with your extension name
- 🔄 Removes template's git history and initializes fresh repo

### 5. **File Operations**
- 📄 Renames `paranext-extension-template.d.ts` → `your-extension-name.d.ts`
- ✏️ Updates all references in:
  - `package.json`
  - `manifest.json`
  - `src/types/your-extension-name.d.ts`
  - `src/main.ts`
  - `README.md`
  - `assets/displayData.json`

### 6. **Dependency Management**
- 📦 Removes old `package-lock.json`
- 🔄 Runs `npm install` to generate new lock file
- ✅ Installs all required dependencies

### 7. **Quality Assurance**
- 🏗️ Tests that the extension builds successfully
- 📝 Creates initial git commit with version information
- 🎯 Verifies everything is working

### 8. **Version Safety**
- 🎯 Targets Platform.Bible v0.4.0 (stable release)
- 📋 Documents target version in commit message
- ⚠️ Avoids unstable `main` branch development
- 🔒 Ensures API compatibility with released version

## Example Usage Scenarios

### Creating a Bible Study Extension
```bash
./create-extension.sh \
  --name "Advanced Bible Study Tools" \
  --author "Bible Study Team" \
  --publisher "faithTech" \
  --description "Advanced tools for in-depth Bible study and analysis"
```

**Generated names:**
- Kebab: `advanced-bible-study-tools`
- Camel: `advancedBibleStudyTools`
- Pascal: `AdvancedBibleStudyTools`

**What happens:**
1. ✅ Sets up paranext-core v0.4.0 if needed
2. ✅ Creates extension targeting stable APIs
3. ✅ Ready for development against released version

### Creating a Translation Helper
```bash
./create-extension.sh \
  --name "Translation Assistant" \
  --author "SIL International" \
  --description "Assists translators with contextual suggestions"
```

### Quick Development Setup
```bash
# For rapid prototyping, skip time-consuming steps
./create-extension.sh \
  --name "Quick Prototype" \
  --skip-deps \
  --skip-test
```

## Script Output

The script provides colorful, informative output:

```
🚀 Paranext Extension Creator
==================================================

ℹ️  Checking prerequisites...
✅ All prerequisites met!

ℹ️  Please provide the following information:
📝 Enter your extension name: Scripture Memory Helper

ℹ️  Generated name variations:
  📁 Kebab-case: scripture-memory-helper
  🐪 CamelCase: scriptureMemoryHelper  
  🅿️  PascalCase: ScriptureMemoryHelper

✅ Extension creation completed successfully!

Next steps:
  1. cd scripture-memory-helper
  2. npm run watch    # Start development mode
  3. npm start        # Test in Platform.Bible
```

## Troubleshooting

### Common Issues

**"Command not found"**
```bash
# Make sure you're running from the correct directory
cd /home/ben/Documents/dev/ptx
./create-extension.sh

# Or use absolute path
bash /home/ben/Documents/dev/ptx/create-extension.sh
```

**"Permission denied"**
```bash
# Make the script executable
chmod +x create-extension.sh
```

**"Directory already exists"**
- The script will ask if you want to remove the existing directory
- Choose a different name, or manually remove the directory first

**"Git not found"**
```bash
# Install git first
sudo apt install git  # Linux
brew install git       # macOS
# Download from git-scm.com for Windows
```

**"Node.js version too old"**
```bash
# Install Volta (recommended)
curl https://get.volta.sh | bash

# Or update Node.js directly
# Visit nodejs.org for latest version
```

### Debug Mode

For troubleshooting, you can run the script with debug output:
```bash
bash -x create-extension.sh
```

This will show every command being executed.

## Advanced Usage

### Using in CI/CD Pipelines
```bash
# Non-interactive mode for automation
./create-extension.sh 
  --name "$EXTENSION_NAME" 
  --author "$AUTHOR" 
  --publisher "$PUBLISHER" 
  --description "$DESCRIPTION" 
  --workspace "$WORKSPACE" 
  --skip-deps  # Install deps separately in CI
```

### Batch Creation
```bash
# Create multiple extensions
extensions=("Bible Search" "Verse Highlighter" "Study Notes")
for ext in "${extensions[@]}"; do
  ./create-extension.sh --name "$ext" --author "Dev Team"
done
```

### Custom Workspace Structure
```bash
# Create in specific directory structure
./create-extension.sh 
  --name "Team Extension" 
  --workspace ~/projects/platform-bible/extensions
```

### Batch Creation
```bash
# Create multiple extensions
extensions=("Bible Search" "Verse Highlighter" "Study Notes")
for ext in "${extensions[@]}"; do
  ./scripts/create-extension.sh --name "$ext" --author "Dev Team"
done
```

### Custom Workspace Structure
```bash
# Create in specific directory structure
./scripts/create-extension.sh \
  --name "Team Extension" \
  --workspace ~/projects/platform-bible/extensions
```

## Integration with IDEs

### VS Code Integration
Add to your VS Code tasks.json:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Create New Extension",
      "type": "shell",
      "command": "${workspaceFolder}/create-extension.sh",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
```

Then use Ctrl+Shift+P → "Tasks: Run Task" → "Create New Extension"

## Script Features

### ✅ **Error Handling**
- Stops on any error (`set -e`)
- Validates all prerequisites
- Checks for existing directories
- Provides helpful error messages

### ✅ **User-Friendly**
- Colorful output with emojis
- Clear progress indicators  
- Confirmation prompts for destructive actions
- Comprehensive help documentation

### ✅ **Flexible**
- Interactive or command-line modes
- Optional steps can be skipped
- Works from any directory
- Supports various workspace structures

### ✅ **Robust**
- Handles edge cases (existing directories, missing tools)
- Validates input
- Tests the final output
- Provides rollback suggestions

---

*This script saves you 10-15 minutes of manual work and eliminates common setup errors!*
