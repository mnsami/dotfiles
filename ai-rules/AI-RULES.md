# AI Rules Ecosystem

Centralized AI coding rules for Claude Code, Cursor, and other AI tools.

## Overview

This package provides a single source of truth for AI coding assistant rules that can be shared across all your projects. It uses [ai-rulez](https://github.com/Goldziher/ai-rulez) to generate tool-specific configurations.

## Structure

```
ai-rules/
├── .config/ai-rulez/           # Symlinked to ~/.config/ai-rulez/
│   ├── rules/                  # Core rules (always applied)
│   │   ├── core.md            # Universal coding standards
│   │   └── workflow.md        # Git, PR, code review conventions
│   ├── context/               # Reference documentation
│   │   └── architecture.md    # Architecture preferences
│   ├── skills/                # AI expert personas
│   │   ├── code-reviewer/     # Code review expertise
│   │   ├── debugger/          # Debugging expertise
│   │   └── architect/         # System design expertise
│   ├── domains/               # Language-specific rules
│   │   ├── go/
│   │   ├── php/
│   │   ├── typescript/
│   │   └── python/
│   └── commands/              # Slash commands (/review, /test, etc.)
└── templates/                 # Project setup templates
```

## Installation

### Prerequisites

1. Install GNU Stow:
   ```bash
   # macOS
   brew install stow

   # Ubuntu/Debian
   sudo apt install stow
   ```

2. Install ai-rulez:
   ```bash
   # Homebrew
   brew install goldziher/tap/ai-rulez

   # npm
   npm install -g ai-rulez

   # pip
   pip install ai-rulez
   ```

### Setup

1. Clone your dotfiles (if not already):
   ```bash
   git clone https://github.com/mnsami/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run stow to create symlinks:
   ```bash
   ./stow.sh install
   ```

   This creates: `~/.config/ai-rulez/` → symlinked to dotfiles

3. Verify installation:
   ```bash
   ls -la ~/.config/ai-rulez/
   ```

## Usage

### Setting Up a New Project

1. Create the ai-rulez config in your project:
   ```bash
   mkdir -p .ai-rulez
   cp ~/dotfiles/ai-rules/templates/ai-rulez.yml.template .ai-rulez/config.yaml
   ```

2. Edit `.ai-rulez/config.yaml` to select your language profile:
   ```yaml
   includes:
     - name: mnsami-standards
       source: https://github.com/mnsami/dotfiles.git
       path: ai-rules/.config/ai-rulez
       merge_strategy: local-override

   profiles:
     default: [go]  # or [php], [typescript], [python], or multiple

   presets:
     - claude
     - cursor
   ```

3. Generate AI tool configs:
   ```bash
   ai-rulez generate
   ```

   This creates:
   - `CLAUDE.md` - for Claude Code
   - `.cursor/rules/*.mdc` - for Cursor

4. (Optional) Add project-specific rules:
   ```bash
   cp ~/dotfiles/ai-rules/templates/project-rules.md.template .ai-rulez/rules/project.md
   # Edit with your project-specific constraints
   ```

### Updating Rules

When you update rules in your dotfiles:

1. Commit and push changes to your dotfiles repo
2. In each project, regenerate:
   ```bash
   ai-rulez generate
   ```

### Available Profiles

| Profile | Description |
|---------|-------------|
| `go` | Go development standards |
| `php` | PHP/Laravel/Symfony standards |
| `typescript` | TypeScript/React/Node.js standards |
| `python` | Python/FastAPI/Django standards |

Combine profiles for full-stack projects:
```yaml
profiles:
  default: [go, typescript]
```

### Available Commands

| Command | Description |
|---------|-------------|
| `/review` | Code review with severity levels |
| `/refactor` | Suggest refactoring improvements |
| `/test` | Generate comprehensive tests |
| `/explain` | Explain code at appropriate depth |

### Available Skills

| Skill | Description |
|-------|-------------|
| `code-reviewer` | Expert code review feedback |
| `debugger` | Systematic debugging assistance |
| `architect` | System design and architecture |
| `go-expert` | Go-specific expertise |
| `php-expert` | PHP-specific expertise |
| `ts-expert` | TypeScript-specific expertise |
| `python-expert` | Python-specific expertise |

## Customization

### Adding New Rules

1. Create a new markdown file in the appropriate directory:
   ```bash
   vim ~/.config/ai-rulez/rules/my-custom-rule.md
   ```

2. Add frontmatter for priority and targeting:
   ```markdown
   ---
   priority: high
   targets: ["CLAUDE.md"]
   ---
   # My Custom Rule

   Your rule content here...
   ```

3. Restow to update symlinks:
   ```bash
   cd ~/dotfiles && ./stow.sh restow
   ```

### Adding a New Language Domain

1. Create the domain structure:
   ```bash
   mkdir -p ~/.config/ai-rulez/domains/rust/{rules,skills/rust-expert}
   ```

2. Add rules and skills for the language

3. Use the domain in projects:
   ```yaml
   profiles:
     default: [rust]
   ```

## Troubleshooting

### Symlinks not working

```bash
# Check if stow is installed
which stow

# Reinstall symlinks
cd ~/dotfiles
./stow.sh restow
```

### ai-rulez not finding global config

Ensure `~/.config/ai-rulez/` exists and contains your rules:
```bash
ls -la ~/.config/ai-rulez/
```

### Generated files are empty

Check that your `includes` path in `config.yaml` is correct and the dotfiles repo is accessible.

## Contributing

To modify the shared rules:

1. Edit files in `~/dotfiles/ai-rules/.config/ai-rulez/`
2. Test locally with `ai-rulez generate` in a project
3. Commit and push to the dotfiles repo
4. Other projects will get updates on next `ai-rulez generate`
