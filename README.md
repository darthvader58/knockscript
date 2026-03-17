# KnockScript

A toy programming language built around knock-knock jokes. Version two keeps the same four-line rhythm, but the commands now use joke names that read more like punchlines than placeholders.

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
Lettuce
Lettuce who? "Hello, World!"
```

### Variables

```knockscript
Knock knock
Who's there?
Alby-Setin
Alby-Setin who? x to 42
```

### Conditionals

```knockscript
Knock knock
Who's there?
Anita
Anita who? x greater than 10
    Knock knock
    Who's there?
    Lettuce
    Lettuce who? "x is big"
Anita also x equal to 10
    Knock knock
    Who's there?
    Lettuce
    Lettuce who? "x is exactly ten"
Otherwise
    Knock knock
    Who's there?
    Lettuce
    Lettuce who? "x is small"
Done
```

### Classes, Methods, and Calls

```knockscript
Knock knock
Who's there?
Kit
Kit who? Person with name and age

Knock knock
Who's there?
Dewey
Dewey who? greet for Person
    Knock knock
    Who's there?
    Lettuce
    Lettuce who? name
Done

Knock knock
Who's there?
Alby-Setin
Alby-Setin who? alice to Fresh Person with name "Alice" and age 30

Knock knock
Who's there?
Europe
Europe who? greet on alice
```

### Arrays

```knockscript
Knock knock
Who's there?
Alby-Setin
Alby-Setin who? nums to list with 1, 2, 3

Knock knock
Who's there?
Sherwood
Sherwood who? 4 to nums

Knock knock
Who's there?
Patcha
Patcha who? 1 of nums to 99

Knock knock
Who's there?
Lettuce
Lettuce who? Howie nums
```

### Functions

```knockscript
Knock knock
Who's there?
Doozy
Doozy who? add with left and right
    Knock knock
    Who's there?
    Backatcha
    Backatcha who? left with extra right
Done

Knock knock
Who's there?
Lettuce
Lettuce who? Europe add with 2 and 3
```

### Dictionaries

```knockscript
Knock knock
Who's there?
Alby-Setin
Alby-Setin who? person to Oxford with name "Alice" and age 30

Knock knock
Who's there?
Lettuce
Lettuce who? Keysy name from person

Knock knock
Who's there?
Slotta
Slotta who? age of person to 31
```

## Features

- Variables, arithmetic, and comparisons
- Control flow (`Anita`, `Antil`, `Wanna`, `Anita also`, `Chance` / `Unlucky`)
- Object-oriented programming (`Kit`, `Dewey`, `Europe`, attributes)
- Arrays and basic data-structure helpers (`Howie`, `Whichy`, `Patcha`, `Dosset Dave`, `Skipper`)
- Dictionaries via `Oxford`, `Keysy`, and `Slotta`
- Standalone functions and return values
- Input plus loop control (`Askem`, `Enough`, `Carryon`)
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
