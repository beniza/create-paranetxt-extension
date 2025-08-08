# Create Paranext Extension

🚀 **Automated tool for creating Platform.Bible extensions**

A comprehensive script that sets up a complete Platform.Bible extension development environment with one command.

## Quick Start

```bash
# Make executable (first time only)
chmod +x create-paranext-extension.sh

# Create a new extension interactively
./create-paranext-extension.sh

# Or create with command-line arguments
./create-paranext-extension.sh --name "My Extension" --author "Your Name"
```

## Features

✨ **Complete Automation**
- Clones and sets up paranext-core v0.4.0
- Creates extension from official template
- Installs dependencies and builds project
- Creates welcome webview with congratulations message
- Sets up symlink for Platform.Bible integration

🎯 **Smart Setup**
- Validates prerequisites (Node.js, Git, etc.)
- Handles naming conventions automatically
- Creates proper TypeScript/React structure
- Includes Tailwind CSS styling
- Follows Platform.Bible best practices

⚡ **Ready to Use**
- Extension appears in Platform.Bible immediately
- Welcome screen guides next steps
- Full development workflow included
- Git repository initialized with first commit

## What You Get

```
your-extension/
├── src/
│   ├── main.ts                 # Extension entry point
│   ├── types/                  # TypeScript declarations
│   └── web-views/
│       └── welcome.web-view.tsx # Welcome screen
├── package.json                # Dependencies & scripts
├── manifest.json              # Extension metadata
├── tsconfig.json              # TypeScript config
├── tailwind.config.ts         # Styling config
└── .gitignore                 # Git ignore rules
```

## Documentation

- **[Extension Creation Guide](docs/paranext-extension-creation-prompt.md)** - Step-by-step manual process
- **[Script Usage Guide](docs/script-usage-guide.md)** - Detailed script documentation
- **[Workspace Setup Guide](docs/workspace-setup-guide.md)** - Platform.Bible development setup

## Requirements

- **Node.js 22.16.0+** (Volta recommended)
- **Git** with GitHub access
- **Platform.Bible v0.4.0** (script sets this up automatically)

## Usage Examples

### Interactive Mode (Beginner Friendly)
```bash
./create-paranext-extension.sh
# Follow the prompts to enter your extension details
```

### Command Line Mode (Automation Friendly)
```bash
./create-paranext-extension.sh \
  --name "Scripture Memory Helper" \
  --author "John Doe" \
  --publisher "myOrg" \
  --description "Helps users memorize Bible verses"
```

### Development Workflow
```bash
# 1. Create extension
./create-paranext-extension.sh --name "My Extension"

# 2. Start development
cd my-extension
npm run watch

# 3. Start Platform.Bible (in another terminal)
cd ../paranext-core
npm start
```

## Extension Types Supported

- **WebView Extensions** - UI components with React
- **Service Extensions** - Background services and APIs
- **Hybrid Extensions** - Combination of UI and services
- **Data Provider Extensions** - Scripture and content providers

## Contributing

Found an issue or want to improve the script? Feel free to:
- Report bugs or request features
- Submit pull requests
- Share extension templates
- Improve documentation

## License

This tool follows the same license as Platform.Bible core.

---

**Happy extension building!** 🛠️✨
