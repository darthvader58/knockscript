# KnockScript

A programming language based on knock-knock jokes. Every statement follows the classic "Knock knock" → "Who's there?" → Command → "Command who?" pattern.

## Quick Start

### Installation

```bash
git clone https://github.com/darthvader58/knockscript.git
cd knockscript
bundle install
```

### Run a Program

```bash
ruby knockscript.rb examples/hello_world.ks
```

### Web Interface

```bash
ruby web/app.rb
# Visit http://localhost:4567
```

## Language Syntax

### Hello World

```knockscript
Knock knock
Who's there?
Print
Print who? "Hello, World!"
```

### Variables

```knockscript
Knock knock
Who's there?
Set
Set who? x to 42
```

### Conditionals

```knockscript
Knock knock
Who's there?
If
If who? x greater than 10
    Knock knock
    Who's there?
    Print
    Print who? "x is big"
Otherwise
    Knock knock
    Who's there?
    Print
    Print who? "x is small"
Done
```

### Classes

```knockscript
Knock knock
Who's there?
Class
Class who? Person with name and age

Knock knock
Who's there?
Set
Set who? alice to new Person with name "Alice" and age 30
```

## Features

- Variables and arithmetic operations
- Control flow (if/else, while, for loops)
- Object-oriented programming (classes, methods, attributes)
- Arrays and basic data structures
- Web-based code editor and runner

## Project Structure

- `knockscript.rb` - Main CLI entry point
- `lexer.rb` - Tokenizer
- `parser.rb` - AST builder
- `interpreter.rb` - Code executor
- `web/` - Web interface
- `examples/` - Sample programs

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

APACHE 2.0 License - see LICENSE file for details.