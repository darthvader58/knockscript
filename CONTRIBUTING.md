# Contributing to KnockScript

Thank you for your interest in contributing to KnockScript! This document provides guidelines and information for contributors who want to help improve this unique programming language based on knock-knock jokes.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [How to Contribute](#how-to-contribute)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Language Design Principles](#language-design-principles)
- [Community Guidelines](#community-guidelines)

## Getting Started

KnockScript is a programming language that uses knock-knock joke syntax to make programming more fun and accessible. Every statement begins with "Knock knock" followed by "Who's there?" and the command.

### Prerequisites

- Ruby 3.2.0 or higher
- Git
- A sense of humor

### Quick Start

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/darthvader58/knockscript.git
   cd knockscript
   ```
3. **Install dependencies**:
   ```bash
   bundle install
   ```
4. **Test the installation**:
   ```bash
   ruby knockscript.rb examples/hello_world.ks
   ```

## Development Setup

### Local Development

1. **Run the web interface locally**:
   ```bash
   ruby web/app.rb
   ```
   Then visit `http://localhost:4567`

2. **Test the CLI**:
   ```bash
   ruby knockscript.rb examples/classes.ks
   ```

### Docker Development

1. **Build the Docker image**:
   ```bash
   docker build -t knockscript .
   ```

2. **Run the container**:
   ```bash
   docker run -p 4567:4567 knockscript
   ```

## Project Structure

```
knockscript/
├── knockscript.rb      # Main entry point and CLI
├── lexer.rb           # Tokenizes KnockScript source code
├── parser.rb          # Parses tokens into Abstract Syntax Tree
├── interpreter.rb     # Executes the AST
├── ast_nodes.rb       # AST node definitions
├── token.rb           # Token class definition
├── environment.rb     # Variable scope management
├── examples/          # Example KnockScript programs
│   ├── hello_world.ks
│   └── classes.ks
├── web/               # Web interface
│   ├── app.rb         # Sinatra web server
│   └── public/        # Static web assets
├── config.ru          # Rack configuration
└── Dockerfile         # Container configuration
```

### Core Components

- **Lexer**: Converts source code into tokens
- **Parser**: Builds an Abstract Syntax Tree from tokens
- **Interpreter**: Executes the AST and manages program state
- **Web Interface**: Browser-based code editor and runner

## How to Contribute

### Types of Contributions

1. **Bug Fixes**: Fix issues in the lexer, parser, or interpreter
2. **New Features**: Add language constructs or improve existing ones
3. **Documentation**: Improve code comments, examples, or this guide
4. **Web Interface**: Enhance the online editor and user experience
5. **Examples**: Create new example programs showcasing language features
6. **Testing**: Add unit tests or integration tests
7. **Performance**: Optimize the interpreter or web interface

### Finding Issues to Work On

- Check the [Issues](https://github.com/darthvader58/knockscript/issues) tab for open bugs and feature requests
- Look for issues labeled `good first issue` for beginner-friendly tasks
- Issues labeled `help wanted` are specifically looking for contributors
- Feel free to propose new features by opening an issue first

### Issue Template

When creating a new issue, please use the appropriate template below:

#### Bug Report Template

```markdown
## Bug Report

### Description
A clear and concise description of what the bug is.

### Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

### Expected Behavior
A clear and concise description of what you expected to happen.

### Actual Behavior
A clear and concise description of what actually happened.

### KnockScript Code (if applicable)
```knockscript
Knock knock
Who's there?
[Your code that causes the issue]
```

### Error Message
```
[Paste the full error message here]
```

### Environment
- Ruby version: [e.g. 3.2.0]
- Operating System: [e.g. macOS 13.0, Ubuntu 20.04, Windows 11]
- Browser (for web interface issues): [e.g. Chrome 91, Firefox 89]

### Additional Context
Add any other context about the problem here, such as screenshots or related issues.
```

#### Feature Request Template

```markdown
## Feature Request

### Summary
A brief description of the feature you'd like to see added.

### Motivation
Explain why this feature would be useful and what problem it solves.

### Detailed Description
Provide a detailed description of how the feature should work.

### Proposed KnockScript Syntax
```knockscript
Knock knock
Who's there?
YourProposedFeature
YourProposedFeature who? [example syntax]
```

### Alternative Solutions
Describe any alternative solutions or features you've considered.

### Implementation Notes
If you have ideas about how this could be implemented, share them here.

### Priority
- [ ] Low - Nice to have
- [ ] Medium - Would improve the language significantly
- [ ] High - Essential for language completeness

### Willing to Implement
- [ ] Yes, I can work on this
- [ ] Yes, but I need guidance
- [ ] No, but I can help test
- [ ] No, just suggesting the idea
```

#### Documentation Issue Template

```markdown
## Documentation Issue

### Type of Documentation Issue
- [ ] Missing documentation
- [ ] Incorrect documentation
- [ ] Unclear documentation
- [ ] Outdated documentation

### Location
Where is the documentation issue located? (file name, section, URL, etc.)

### Description
Describe what's wrong or missing in the documentation.

### Suggested Improvement
If you have suggestions for how to improve the documentation, please describe them here.

### Additional Context
Any additional context or examples that would help improve the documentation.
```

## Code Style Guidelines

### Ruby Code Style

- Follow standard Ruby conventions (2-space indentation, snake_case)
- Use descriptive variable and method names
- Add comments for complex logic, especially in the parser
- Keep methods focused and under 20 lines when possible

### KnockScript Language Style

- All statements must follow the knock-knock joke pattern
- Keywords should be intuitive and English-like
- Maintain consistency with existing language constructs

## Testing

### Running Tests

Currently, the project uses manual testing with example files. To test your changes:

1. **Test basic functionality**:
   ```bash
   ruby knockscript.rb examples/hello_world.ks
   ruby knockscript.rb examples/classes.ks
   ```

2. **Test the web interface**:
   ```bash
   ruby web/app.rb
   # Visit http://localhost:4567 and test the examples
   ```

### Adding Tests

We welcome contributions to add a proper test suite! Consider:

- Unit tests for lexer token generation
- Parser tests for AST construction
- Interpreter tests for execution correctness
- Integration tests for the web interface

### Test-Driven Development

When adding new features:

1. Write a KnockScript example demonstrating the feature
2. Implement the lexer changes (if needed)
3. Implement the parser changes
4. Implement the interpreter changes
5. Test with your example

## Submitting Changes

### Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Test thoroughly**:
   - Run existing examples
   - Test your new feature
   - Check the web interface works

4. **Commit with clear messages**:
   ```bash
   git commit -m "Add support for switch statements in KnockScript"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request** with:
   - Clear description of changes
   - Example KnockScript code demonstrating the feature
   - Any breaking changes noted

### Pull Request Guidelines

- **One feature per PR**: Keep changes focused and reviewable
- **Include examples**: Show how your feature works with KnockScript code
- **Update documentation**: Add to examples or comments as needed
- **Test thoroughly**: Ensure existing functionality still works
- **Be responsive**: Address review feedback promptly

### Pull Request Template

When submitting a pull request, please use this template:

```markdown
## Pull Request Description

### Summary
Brief description of what this PR does and why it's needed.

### Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

### Changes Made
- List the specific changes made in this PR
- Include any new files added or removed
- Mention any modified components (lexer, parser, interpreter, web interface)

### Testing
Describe how you tested your changes:
- [ ] Tested with existing examples (hello_world.ks, classes.ks)
- [ ] Created new test cases
- [ ] Verified web interface functionality
- [ ] Tested edge cases

### Example Usage
If this PR adds new language features, provide KnockScript code examples:

```knockscript
Knock knock
Who's there?
YourNewFeature
YourNewFeature who? [example usage]
```

### Breaking Changes
List any breaking changes and migration steps if applicable.

### Additional Notes
Any additional information, context, or screenshots that would be helpful for reviewers.

### Checklist
- [ ] Code follows the project's style guidelines
- [ ] Self-review of code completed
- [ ] Code is commented, particularly in hard-to-understand areas
- [ ] Corresponding changes to documentation made
- [ ] No new warnings introduced
- [ ] All existing tests pass
- [ ] New tests added for new functionality (if applicable)
```

## Language Design Principles

When contributing to KnockScript, keep these principles in mind:

### 1. Humor and Accessibility
- The language should be fun and approachable
- Syntax should feel like natural knock-knock jokes
- Error messages can be playful but still helpful

### 2. Consistency
- All statements follow the "Knock knock" → "Who's there?" → Command → "Command who?" pattern
- Keywords should be intuitive English words
- Similar operations should have similar syntax

### 3. Simplicity
- Prefer simple, readable syntax over complex features
- Each language construct should have a clear purpose
- Avoid unnecessary complexity

### 4. Completeness
- The language should support fundamental programming concepts
- Object-oriented features should be intuitive
- Control flow should be expressive


## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Keep discussions relevant to the project
- Have fun! This is a humor-based language after all

### Communication

- Use GitHub Issues for bug reports and feature requests
- Use Pull Request comments for code-specific discussions
- Be clear and concise in your communications
- Ask questions if you're unsure about anything

### Getting Help

- Check existing issues and documentation first
- Open an issue if you're stuck or have questions
- Tag maintainers if you need urgent help
- Join discussions on existing issues and PRs

## Recognition

Contributors will be recognized in:
- The project README
- Release notes for significant contributions
- Special thanks for first-time contributors

## License

By contributing to KnockScript, you agree that your contributions will be licensed under the same license as the project.

---

## Quick Contribution Checklist

Before submitting a PR, ensure:

- [ ] Code follows Ruby style guidelines
- [ ] New KnockScript syntax follows knock-knock joke pattern
- [ ] Examples work with `ruby knockscript.rb examples/your_example.ks`
- [ ] Web interface still functions correctly
- [ ] Changes are documented (comments, examples, etc.)
- [ ] Commit messages are clear and descriptive
- [ ] PR description explains the change and includes examples

---

**Thank you for contributing to KnockScript! Every contribution, no matter how small, helps make programming more fun and accessible.**

*Knock knock! Who's there? A new contributor! A new contributor who? A new contributor who's about to make KnockScript even more awesome!*