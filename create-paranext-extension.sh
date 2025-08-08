#!/bin/bash

# Paranext Extension Creator Script
# Automates the creation of a new Paranext extension from the template
# Author: Platform.Bible Developer Community
# Version: 1.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "  🚀 Paranext Extension Creator"
    echo "=================================================="
    echo -e "${NC}"
}

# Function to convert string to different cases
to_kebab_case() {
    echo "$1" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-\|-$//g'
}

to_camel_case() {
    local kebab="$1"
    echo "$kebab" | sed 's/-\([a-z]\)/\U\1/g'
}

to_pascal_case() {
    local camel="$1"
    echo "${camel^}"  # Capitalize first letter
}

# Function to validate prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Check for npm
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    fi
    
    # Check for node
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    else
        # Check Node.js version
        local node_version=$(node --version | sed 's/v//')
        local major_version=$(echo $node_version | cut -d. -f1)
        if [ "$major_version" -lt 18 ]; then
            print_warning "Node.js version $node_version detected. Version 18+ recommended."
        fi
    fi
    
    # Check for paranext-core
    if [ ! -d "paranext-core" ]; then
        print_warning "paranext-core not found in current directory."
        print_info "The script will help you set up paranext-core targeting v0.4.0 if needed."
    else
        # Check if paranext-core is on the correct version
        if [ -d "paranext-core/.git" ]; then
            current_branch=$(cd paranext-core && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
            current_tag=$(cd paranext-core && git describe --exact-match --tags 2>/dev/null || echo "")
            
            if [ "$current_tag" != "v0.4.0" ] && [ "$current_branch" != "v0.4.0" ]; then
                print_warning "paranext-core is not on v0.4.0 (currently on: $current_branch $current_tag)"
                print_info "Recommended: Switch to v0.4.0 for stable extension development"
            fi
        fi
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install missing dependencies and try again."
        exit 1
    fi
    
    print_success "All prerequisites met!"
}

# Function to setup paranext-core with correct version
setup_paranext_core() {
    print_info "Setting up Platform.Bible core (v0.4.0)..."
    
    # Convert WORKSPACE_DIR to absolute path to avoid confusion
    WORKSPACE_DIR=$(realpath "$WORKSPACE_DIR")
    cd "$WORKSPACE_DIR"
    
    if [ ! -d "paranext-core" ]; then
        print_info "Cloning paranext-core repository..."
        git clone https://github.com/paranext/paranext-core.git --quiet
        print_success "paranext-core cloned!"
    fi
    
    cd paranext-core
    
    # Check current version and switch if needed
    current_tag=$(git describe --exact-match --tags 2>/dev/null || echo "")
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    
    if [ "$current_tag" != "v0.4.0" ] && [ "$current_branch" != "v0.4.0" ]; then
        print_info "Switching to v0.4.0..."
        git fetch --tags --quiet
        git checkout v0.4.0 --quiet
        print_success "Switched to v0.4.0!"
    else
        print_success "Already on v0.4.0!"
    fi
    
    # Install dependencies if node_modules doesn't exist or is outdated
    if [ ! -d "node_modules" ] || [ "package.json" -nt "node_modules" ]; then
        print_info "Installing paranext-core dependencies..."
        npm install --silent
        print_success "paranext-core dependencies installed!"
    else
        print_success "paranext-core dependencies up to date!"
    fi
    
    # Build if needed
    if [ ! -d "dist" ] || [ "src" -nt "dist" ]; then
        print_info "Building paranext-core..."
        npm run build --silent
        print_success "paranext-core built!"
    else
        print_success "paranext-core already built!"
    fi
    
    cd "$WORKSPACE_DIR"
    print_success "Platform.Bible core (v0.4.0) ready!"
}

