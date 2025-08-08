# Creating a New Paranext Extension: Complete Setup Prompt

*Use this prompt as a template when you want to create a new Paranext extension. Fill in the placeholders with your specific project details.*

## Project Setup Prompt Template

### 1. Project Information
**Project Name (human-readable):** `[Your Extension Name]`
**Kebab-case version:** `[your-extension-name]` (for folders, files, package names)
**CamelCase version:** `[yourExtensionName]` (for JavaScript/TypeScript identifiers)
**PascalCase version:** `[YourExtensionName]` (for component names, classes)

**Examples:**
- Human: "Scripture Reference Helper"
- Kebab: `scripture-reference-helper`
- Camel: `scriptureReferenceHelper`
- Pascal: `ScriptureReferenceHelper`

### 2. Prerequisites Checklist
Before starting, ensure you have:
- [ ] **Volta** installed (recommended) or **Node.js 22.16.0+**
- [ ] **Git** installed and configured
- [ ] **VS Code** (recommended) with suggested extensions
- [ ] **.NET 8 SDK** (for Platform.Bible core)
- [ ] **Platform.Bible core** cloned and working in `./paranext-core/` (same directory)
- [ ] **Target Version:** v0.4.0 (latest stable release) - not `main` branch

### 3. Extension Creation Commands

**Important:** Target a specific Platform.Bible release version, not `main`. For v0.4.0 development:

```bash
# Navigate to your development workspace
cd ~/Documents/dev/ptx  # or your preferred location

# Clone Platform.Bible core if not already done
git clone https://github.com/paranext/paranext-core.git
cd paranext-core

# Checkout the specific version you want to target (v0.4.0 recommended)
git checkout v0.4.0

# Install dependencies for Platform.Bible core
npm install
npm run build

# Navigate back to workspace for extension development
cd ..

# Clone the extension template
git clone https://github.com/paranext/paranext-extension-template.git [your-extension-name]

# Enter the new project directory
cd [your-extension-name]

# Install dependencies
npm install

# Remove the git history to start fresh
rm -rf .git
git init
git add .
git commit -m "Initial commit from paranext-extension-template for Platform.Bible v0.4.0"
```

### 4. File Renaming and Updates

#### A. Rename the Types File
```bash
# Rename the TypeScript declaration file
mv src/types/paranext-extension-template.d.ts src/types/[your-extension-name].d.ts
```

#### B. Update package.json
```json
{
  "name": "[your-extension-name]",
  "version": "0.0.1",
  "description": "[Brief description of what your extension does]",
  "author": "[Your Name]",
  "types": "src/types/[your-extension-name].d.ts",
  "main": "src/main.js"
}
```

#### C. Update manifest.json
```json
{
  "name": "[yourExtensionName]",
  "version": "0.0.1",
  "publisher": "[your-publisher-name]",
  "displayData": "assets/displayData.json",
  "author": "[Your Name]",
  "license": "MIT",
  "main": "src/main.ts",
  "types": "src/types/[your-extension-name].d.ts"
}
```

#### D. Update the Types File Content
**File:** `src/types/[your-extension-name].d.ts`
```typescript
declare module '[your-extension-name]' {
  // Add extension types exposed on the papi for other extensions to use here
  // Example:
  // export interface MyExtensionAPI {
  //   doSomething(input: string): Promise<string>;
  // }
}
```

#### E. Update package-lock.json
```bash
# Delete and regenerate to update package names
rm package-lock.json
npm install
```

### 5. Code Updates

#### A. Update src/main.ts
Replace the WebView type identifier:
```typescript
// Change this line:
const reactWebViewType = "paranextExtensionTemplate.react";
// To:
const reactWebViewType = "[yourExtensionName].react";
```

Update import paths if you're creating WebViews:
```typescript
// Update these imports to match your file names:
import extensionReact from "./web-views/[your-extension-name].web-view?inline";
import extensionStyles from "./web-views/[your-extension-name].web-view.scss?inline";
```

#### B. Create/Rename WebView Files (if using WebViews)
```bash
# If you plan to create WebViews, create appropriately named files:
touch src/web-views/[your-extension-name].web-view.tsx
touch src/web-views/[your-extension-name].web-view.scss
```

### 6. Project-Specific Configuration

#### A. Update README.md
Replace the template README with your project information:
```markdown
# [Your Extension Name]

[Brief description of what your extension does]

## Features

- [Feature 1]
- [Feature 2]
- [Feature 3]

## Installation

[Installation instructions for end users]

## Development

[Instructions for developers who want to contribute]
```

#### B. Update displayData.json
**File:** `assets/displayData.json`
```json
{
  "displayName": {
    "en": "[Your Extension Display Name]"
  },
  "shortDescription": {
    "en": "[Brief description for users]"
  }
}
```

### 7. Development Tools and Dependencies

#### Core Dependencies (Already Included)
- **React 18.3.1+** - UI framework
- **TypeScript** - Type-safe JavaScript
- **Webpack** - Module bundler
- **Tailwind CSS 3.4.17+** - Utility-first CSS framework
- **platform-bible-react** - Platform.Bible UI components
- **platform-bible-utils** - Utility functions

