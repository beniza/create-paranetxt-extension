# Platform.Bible Extension Development Workspace

This workspace contains tools and examples for Platform.Bible extension development, targeting **v0.4.0** (stable release).

## Quick Start

### 1. Create a New Extension

```bash
# Interactive mode (recommended for beginners)
./create-extension.sh

# Command line mode
./create-extension.sh --name "My Extension" --author "Your Name"
```

### 2. Development Workflow

```bash
# Start development mode (in extension directory)
npm run watch

# Test in Platform.Bible (in another terminal)
cd ../paranext-core && npm start
```

## What's in This Workspace

### 🤖 Automation Tools
- **`create-extension.sh`** - Automated extension creation script
  - ✅ Sets up Platform.Bible core v0.4.0 automatically
  - ✅ Creates extension from official template
  - ✅ Handles all file renaming and updates
  - ✅ Version-safe development environment

### 📁 Example Extensions
- **`hello-world/`** - Complete example extension
  - ✅ Working "Hello World" extension with Tailwind CSS
  - ✅ Modern development setup
  - ✅ Comprehensive documentation

### 📚 Documentation
- **`hello-world/docs/`** - Comprehensive guides
  - `platform-bible-setup-guide.md` - Complete setup instructions
  - `paranext-extension-creation-prompt.md` - Extension creation template
  - `script-usage-guide.md` - Automation script documentation
  - `version-targeting-update.md` - Version targeting overview

### 🎯 Platform.Bible Core
- **`paranext-core/`** - Platform.Bible core (auto-managed)
  - ✅ Automatically cloned and configured
  - ✅ Switched to v0.4.0 stable release
  - ✅ Dependencies installed and built

## Key Features

### Version Safety 🔒
- **Targets v0.4.0**: Stable release, not unstable `main`
- **Consistent APIs**: Predictable development environment
- **User Compatibility**: Extensions work with released Platform.Bible

### Complete Automation 🚀
- **One Command Setup**: `./create-extension.sh --name "My Extension"`
- **Smart Detection**: Checks versions and dependencies
- **Zero Manual Steps**: Ready for development immediately

### Modern Development 💻
- **Tailwind CSS**: Utility-first styling
- **TypeScript**: Type-safe development
- **Hot Reload**: Watch mode for rapid development
- **Quality Tools**: Linting, formatting, testing

## Prerequisites

Install these tools before getting started:

```bash
# 1. Install Volta (recommended for Node.js management)
curl https://get.volta.sh | bash

# 2. Restart terminal, then Volta will auto-install correct Node.js version

# 3. Install .NET 8 SDK
# Download from: https://dotnet.microsoft.com/download/dotnet/8.0

# 4. Verify installations
node --version  # Should be 22.16.0+
npm --version   # Should be included with Node.js
git --version   # Should be available
dotnet --version # Should be 8.0+
```

## Extension Creation Examples

### Bible Study Extension
```bash
./create-extension.sh \
  --name "Advanced Bible Study Tools" \
  --author "Bible Study Team" \
  --publisher "faithTech" \
  --description "Advanced tools for in-depth Bible study and analysis"
```

### Translation Helper
```bash
./create-extension.sh \
  --name "Translation Assistant" \
  --author "Translation Team" \
  --publisher "translationOrg" \
  --description "Tools to assist with Bible translation work"
```

### Scripture Memory Tool
```bash
./create-extension.sh \
  --name "Scripture Memory Helper" \
  --author "Memory Team" \
  --publisher "memoryTools" \
  --description "Interactive tools for memorizing Bible verses"
```

## Development Commands

### In Extension Directory
```bash
npm run build          # Build for development
npm run watch          # Watch and rebuild on changes
npm run lint           # Check code quality
npm run format         # Format code
npm run package        # Create distributable package
```

### Testing with Platform.Bible
```bash
# Start Platform.Bible with your extension
cd ../paranext-core
npm start

# The extension will be automatically loaded
```

## Troubleshooting

### Common Issues

1. **"paranext-core not found"**
   - Solution: Run `./create-extension.sh` - it will set up paranext-core automatically

2. **"Wrong Node.js version"**
   - Solution: Install Volta (`curl https://get.volta.sh | bash`) and restart terminal

3. **"Extension not loading"**
   - Solution: Check that paranext-core is built (`cd paranext-core && npm run build`)

4. **"Build errors"**
   - Solution: Ensure you're on v0.4.0 (`cd paranext-core && git checkout v0.4.0`)

### Getting Help

- **Platform.Bible Documentation**: https://paranext.github.io/paranext-core/
- **Extension Template Wiki**: https://github.com/paranext/paranext-extension-template/wiki
- **Version Information**: https://github.com/paranext/paranext/wiki/Software-Version-Info

## Contributing

1. Create extensions following the established patterns
2. Update documentation for any new features
3. Test against Platform.Bible v0.4.0
4. Share useful extensions with the community

---

**Target Version**: Platform.Bible v0.4.0  
**Last Updated**: August 2025  
**Automation Version**: 1.0