# Function to prompt for user input
get_user_input() {
    print_info "Please provide the following information:"
    echo
    
    # Get extension name
    while [ -z "$EXTENSION_NAME" ]; do
        read -p "📝 Enter your extension name (e.g., 'Scripture Reference Helper'): " EXTENSION_NAME
        if [ -z "$EXTENSION_NAME" ]; then
            print_warning "Extension name cannot be empty!"
        fi
    done
    
    # Generate case variations
    KEBAB_NAME=$(to_kebab_case "$EXTENSION_NAME")
    CAMEL_NAME=$(to_camel_case "$KEBAB_NAME")
    PASCAL_NAME=$(to_pascal_case "$CAMEL_NAME")
    
    echo
    print_info "Generated name variations:"
    echo "  📁 Kebab-case (folders/files): $KEBAB_NAME"
    echo "  🐪 CamelCase (JS/TS identifiers): $CAMEL_NAME"
    echo "  🅿️  PascalCase (components/classes): $PASCAL_NAME"
    echo
    
    # Confirm names
    read -p "❓ Are these names correct? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Let's try again..."
        EXTENSION_NAME=""
        get_user_input
        return
    fi
    
    # Get author info
    read -p "👤 Enter your name (author): " AUTHOR_NAME
    [ -z "$AUTHOR_NAME" ] && AUTHOR_NAME="Your Name"
    
    read -p "🏢 Enter publisher name (optional): " PUBLISHER_NAME
    [ -z "$PUBLISHER_NAME" ] && PUBLISHER_NAME="yourPublisher"
    
    read -p "📄 Enter extension description: " DESCRIPTION
    [ -z "$DESCRIPTION" ] && DESCRIPTION="A Platform.Bible extension"
    
    # Get workspace directory
    read -p "📂 Enter workspace directory (default: current directory): " WORKSPACE_DIR
    [ -z "$WORKSPACE_DIR" ] && WORKSPACE_DIR="."
    
    echo
    print_info "Configuration complete!"
}

# Function to clone and setup the template
setup_template() {
    print_info "Setting up extension template..."
    
    # Ensure we're in the workspace directory, not inside paranext-core
    # Convert to absolute path to avoid any confusion
    WORKSPACE_DIR=$(realpath "$WORKSPACE_DIR")
    cd "$WORKSPACE_DIR"
    
    # Check if directory already exists
    if [ -d "$KEBAB_NAME" ]; then
        print_error "Directory '$KEBAB_NAME' already exists!"
        read -p "❓ Remove existing directory and continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$KEBAB_NAME"
            print_success "Removed existing directory"
        else
            print_error "Aborted. Please choose a different name or remove the existing directory."
            exit 1
        fi
    fi
    
    # Clone the template
    print_info "Cloning extension template..."
    git clone https://github.com/paranext/paranext-extension-template.git "$KEBAB_NAME" --quiet
    
    cd "$KEBAB_NAME"
    
    # Remove git history and reinitialize
    print_info "Initializing new git repository..."
    rm -rf .git
    git init --quiet
    
    print_success "Template cloned successfully!"
}

# Function to rename files
rename_files() {
    print_info "Renaming template files..."
    
    # Rename the types file
    if [ -f "src/types/paranext-extension-template.d.ts" ]; then
        mv "src/types/paranext-extension-template.d.ts" "src/types/$KEBAB_NAME.d.ts"
        print_success "Renamed types file to $KEBAB_NAME.d.ts"
    fi
}