#### Development Dependencies
- **ESLint** - Code linting
- **Prettier** - Code formatting
- **Stylelint** - CSS linting
- **Jest/Vitest** - Testing framework
- **Husky** - Git hooks

#### Available Scripts
```bash
npm run build          # Build for development
npm run build:production # Build for production
npm run watch          # Watch and rebuild on changes
npm start              # Start Platform.Bible with your extension
npm run lint           # Check code quality
npm run format         # Format code
npm run package        # Create distributable package
```

### 8. Extension Architecture Setup

#### A. Choose Your Extension Type
**WebView Extension** (UI components):
- Creates user interfaces
- Uses React components
- Styled with Tailwind CSS

**Service Extension** (background functionality):
- Provides APIs to other extensions
- Handles data processing
- No UI components

**Hybrid Extension** (both UI and services):
- Combines WebViews and services
- Most complex but most powerful

#### B. Common Extension Patterns
```typescript
// Command registration pattern
papi.commands.registerCommand('[yourExtensionName].commandName', handler);

// Data provider pattern
papi.dataProviders.registerEngine('[yourExtensionName].dataType', engine);

// WebView provider pattern
papi.webViewProviders.registerWebViewProvider('[yourExtensionName].webViewType', provider);

// Event subscription pattern
papi.network.getNetworkEvent('[yourExtensionName].eventName').subscribe(handler);
```

### 9. Testing Your Setup

```bash
# Ensure Platform.Bible core is built and ready
cd ../paranext-core
npm run build

# Return to your extension directory
cd ../[your-extension-name]

# Build your extension
npm run build

# Start Platform.Bible with your extension (from paranext-core directory)
cd ../paranext-core
npm start

# Verify your extension loads in Platform.Bible
# Look for log messages like "[Your Extension] is activating!"
```

**Platform.Bible Version Targeting:**
- Always target a specific released version (e.g., v0.4.0)
- Check the [Software Version Info](https://github.com/paranext/paranext/wiki/Software-Version-Info) for the latest stable release
- Do not develop against the `main` branch as it's unstable

### 10. Git Repository Setup

```bash
# Initialize git repository (if not done earlier)
git init

# Add remote repository (replace with your repo URL)
git remote add origin https://github.com/[your-username]/[your-extension-name].git

# Create initial commit with version information
git add .
git commit -m "Initial extension setup from template

Target Platform.Bible version: v0.4.0
Extension Template: paranext-extension-template
Development started: $(date)"

# Push to remote repository
git push -u origin main
```

### 11. Additional Tools That Enhance the Prompt

#### A. IDE Extensions (VS Code)
- **ES7+ React/Redux/React-Native snippets**
- **Tailwind CSS IntelliSense**
- **TypeScript Importer**
- **GitLens**
- **Thunder Client** (for API testing)

#### B. Development Workflow Tools
```bash
# Ensure Platform.Bible core is ready
cd ../paranext-core && git checkout v0.4.0 && npm install && npm run build

# Hot reload development (run in separate terminals)
cd ../[your-extension-name]
npm run watch  # In one terminal

cd ../paranext-core
npm start      # In another terminal (starts Platform.Bible)

# Code quality checks
npm run lint
npm run format:check
npm run typecheck
```

#### C. Debugging Setup
```json
// .vscode/launch.json configuration for debugging
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Extension in Platform.Bible",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/../paranext-core/src/main/main.ts",
      "args": ["--extensions", "${workspaceFolder}/dist"]
    }
  ]
}
```

### 12. What Makes This Prompt Complete and Accurate

#### Essential Elements Included:
1. **Clear naming conventions** - Covers all case formats needed
2. **Step-by-step file updates** - No guesswork about what to change
3. **Complete dependency list** - All tools and versions specified
4. **Architecture guidance** - Helps choose the right extension type
5. **Testing instructions** - Ensures setup works before development
6. **Development workflow** - Real commands developers will use daily

#### Additional Elements That Could Enhance This:
1. **Extension examples** - Links to reference implementations
2. **Common troubleshooting** - Solutions to frequent setup issues
3. **Performance guidelines** - Best practices for extension development
4. **Deployment instructions** - How to distribute the finished extension
5. **API documentation references** - Links to Platform.Bible APIs
6. **Community resources** - Discord, forums, contribution guidelines

### 13. Example Usage

**Creating a "Verse Memory Helper" extension:**

```bash
# Project names
Human: "Verse Memory Helper"
Kebab: verse-memory-helper
Camel: verseMemoryHelper  
Pascal: VerseMemoryHelper

# Setup commands (targeting v0.4.0)
cd ~/Documents/dev/ptx

# Ensure Platform.Bible core is ready with v0.4.0
git clone https://github.com/paranext/paranext-core.git  # if not already cloned
cd paranext-core
git checkout v0.4.0
npm install && npm run build
cd ..

# Create the extension
git clone https://github.com/paranext/paranext-extension-template.git verse-memory-helper
cd verse-memory-helper
mv src/types/paranext-extension-template.d.ts src/types/verse-memory-helper.d.ts

# Update package.json name to: "verse-memory-helper"
# Update manifest.json name to: "verseMemoryHelper"
# Update WebView type to: "verseMemoryHelper.react"
```

---

*This prompt template ensures consistent, correct extension setup every time. Customize the bracketed placeholders for your specific project needs.*