# Function to update file contents
update_files() {
    print_info "Updating file contents..."
    
    # Update package.json
    if [ -f "package.json" ]; then
        # Use a more robust sed approach with temp file
        sed -e "s/\"name\": \"paranext-extension-template\"/\"name\": \"$KEBAB_NAME\"/" \
            -e "s/\"types\": \"src\/types\/paranext-extension-template\.d\.ts\"/\"types\": \"src\/types\/$KEBAB_NAME.d.ts\"/" \
            -e "s/\"author\": \"Paranext\"/\"author\": \"$AUTHOR_NAME\"/" \
            -e "s/\"description\": \".*\"/\"description\": \"$DESCRIPTION\"/" \
            package.json > package.json.tmp && mv package.json.tmp package.json
        print_success "Updated package.json"
    fi
    
    # Update manifest.json
    if [ -f "manifest.json" ]; then
        sed -e "s/\"name\": \"paranextExtensionTemplate\"/\"name\": \"$CAMEL_NAME\"/" \
            -e "s/\"publisher\": \"paranext\"/\"publisher\": \"$PUBLISHER_NAME\"/" \
            -e "s/\"author\": \"Paranext\"/\"author\": \"$AUTHOR_NAME\"/" \
            -e "s/\"types\": \"src\/types\/paranext-extension-template\.d\.ts\"/\"types\": \"src\/types\/$KEBAB_NAME.d.ts\"/" \
            manifest.json > manifest.json.tmp && mv manifest.json.tmp manifest.json
        print_success "Updated manifest.json"
    fi
    
    # Update types file
    if [ -f "src/types/$KEBAB_NAME.d.ts" ]; then
        sed "s/declare module 'paranext-extension-template'/declare module '$KEBAB_NAME'/" \
            "src/types/$KEBAB_NAME.d.ts" > "src/types/$KEBAB_NAME.d.ts.tmp" && \
            mv "src/types/$KEBAB_NAME.d.ts.tmp" "src/types/$KEBAB_NAME.d.ts"
        print_success "Updated types file"
    fi
    
    # Update main.ts if it exists
    if [ -f "src/main.ts" ]; then
        # Update any references to paranextExtensionTemplate
        sed -i.bak "s/paranextExtensionTemplate/$CAMEL_NAME/g" src/main.ts
        rm -f src/main.ts.bak
        print_success "Updated main.ts"
    fi
    
    # Update README.md
    if [ -f "README.md" ]; then
        cat > README.md << EOF
# $EXTENSION_NAME

$DESCRIPTION

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

[Installation instructions for end users]

## Development

### Prerequisites

- Node.js 18+ (preferably installed via Volta)
- Platform.Bible core development environment

### Building

\`\`\`bash
npm install
npm run build
\`\`\`

### Testing

\`\`\`bash
npm start
\`\`\`

### Development

\`\`\`bash
npm run watch  # Watch for changes
\`\`\`

## License

MIT
EOF
        print_success "Updated README.md"
    fi
    
    # Update displayData.json
    if [ -f "assets/displayData.json" ]; then
        cat > assets/displayData.json << EOF
{
  "displayName": {
    "en": "$EXTENSION_NAME"
  },
  "shortDescription": {
    "en": "$DESCRIPTION"
  }
}
EOF
        print_success "Updated displayData.json"
    fi
}

# Function to create welcome webview
create_welcome_webview() {
    print_info "Creating welcome webview..."
    
    # Create web-views directory
    mkdir -p "src/web-views"
    
    # Create welcome webview component
    cat > "src/web-views/welcome.web-view.tsx" << 'EOF'
import { Button } from "platform-bible-react";

globalThis.webViewComponent = function WelcomeWebView() {
  return (
    <div className="tw-p-8 tw-bg-gradient-to-br tw-from-blue-50 tw-to-indigo-100 tw-min-h-screen tw-flex tw-items-center tw-justify-center">
      <div className="tw-bg-white tw-rounded-lg tw-shadow-xl tw-p-8 tw-max-w-2xl tw-w-full">
        <div className="tw-text-center tw-mb-8">
          <h1 className="tw-text-4xl tw-font-bold tw-text-blue-600 tw-mb-4">
            🎉 Welcome to Your Extension!
          </h1>
          <p className="tw-text-xl tw-text-gray-600 tw-mb-2">
            Congratulations! Your Platform.Bible extension is working perfectly.
          </p>
          <p className="tw-text-lg tw-text-gray-500">
            You're now ready to start building amazing features for Platform.Bible.
          </p>
        </div>
        
        <div className="tw-bg-gray-50 tw-rounded-lg tw-p-6 tw-mb-6">
          <h2 className="tw-text-2xl tw-font-semibold tw-text-gray-800 tw-mb-4">
            🚀 Next Steps:
          </h2>
          <ol className="tw-list-decimal tw-list-inside tw-space-y-3 tw-text-gray-700">
            <li className="tw-text-base">
              <strong>Edit this webview:</strong> Modify <code className="tw-bg-white tw-px-2 tw-py-1 tw-rounded tw-text-sm">src/web-views/welcome.web-view.tsx</code> to create your own UI
            </li>
            <li className="tw-text-base">
              <strong>Add extension logic:</strong> Update <code className="tw-bg-white tw-px-2 tw-py-1 tw-rounded tw-text-sm">src/main.ts</code> to add functionality
            </li>
            <li className="tw-text-base">
              <strong>Watch for changes:</strong> Run <code className="tw-bg-white tw-px-2 tw-py-1 tw-rounded tw-text-sm">npm run watch</code> for live development
            </li>
            <li className="tw-text-base">
              <strong>Test your extension:</strong> Use <code className="tw-bg-white tw-px-2 tw-py-1 tw-rounded tw-text-sm">cd ../paranext-core && npm start</code>
            </li>
          </ol>
        </div>
        
        <div className="tw-bg-blue-50 tw-rounded-lg tw-p-6 tw-mb-6">
          <h3 className="tw-text-lg tw-font-semibold tw-text-blue-800 tw-mb-3">
            📚 Development Resources:
          </h3>
          <ul className="tw-list-disc tw-list-inside tw-space-y-2 tw-text-blue-700">
            <li>Platform.Bible Documentation: <a href="#" className="tw-underline">docs.platform.bible</a></li>
            <li>Extension API Reference: Check the types in your <code>src/types/</code> directory</li>
            <li>React Components: Use components from <code>platform-bible-react</code></li>
            <li>Styling: Utility-first CSS with Tailwind (prefix classes with <code>tw-</code>)</li>
          </ul>
        </div>
        
        <div className="tw-text-center">
          <Button className="tw-bg-blue-600 tw-text-white tw-px-6 tw-py-3 tw-rounded-lg tw-font-semibold hover:tw-bg-blue-700 tw-transition-colors">
            Start Building! 🛠️
          </Button>
        </div>
      </div>
    </div>
  );
};
EOF
    
    print_success "Created welcome webview component"
    
    # Update main.ts to include the welcome webview
    cat > "src/main.ts" << EOF
import papi, { logger } from "@papi/backend";
import type {
  ExecutionActivationContext,
  IWebViewProvider,
  SavedWebViewDefinition,
  WebViewDefinition,
} from '@papi/core';

// Import our WebView file as a string (will be bundled)
import welcomeWebView from "./web-views/welcome.web-view?inline";

const welcomeWebViewType = "${KEBAB_NAME}.welcome";

/**
 * WebView provider that provides the welcome WebView when requested
 */
const welcomeWebViewProvider: IWebViewProvider = {
  async getWebView(
    savedWebView: SavedWebViewDefinition
  ): Promise<WebViewDefinition | undefined> {
    if (savedWebView.webViewType !== welcomeWebViewType)
      throw new Error(
        \`\${welcomeWebViewType} provider received request to provide a \${savedWebView.webViewType} WebView\`
      );
    return {
      ...savedWebView,
      title: "${EXTENSION_NAME} - Welcome",
      content: welcomeWebView,
    };
  },
};

export async function activate(context: ExecutionActivationContext) {
  logger.info("${EXTENSION_NAME} extension is activating!");

  // Register the welcome webview provider
  const welcomeWebViewProviderPromise = papi.webViewProviders.registerWebViewProvider(
    welcomeWebViewType,
    welcomeWebViewProvider
  );

  // Open the welcome webview automatically
  papi.webViews.openWebView(welcomeWebViewType, undefined, { existingId: "?" });

  context.registrations.add(await welcomeWebViewProviderPromise);

  logger.info("${EXTENSION_NAME} extension finished activating!");
}

export async function deactivate() {
  logger.info("${EXTENSION_NAME} extension is deactivating!");
  return true;
}
EOF
    
    print_success "Updated main.ts with welcome webview"
}

# Function to create symlink in paranext-core extensions
create_extension_symlink() {
    print_info "Setting up extension symlink in paranext-core..."
    
    local extension_dist_path="$WORKSPACE_DIR/$KEBAB_NAME/dist"
    local paranext_extensions_path="$WORKSPACE_DIR/paranext-core/extensions/dist"
    
    # Check if paranext-core/extensions/dist directory exists
    if [ ! -d "$paranext_extensions_path" ]; then
        print_error "paranext-core/extensions/dist directory not found!"
        print_info "Make sure paranext-core is properly set up and built."
        return 1
    fi
    
    # Check if extension dist directory exists (will be created after build)
    if [ ! -d "$extension_dist_path" ]; then
        print_warning "Extension dist directory not found yet."
        print_info "The symlink will point to: $extension_dist_path"
        print_info "Make sure to build your extension with 'npm run build' first."
    fi
    
    # Create symlink in paranext-core/extensions/dist
    local symlink_path="$paranext_extensions_path/$KEBAB_NAME"
    
    # Remove existing symlink if it exists
    if [ -L "$symlink_path" ]; then
        rm "$symlink_path"
        print_info "Removed existing symlink"
    elif [ -e "$symlink_path" ]; then
        print_error "A file or directory already exists at $symlink_path"
        print_info "Please remove it manually and try again."
        return 1
    fi
    
    # Create the symlink
    ln -s "$extension_dist_path" "$symlink_path"
    
    if [ $? -eq 0 ]; then
        print_success "Created symlink: $symlink_path -> $extension_dist_path"
        print_info "Your extension will be available in Platform.Bible after building!"
    else
        print_error "Failed to create symlink"
        return 1
    fi
}

# Function to install dependencies
install_dependencies() {
    print_info "Installing dependencies..."
    
    # Remove package-lock.json to regenerate with new name
    if [ -f "package-lock.json" ]; then
        rm package-lock.json
    fi
    
    # Install dependencies
    npm install --silent
    
    print_success "Dependencies installed successfully!"
}

# Function to create initial git commit
create_git_commit() {
    print_info "Creating initial git commit..."
    
    git add .
    git commit -m "Initial commit: Created $EXTENSION_NAME extension from template

Target Platform.Bible version: v0.4.0
Extension Template: paranext-extension-template
Created: $(date)
Kebab case: $KEBAB_CASE
Camel case: $CAMEL_CASE
Pascal case: $PASCAL_CASE" --quiet
    
    print_success "Initial commit created with version info!"
}

# Function to test the build
test_build() {
    print_info "Testing extension build..."
    
    if npm run build --silent; then
        print_success "Extension builds successfully!"
    else
        print_error "Build failed! Please check the output above."
        return 1
    fi
}

# Function to show completion summary
show_completion() {
    echo
    print_success "🎉 Extension creation completed successfully!"
    echo
    echo -e "${GREEN}Extension Details:${NC}"
    echo "  📛 Name: $EXTENSION_NAME"
    echo "  📁 Directory: $KEBAB_NAME"
    echo "  👤 Author: $AUTHOR_NAME"
    echo "  📄 Description: $DESCRIPTION"
    echo "  🎯 Target Version: Platform.Bible v0.4.0"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. cd $KEBAB_NAME"
    echo "  2. npm run build             # Build the extension (creates dist directory)"
    echo "  3. npm run watch             # Start development mode"
    echo "  4. cd ../paranext-core && npm start  # Test in Platform.Bible"
    echo
    echo -e "${BLUE}Development commands:${NC}"
    echo "  📦 npm run build          # Build for development"
    echo "  🔄 npm run watch          # Watch and rebuild on changes"
    echo "  🚀 cd ../paranext-core && npm start  # Start Platform.Bible with extension"
    echo "  🧹 npm run lint           # Check code quality"
    echo "  ✨ npm run format         # Format code"
    echo "  📋 npm run package        # Create distributable package"
    echo
    echo -e "${GREEN}✅ Extension symlinked to paranext-core/extensions/dist/${NC}"
    echo -e "${BLUE}Your extension will appear in Platform.Bible after building!${NC}"
    echo
    print_info "Happy coding! 🚀"
}

# Function to show help
show_help() {
    echo "Paranext Extension Creator Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -n, --name NAME         Extension name (interactive if not provided)"
    echo "  -a, --author AUTHOR     Author name"
    echo "  -p, --publisher PUB     Publisher name"
    echo "  -d, --description DESC  Extension description"
    echo "  -w, --workspace DIR     Workspace directory (default: current)"
    echo "  --skip-deps             Skip dependency installation"
    echo "  --skip-git              Skip git initialization"
    echo "  --skip-test             Skip build test"
    echo
    echo "Examples:"
    echo "  $0                                          # Interactive mode"
    echo "  $0 -n \"My Extension\" -a \"John Doe\"        # Semi-automated"
    echo "  $0 --name \"Bible Helper\" --skip-deps      # Skip dependency install"
}

# Parse command line arguments
SKIP_DEPS=false
SKIP_GIT=false
SKIP_TEST=false
WORKSPACE_DIR="."  # Default to current directory

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--name)
            EXTENSION_NAME="$2"
            shift 2
            ;;
        -a|--author)
            AUTHOR_NAME="$2"
            shift 2
            ;;
        -p|--publisher)
            PUBLISHER_NAME="$2"
            shift 2
            ;;
        -d|--description)
            DESCRIPTION="$2"
            shift 2
            ;;
        -w|--workspace)
            WORKSPACE_DIR="$2"
            shift 2
            ;;
        --skip-deps)
            SKIP_DEPS=true
            shift
            ;;
        --skip-git)
            SKIP_GIT=true
            shift
            ;;
        --skip-test)
            SKIP_TEST=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_header
    
    # Check prerequisites
    check_prerequisites
    
    # Setup paranext-core with correct version
    setup_paranext_core
    
    # Get user input (skip if provided via command line)
    if [ -z "$EXTENSION_NAME" ]; then
        get_user_input
    else
        # Generate case variations from provided name
        KEBAB_NAME=$(to_kebab_case "$EXTENSION_NAME")
        CAMEL_NAME=$(to_camel_case "$KEBAB_NAME")
        PASCAL_NAME=$(to_pascal_case "$CAMEL_NAME")
        
        # Set defaults for optional parameters
        [ -z "$AUTHOR_NAME" ] && AUTHOR_NAME="Your Name"
        [ -z "$PUBLISHER_NAME" ] && PUBLISHER_NAME="yourPublisher"
        [ -z "$DESCRIPTION" ] && DESCRIPTION="A Platform.Bible extension"
        [ -z "$WORKSPACE_DIR" ] && WORKSPACE_DIR="."
    fi
    
    # Execute setup steps
    setup_template
    rename_files
    update_files
    create_welcome_webview
    create_extension_symlink
    
    if [ "$SKIP_DEPS" = false ]; then
        install_dependencies
    else
        print_warning "Skipping dependency installation"
    fi
    
    if [ "$SKIP_GIT" = false ]; then
        create_git_commit
    else
        print_warning "Skipping git initialization"
    fi
    
    if [ "$SKIP_TEST" = false ]; then
        test_build
    else
        print_warning "Skipping build test"
    fi
    
    show_completion
}

# Error handling
trap 'print_error "Script interrupted"; exit 1' INT TERM

# Run main function
main "$@"
